import atexit

from langfuse import Langfuse

langfuse = Langfuse()
atexit.register(langfuse.flush)
