import sys
old_module = sys.modules['cloudpickle'] if sys.modules.__contains__('cloudpickle') else None
import tiledb.cloudpickle as internal_cloudpickle
sys.modules['cloudpickle'] = sys.modules['tiledb.cloudpickle']
sys.modules['cloudpickle'].__name__ = 'cloudpickle'
del internal_cloudpickle
sys.modules.pop('tiledb.cloudpickle')
from cloudpickle import *
sys.modules.pop('cloudpickle')
if old_module:
    sys.modules['cloudpickle'] = old_module
del old_module
del sys
