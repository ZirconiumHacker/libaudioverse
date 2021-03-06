/* Copyright 2016 Libaudioverse Developers. See the COPYRIGHT
file at the top-level directory of this distribution.

Licensed under the mozilla Public License, version 2.0 <LICENSE.MPL2 or
https://www.mozilla.org/en-US/MPL/2.0/> or the Gbnu General Public License, V3 or later
<LICENSE.GPL3 or http://www.gnu.org/licenses/>, at your option. All files in the project
carrying such notice may not be copied, modified, or distributed except according to those terms. */
#pragma once
#include "../libaudioverse.h"
#include "../libaudioverse3d.h"
#include "../libaudioverse_properties.h"
#include <vector>
#include <set>
#include <memory>
#include <tuple>
#include <glm/glm.hpp>

namespace libaudioverse_implementation {

class SourceNode;
class HrtfData;
class Server;
class Buffer;
class BufferNode;


/**Configuration of an effect send.*/
class EffectSendConfiguration {
	public:
	int channels = 0; //1, 2, 4, 6, or 8.
	int start = 0; //The output we start at.
	bool is_reverb = false; //For 4-channel effect sends, if we should use reverb-type panning.
	bool connect_by_default = false; //If sources should be connected to this send by default.
};

/**This holds info on listener positions, defaults, etc.
Anything a source needs for updating, basically.

Sources update this struct as needed if they are not delegating to the environment, then use it for processing.
Otherwise, sources just use the values herein.

The following initialization values dont matter, but we want the struct to be valid anyway.*/
class EnvironmentInfo {
	public:
	glm::mat4 world_to_listener_transform;
	//These avoid tons of property lookups.
	//Each lookup on the environment is a shared_ptr indirection and a dictionary lookup.
	int panning_strategy = Lav_PANNING_STRATEGY_HRTF;
	bool panning_strategy_changed = false;
	int distance_model = Lav_DISTANCE_MODEL_LINEAR;
	bool distance_model_changed = false;
	float min_distance = 0.0, max_distance = 0.0;
	float reverb_distance = 0.0;
	float min_reverb_level = 0.0, max_reverb_level = 1.0;
};

/**The sorce and environment model does not use the standard node and implementation separation.

Sources write directly to special buffers in the environment, which are then copied to the environment's output in the process method.
*/

class EnvironmentNode: public Node {
	public:
	EnvironmentNode(std::shared_ptr<Server> server, std::shared_ptr<HrtfData> hrtf);
	~EnvironmentNode();
	void registerSourceForUpdates(std::shared_ptr<SourceNode> source, bool useEffectSends = true);
	//Maybe change our output channels.
	//Also update sources, which might reconfigure themselves.
	virtual void willTick() override;
	virtual void process() override;
	//Force overrides and short circuits the property modification checks, and is used by the constructor.
	void updateEnvironmentInfo(bool force = false);
	//A helper to get the environment struct.
	EnvironmentInfo getEnvironmentInfo();
	std::shared_ptr<HrtfData> getHrtf();
	//Play buffer asynchronously at specified position, destroying the source when done.
	void playAsync(std::shared_ptr<Buffer> buffer, float x, float y, float z, bool isDry = false);
	//Manage effect sends.
	//Returns the integer identifier of the send.
	int addEffectSend(int channels, bool isReverb, bool connecctByDefault);
	EffectSendConfiguration& getEffectSend(int which);
	int getEffectSendCount();
	//This is a public variable; sources write directly to these buffers.
	//There are always at least 8 buffers, with additional buffers appended for effect sends.
	std::vector<float*> source_buffers;
	private:
	//while these may be parents (through virtue of the panners we give out), they also have to hold a reference to us-and that reference must be strong.
	//the world is more capable of handling a source that dies than a source a world that dies.
	std::set<std::weak_ptr<SourceNode>, std::owner_less<std::weak_ptr<SourceNode>>> sources;
	std::shared_ptr<HrtfData > hrtf;
	EnvironmentInfo environment_info;
	std::vector<EffectSendConfiguration> effect_sends;
	
	template<typename JobT, typename CallableT, typename... ArgsT>
	friend void environmentVisitDependencies(JobT&& start, CallableT &&callable, ArgsT&&... args);
	//This is used to make play_async not invalidate the plan.
	std::vector<std::tuple<std::shared_ptr<BufferNode>, std::shared_ptr<SourceNode>>> play_async_source_cache;
	int play_async_source_cache_limit = 30; //How many we're willing to cache.
};

std::shared_ptr<EnvironmentNode> createEnvironmentNode(std::shared_ptr<Server> server, std::shared_ptr<HrtfData> hrtf);
}