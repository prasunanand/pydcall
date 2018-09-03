module pydcall.app;

import core.runtime: Runtime;
import std.stdio: writeln;

auto initialized = false;

extern (C) void initializeIfNotAlreadyDone() {
  if (!initialized) {
    Runtime.initialize();
    initialized = true;
  }
}

extern(C) {
  void sayHello() {
    initializeIfNotAlreadyDone();
    writeln("Hello World!");
    writeln("Called from D!");
  }
}
