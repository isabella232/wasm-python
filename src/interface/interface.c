#include <Python.h>
//#include <stdio.h>
#include <emscripten.h>

// Stubs
int signal(int s, void (*func)(void)) { return 0; }
int siginterrupt(int s, int t) { return 0; }
int sigaction(int s, int t, int r) { return 0; }
int __libc_current_sigrtmin() { return 0; }
int __libc_current_sigrtmax() { return 0; }

EMSCRIPTEN_KEEPALIVE
void init() { Py_Initialize(); }

EMSCRIPTEN_KEEPALIVE
void pyeval(char* s) {
  printf("s='%s'\n", s);
  PyRun_SimpleString(s);
  // PyRun_SimpleString("from time import time; print('time=', time())");
}

EMSCRIPTEN_KEEPALIVE
void finalize() { Py_FinalizeEx(); }
