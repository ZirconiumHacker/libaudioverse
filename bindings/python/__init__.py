import jinja2
from collections import OrderedDict
import re
from .. import transformers
from .. import get_info

ctypes_map = {
'int' : 'c_int',
'unsigned int' : 'c_uint',
'float' : 'c_float',
'double' : 'c_double',
}

def ctypes_string(typeinfo, offset = 0):
	"""Convert a type to a ctypes string.  Offset is used by the template _lav.py.t to make output argument strings and is subtracted from the levels of indirection."""
	global typedefs
	if offset != 0:
		assert typeinfo.indirection-offset >= 0
		return ctypes_string(get_info.TypeInfo(typeinfo.base, typeinfo.indirection-offset))
	if typeinfo.base in typedefs:
		return ctypes_string(get_info.TypeInfo(typedefs[typeinfo.base].base, typedefs[typeinfo.base].indirection+typeinfo.indirection))
	if typeinfo.indirection == 1 and typeinfo.base == 'void':
		return "ctypes.c_void_p"
	elif typeinfo.indirection == 1 and typeinfo.base == 'char':
		return "ctypes.c_char_p"
	elif typeinfo.indirection == 0:
		return "ctypes." + ctypes_map[typeinfo.base]
	else:
		return "ctypes.POINTER(" + ctypes_string(get_info.TypeInfo(typeinfo.base, typeinfo.indirection-1)) + ")"

def make_python(info):
	#we have to inject into the global namespace: the templates should not have to move typedef info around for us.
	global typedefs
	typedefs = info['typedefs']
	context = dict()
	context.update(info)
	env = jinja2.Environment(loader = jinja2.PackageLoader(__package__, ""), undefined = jinja2.StrictUndefined, trim_blocks = True)
	env.filters.update(transformers.get_jinja2_filters())
	env.filters['ctypes_string'] = ctypes_string
	return {
		'_lav.py' : env.get_template('_lav.py.t').render(context),
		'_libaudioverse.py' : env.get_template('_libaudioverse.py.t').render(context),
		'libaudioverse.py': env.get_template('libaudioverse.py.t').render(context)
	}
