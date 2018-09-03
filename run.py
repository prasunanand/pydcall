from ctypes import *

libc = cdll.LoadLibrary("./build/pydcall.so")
libc.sayHello()
