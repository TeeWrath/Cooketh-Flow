import 'package:cookethflow/core/utils/utils.dart';
import 'package:flutter/material.dart';

class NodeProvider extends StateHandler {
  bool _isHovered = false;
  bool _isSelected = false; // Track if the node is selected
  double _width = 100;
  double _height = 50;
  TextEditingController textController = TextEditingController();

  // Constructor with an optional initial state
  NodeProvider([super.initialState]) {
    textController.addListener(_updateSize);
  }

  // Getters
  bool get isHovered => _isHovered;
  bool get isSelected => _isSelected;
  double get width => _width;
  double get height => _height;

  // Setters
  void setHover(bool val) {
    _isHovered = val;
    notifyListeners();
  }

  void changeSelected() {
    _isSelected = !_isSelected;
    notifyListeners();
  }

  void setWidth(double w) {
    _width = w;
    notifyListeners();
  }

  void setHeight(double h) {
    _height = h;
    notifyListeners();
  }

  @override
  void dispose() {
    textController.removeListener(_updateSize);
    textController.dispose();
    super.dispose();
  }

  void _updateSize() {
    final text = textController.text.isEmpty ? " " : textController.text;

    final textSpan = TextSpan(
      text: text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      maxLines: null, // Allow multiple lines
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: 250); // Max width limit
    setWidth(textPainter.width.clamp(100, 250).toDouble()); // Dynamic width
    setHeight((textPainter.height + 20).clamp(50, double.infinity));
  }
  
  List<Widget> buildSelectionBoxes() {
    return [
      _selectionBox(Offset(-_width / 2 - 10,
          -_height / 2 - 10)), // Top-left corner
      _selectionBox(Offset(_width / 2 + 10,
          -_height / 2 - 10)), // Top-right corner
      _selectionBox(Offset(-_width / 2 - 10,
          _height / 2 + 10)), // Bottom-left corner
      _selectionBox(Offset(_width / 2 + 10,
          _height / 2 + 10)), // Bottom-right corner
    ];
  }

  Widget _selectionBox(Offset offset) {
    return Positioned(
      left: (_width / 2) + offset.dx + 53,
      top: (_height / 2) + offset.dy + 53,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  List<Widget> buildConnectionPoints() {
    return [
      _connectionPoint(Offset(0, -_height / 2 - 30)), // Top
      _connectionPoint(Offset(0, _height / 2 + 30)), // Bottom
      _connectionPoint(Offset(-_width / 2 - 30, 0)), // Left
      _connectionPoint(Offset(_width / 2 + 30, 0)), // Right
    ];
  }

  Widget _connectionPoint(Offset offset) {
    return Positioned(
      left: (_width / 2) + offset.dx + 53,
      top: (_height / 2) + offset.dy + 53,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 145, 145, 145),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
