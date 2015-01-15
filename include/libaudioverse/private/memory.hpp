/**Copyright (C) Austin Hicks, 2014
This file is part of Libaudioverse, a library for 3D and environmental audio simulation, and is released under the terms of the Gnu General Public License Version 3 or (at your option) any later version.
A copy of the GPL, as well as other important copyright and licensing information, may be found in the file 'LICENSE' in the root of the Libaudioverse repository.  Should this file be missing or unavailable to you, see <http://www.gnu.org/licenses/>.*/
#pragma once
#include <map>
#include <memory>
#include <string.h>
#include <mutex>
//contains some various memory-related bits and pieces, as well as the smart pointer marshalling.

/**This is a standalone component that knows how to hold onto smart pointers, avoid accidentally duplicating entries, and cast the entries before giving them to us.

Asking for an entry that is not present gives a null pointer.

the reason that this is not a class is because there can only ever be one.  This serves the explicit purpose of allowing us to give pointers to and receive pointers from things outside Libaudioverse; therefore, it's a global and some helper functions.

This also implements Lav_free, which works the same for all pointers.*/

extern std::map<void*, std::shared_ptr<void>> *external_ptrs;
extern std::mutex *memory_lock;

template <class t>
std::shared_ptr<t> incomingPointer(void* ptr) {
	auto guard = std::lock_guard<std::mutex>(*memory_lock);
	if(external_ptrs->count(ptr) == 0) return nullptr;
	return std::static_pointer_cast<t, void>(external_ptrs->at(ptr));
}

template <class t>
t* outgoingPointer(std::shared_ptr<t> ptr) {
	auto guard = std::lock_guard<std::mutex>(*memory_lock);
	t* out = ptr.get();
	if(out == nullptr) return nullptr;
	if(external_ptrs->count(out) == 1) return out;
	(*external_ptrs)[out] = ptr;
	return out;
}

void initializeMemoryModule();

/**This template uses memcpy to perform a safe type pun and avoid violating strict aliasing.*/
template<class t>
t safeConvertMemory(char* b) {
	t tmp;
	memcpy(&tmp, b, sizeof(t));
	return tmp;
}

/**Libaudioverse allocation routines.

These return and free pointers to zero-initialized memory aligned on the appropriate boundary for the enabled SIMD extensions, if any.  If no SIMD extensions are enabled, these gracefully fall back to normal calloc/free.
*/

float* LavAllocFloatArray(unsigned int size);
void LavFreeFloatArray(float* ptr);

//custom deleter for smart pointer that guarantees thread safety.
class LavNode;
void LavNodeDeleter(LavNode *obj);