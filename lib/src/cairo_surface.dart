// Copyright (c) 2016, Herman Bergwerf. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of fltk;

/// Special implementation of Cairo using an [ImageSurface] from `cairodart` and
/// the `fl_draw_image` function from FLTK.
///
/// Note: this class is not currenly working because of issues with
/// [ImageSurface.data] in `cairodart`.
class CairoSurface extends Widget {
  /// Target [ImageSurface] (drawing canvas)
  cairo.ImageSurface _surface;

  /// Redraw event stream
  Stream<cairo.Context> onDraw;

  /// Redraw stream controller
  ///
  /// Note that this is a synchronous stream because all redraws have to be
  /// completed before drawing the surface data to the widget.
  final _onDrawController =
      new StreamController<cairo.Context>.broadcast(sync: true);

  CairoSurface(int x, int y, int w, int h) : super(x, y, w, h) {
    onDraw = _onDrawController.stream;

    // Initialize drawing surface.
    resizeSurface(w, h);

    onResize.listen((data) {
      if (data.w != _surface.width || data.h != _surface.height) {
        resizeSurface(data.w, data.h);
      }
    });
  }

  /// Resize [_surface].
  void resizeSurface(int width, int height) {
    if (_surface != null) {
      _surface.finish();
    }

    _surface = new cairo.ImageSurface(cairo.Format.ARGB32, width, height);
  }

  /// Get context for the image surface.
  cairo.Context getContext() => new cairo.Context(_surface);

  /// Redraw surface
  ///
  /// Do not override this method! To draw, you should draw directly to the
  /// image surface.
  void draw() {
    // Trigger surface updates.
    final ctx = getContext();
    _onDrawController.add(ctx); // Synchronous processing
    _surface.flush();

    // Draw pixel data. It turns out using drawRgbImage for this task is glitchy
    // for large canvasses. So if the OS does not provide alpha blending
    // support, no alpha for you!
    final pixeldata = _surface.data;
    bgraToRgba(pixeldata);
    unpremultiply(pixeldata);
    drawImage(pixeldata, x(), y(), _surface.width, _surface.height, 4);
  }
}
