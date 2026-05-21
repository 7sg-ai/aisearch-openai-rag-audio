import atexit
from langfuse.decorators import langfuse_context

atexit.register(langfuse_context.flush)
