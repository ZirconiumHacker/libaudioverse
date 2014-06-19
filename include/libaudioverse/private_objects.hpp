/**Copyright (C) Austin Hicks, 2014
This file is part of Libaudioverse, a library for 3D and environmental audio simulation, and is released under the terms of the Gnu General Public License Version 3 or (at your option) any later version.
A copy of the GPL, as well as other important copyright and licensing information, may be found in the file 'LICENSE' in the root of the Libaudioverse repository.  Should this file be missing or unavailable to you, see <http://www.gnu.org/licenses/>.*/
#pragma once
#include "libaudioverse.h"
#include <map>

class LavProperty;

class LavInputDescriptor {
	public:
	LavObject* parent;
	unsigned int output;
};

/**Things all Libaudioverse objects have.*/
class LavObject {
	public:
	virtual void init(LavDevice* device, unsigned int numInputs, unsigned int numOutputs);
	virtual void computeInputBuffers();//update what we point to due to parent changes.
	virtual void setParent(unsigned int input, LavObject* parent, unsigned int parentOutput);
	virtual LavObject* getParentObject(unsigned int slot);
	virtual unsigned int getParentOutput(unsigned int slot);
	virtual unsigned int getInputCount();
	virtual unsigned int getOutputCount();
	virtual void getOutputPointers(float** dest);
	virtual void clearParent(unsigned int slot);
	virtual void process();
	virtual void processor();
	virtual LavDevice* getDevice();
	protected:
	LavDevice *device;
	std::map<int, LavProperty*> properties;
	float** inputs;
	LavInputDescriptor *input_descriptors;
	float** outputs;
	unsigned int num_outputs;
	unsigned int num_inputs;
	int is_processing;
	enum Lav_NODETYPES type;

	//this preventss all sorts of trouble.
	virtual ~LavObject() {}

	//we are never allowed to copy.
	LavObject(const LavObject&) = delete;
	LavObject& operator=(const LavObject&) = delete;
};

