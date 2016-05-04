// Copyright (c) 2016, Herman Bergwerf. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

#include "Window.hpp"

namespace fldart {
FunctionMapping Window::methods[] = {
  {"fldart::Window::createWindowShort", Window::createWindowShort},
  {"fldart::Window::createWindow", Window::createWindow},
  {NULL, NULL}
};

void Window::createWindowShort(Dart_NativeArguments arguments) {
  Fl_Window* instance;
  int64_t w;
  int64_t h;
  const char* l;

  Dart_EnterScope();

  // Resolve variables.
  HandleError(Dart_IntegerToInt64(HandleError(Dart_GetNativeArgument(arguments, 0)), &w));
  HandleError(Dart_IntegerToInt64(HandleError(Dart_GetNativeArgument(arguments, 1)), &h));
  HandleError(Dart_StringToCString(HandleError(Dart_GetNativeArgument(arguments, 2)), &l));

  instance = new Fl_Window(w, h, strcpy(new char[strlen(l) + 1], l));

  Dart_Handle result = Dart_NewInteger((int64_t)instance);
  Dart_SetReturnValue(arguments, result);
  Dart_ExitScope();
}

void Window::createWindow(Dart_NativeArguments arguments) {
  Fl_Window* instance;
  int64_t x;
  int64_t y;
  int64_t w;
  int64_t h;
  const char* l;

  Dart_EnterScope();

  // Resolve variables.
  HandleError(Dart_IntegerToInt64(HandleError(Dart_GetNativeArgument(arguments, 0)), &x));
  HandleError(Dart_IntegerToInt64(HandleError(Dart_GetNativeArgument(arguments, 1)), &y));
  HandleError(Dart_IntegerToInt64(HandleError(Dart_GetNativeArgument(arguments, 2)), &w));
  HandleError(Dart_IntegerToInt64(HandleError(Dart_GetNativeArgument(arguments, 3)), &h));
  HandleError(Dart_StringToCString(HandleError(Dart_GetNativeArgument(arguments, 4)), &l));

  instance = new Fl_Window(x, y, w, h, strcpy(new char[strlen(l) + 1], l));

  Dart_Handle result = Dart_NewInteger((int64_t)instance);
  Dart_SetReturnValue(arguments, result);
  Dart_ExitScope();
}
}
