// Copyright (c) 2016, Herman Bergwerf. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of fltk;

/// Widget callback function
typedef void Callback(Widget target, dynamic userData);

/// Widget handle function
typedef bool HandleFn(Event event, EventData data);

/// [Widget.onCallback] data
class WidgetCallbackData {
  final Widget target;
  final userData;
  WidgetCallbackData(this.target, this.userData);
}

/// [Widget.onResize] data
class WidgetResizeData {
  final int x, y, w, h;
  WidgetResizeData(this.x, this.y, this.w, this.h);
}

/// Fl_Widget
class Widget extends NativeFieldWrapperClass2 {
  /// User data
  dynamic userData;

  /// Callback function (classic style)
  Callback callback;

  /// Additional event handlers.
  final _eventHandlers = new List<HandleFn>();

  /// Callback stream (Dart style)
  Stream<WidgetCallbackData> onCallback;

  /// Resize stream
  Stream<WidgetResizeData> onResize;

  /// Callback stream controller
  final _onCallbackController =
      new StreamController<WidgetCallbackData>.broadcast(sync: useSyncStreams);

  /// Resize stream controller
  ///
  /// Note that this is a synchronous stream because to prevent resize and draw
  /// events from mixing up.
  final _onResizeController =
      new StreamController<WidgetResizeData>.broadcast(sync: true);

  /// Create Fl_Widget (uses a wrapper class under the hood).
  Widget(int x, int y, int w, int h, [String l = '']) {
    _createWidget(x, y, w, h, l);
    _setupStreams();
  }

  Widget.empty() {
    _setupStreams();
  }

  /// Setup streams (call on create).
  void _setupStreams() {
    onCallback = _onCallbackController.stream;
    onResize = _onResizeController.stream;
  }

  /// Add event handler.
  void addHandler(HandleFn fn) => _eventHandlers.add(fn);

  /// Handle event code (called by the extension using `Dart_Invoke`).
  int doHandle(int eventCode) {
    final event = Event.values[eventCode];
    final data = currentEvent;

    // Run own handler.
    var v = handle(event, data);

    // Run additional handlers
    for (final handler in _eventHandlers) {
      final _v = handler(event, data);
      v = v ? v : _v;
    }

    return v ? 1 : 0;
  }

  /// Handle event (called by [doHandle]).
  bool handle(Event event, EventData data) => false;

  /// Draw widget (called by the extension using `Dart_Invoke`)
  void draw() {}

  /// Run callbacks (called by the extension using `Dart_Invoke`)
  void doCallback() {
    _onCallbackController.add(new WidgetCallbackData(this, userData));
    if (callback != null) {
      callback(this, userData);
    }
  }

  /// The widget is resized (called by the extension using `Dart_Invoke`).
  /// If you override this method you should call `super.resize` to keep the
  /// [onResize] stream working.
  void resize(int x, int y, int w, int h) {
    _onResizeController.add(new WidgetResizeData(x, y, w, h));
  }

  /// Native constructor
  void _createWidget(int x, int y, int w, int h, String l)
      native 'fldart::Widget::constructor_Widget';

  /// Get widget x position.
  int x() native 'fldart::Widget::int_x';

  /// Get widget y position.
  int y() native 'fldart::Widget::int_y';

  /// Get widget width.
  int w() native 'fldart::Widget::int_w';

  /// Get widget height.
  int h() native 'fldart::Widget::int_h';

  /// Activate the widget.
  void activate() native 'fldart::Widget::void_activate';

  /// Deactivate the widget.
  void deactivate() native 'fldart::Widget::void_deactivate';

  /// Show widget.
  void show() native 'fldart::Widget::void_show';

  /// Hide widget.
  void hide() native 'fldart::Widget::void_hide';

  /// Redraw widget.
  void redraw() native 'fldart::Widget::void_redraw';

  /// Get label.
  String get label native 'fldart::Widget::String_label';

  /// Set label.
  set label(String text) native 'fldart::Widget::void_label';

  /// Get label font.
  int get labelfont native 'fldart::Widget::Fl_Font_labelfont';

  /// Set label font.
  set labelfont(int font) native 'fldart::Widget::void_labelfont';

  /// Get label size.
  int get labelsize native 'fldart::Widget::Fl_Fontsize_labelsize';

  /// Set label size.
  set labelsize(int pixels) native 'fldart::Widget::void_labelsize';

  int _labeltypeGet() native 'fldart::Widget::Fl_Labeltype_labeltype';

  void _labeltypeSet(int type) native 'fldart::Widget::void_labeltype';

  /// Get label type.
  Labeltype get labeltype => Labeltype.values[_labeltypeGet()];

  /// Set label type.
  set labeltype(Labeltype type) => _labeltypeSet(type.index);

  /// Get label color.
  int get labelcolor native 'fldart::Widget::Fl_Color_labelcolor';

  /// Set label color
  set labelcolor(int color) native 'fldart::Widget::void_labelcolor';

  /// Get background color.
  int get color native 'fldart::Widget::Fl_Color_color';

  /// Set background color.
  set color(int color) native 'fldart::Widget::void_color';

  /// Get label alignment.
  int get align native 'fldart::Widget::Fl_Align_align';

  /// Set label alignment.
  set align(int align) native 'fldart::Widget::void_align';

  void _boxSet(int type) native 'fldart::Widget::void_box';

  /// Set widget box style.
  set box(Boxtype type) => _boxSet(type.index);

  void _image(int width, int height, int depth, Uint8List data)
      native 'fldart::Widget::void_image';

  /// Change widget background image.
  set image(Image image) => _image(image.width, image.height, 4,
      new Uint8List.fromList(image.data.buffer.asUint8List()));

  /// Get callback flags.
  int get when native 'fldart::Widget::int_when';

  /// Set callback flags.
  set when(int mode) native 'fldart::Widget::void_when';
}
