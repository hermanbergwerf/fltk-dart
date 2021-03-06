// Copyright (c) 2016, Herman Bergwerf. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:fltk/fltk.dart' as fl;

/// Widget that draws two diagonal lines
class XWidget extends fl.Widget {
  XWidget(int x, int y, int w, int h) : super(x, y, w, h);

  /// Draws the lines
  void draw() {
    fl.color = fl.BLACK;
    int x1 = this.x(), y1 = this.y();
    int x2 = this.x() + this.w() - 1, y2 = this.y() + this.h() - 1;
    fl.line(x1, y1, x2, y2);
    fl.line(x1, y2, x2, y1);
  }
}

int main() {
  var window = new fl.DoubleWindow(200, 200, 'X');
  var x = new XWidget(0, 0, window.w(), window.h());
  window.resizable = x;
  window.show();
  return fl.run();
}
