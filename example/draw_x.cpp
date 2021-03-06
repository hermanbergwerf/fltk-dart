// Copyright (c) 2016, Herman Bergwerf. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

// Based on: http://seriss.com/people/erco/fltk/#FltkX

#include <FL/Fl.H>
#include <FL/fl_draw.H>
#include <FL/Fl_Box.H>
#include <FL/Fl_Double_Window.H>

/// Widget that draws two diagonal lines
class XWidget : public Fl_Widget {
 public:
  /// Constuctor
  XWidget(int x, int y, int w, int h) : Fl_Widget(x, y, w, h, 0) {}

  /// Draws the lines
  void draw() {
    fl_color(FL_BLACK);
    int x1 = x(), y1 = y();
    int x2 = x() + w() - 1, y2 = y() + h() - 1;
    fl_line(x1, y1, x2, y2);
    fl_line(x1, y2, x2, y1);
  }
};

int main() {
  auto window = new Fl_Double_Window(200, 200, "X");
  auto x = new XWidget(0, 0, window -> w(), window -> h());
  window -> resizable(x);
  window -> show();
  return Fl::run();
}
