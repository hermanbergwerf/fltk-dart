// Copyright (c) 2016, Herman Bergwerf. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

// Force enable Cairo
#define USE_X11 1
#define FLTK_HAVE_CAIRO 1

#include <vector>

#include <FL/Fl.H>
#include <FL/Fl_Group.H>
#include <FL/Fl_Window.H>

#include <dart_api.h>

#include "common.hpp"
#include "custom.hpp"

#include "gen/functions/core.hpp"
#include "gen/functions/draw.hpp"
#include "gen/functions/color.hpp"
#include "gen/functions/event.hpp"

#include "gen/classes/Widget.hpp"
#include "gen/classes/Group.hpp"
#include "gen/classes/Box.hpp"
#include "gen/classes/Button.hpp"
#include "gen/classes/Input.hpp"
#include "gen/classes/Menu.hpp"
#include "gen/classes/Choice.hpp"
#include "gen/classes/TextBuffer.hpp"
#include "gen/classes/TextDisplay.hpp"
#include "gen/classes/TextEditor.hpp"
#include "gen/classes/Window.hpp"
#include "gen/classes/DoubleWindow.hpp"
#include "gen/classes/GlWindow.hpp"
#include "gen/classes/CairoWindow.hpp"

Dart_NativeFunction ResolveName(
  Dart_Handle name,
  int argc,
  bool *autoSetupScope);

DART_EXPORT Dart_Handle fldart_Init(Dart_Handle parentLibrary) {
  if (Dart_IsError(parentLibrary)) {
    return parentLibrary;
  }

  Dart_Handle resultCode = Dart_SetNativeResolver(
                             parentLibrary, ResolveName, NULL);
  if (Dart_IsError(resultCode)) {
    return resultCode;
  }

  // Initialize label types.
  fl_define_FL_SHADOW_LABEL();
  fl_define_FL_ENGRAVED_LABEL();
  fl_define_FL_EMBOSSED_LABEL();

  // Prevent dithering.
  Fl::visual(FL_RGB);

  return Dart_Null();
}

// TODO: use hashtable?
std::vector<fldart::FunctionMapping*> allFunctions = {
  fldart::custom::functionMapping,
  fldart::core::functionMapping,
  fldart::draw::functionMapping,
  fldart::color::functionMapping,
  fldart::event::functionMapping,
  fldart::Widget::functionMapping,
  fldart::Group::functionMapping,
  fldart::Box::functionMapping,
  fldart::Button::functionMapping,
  fldart::Input::functionMapping,
  fldart::Menu::functionMapping,
  fldart::Choice::functionMapping,
  fldart::TextBuffer::functionMapping,
  fldart::TextDisplay::functionMapping,
  fldart::TextEditor::functionMapping,
  fldart::Window::functionMapping,
  fldart::DoubleWindow::functionMapping,
  fldart::GlWindow::functionMapping,
  fldart::CairoWindow::functionMapping
};

Dart_NativeFunction ResolveName(Dart_Handle name, int argc, bool *autoSetupScope) {
  if (!Dart_IsString(name)) {
    return NULL;
  }

  Dart_NativeFunction result = NULL;
  Dart_EnterScope();
  const char *cname;
  fldart::HandleError(Dart_StringToCString(name, &cname));

  for (int ii = 0; ii < allFunctions.size(); ++ii) {
    for (int i = 0; allFunctions[ii][i].name != NULL; ++i) {
      if (strcmp(allFunctions[ii][i].name, cname) == 0) {
        result = allFunctions[ii][i].function;
        break;
      }
    }
  }

  Dart_ExitScope();
  return result;
}
