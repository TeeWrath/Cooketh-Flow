import 'package:flutter/material.dart';

class DraggableNode extends StatefulWidget {
  final Function(Offset) onDrag;
  final Function(int) onConnect;
  final int nodeIndex;

  const DraggableNode({
    super.key,
    required this.onDrag,
    required this.onConnect,
    required this.nodeIndex,
  });

  @override
  _DraggableNodeState createState() => _DraggableNodeState();
}

class _DraggableNodeState extends State<DraggableNode> {
  bool isHovered = false;
  TextEditingController textController = TextEditingController();
  double width = 100;
  double height = 50;

  @override
  void initState() {
    super.initState();
    textController.addListener(_updateSize);
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

    setState(() {
      width = textPainter.width.clamp(100, 250).toDouble();  // Dynamic width
      height = (textPainter.height + 20).clamp(50, double.infinity);  // Dynamic height
    });
  }


  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onPanUpdate: (details) {
          widget.onDrag(Offset(
            details.globalPosition.dx - (width / 2),
            details.globalPosition.dy - (height / 2),
          ));
        },
        onDoubleTap: () {
          widget.onConnect(widget.nodeIndex + 1);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: width,
              height: height,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: TextField(
                controller: textController,
                maxLines: null, // Allows text to wrap
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (isHovered) ..._buildConnectionPoints(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildConnectionPoints() {
    return [
      _connectionPoint(Offset(0, -height / 2)),  // Top
      _connectionPoint(Offset(0, height / 2)),   // Bottom
      _connectionPoint(Offset(-width / 2, 0)),  // Left
      _connectionPoint(Offset(width / 2, 0)),   // Right
    ];
  }

  Widget _connectionPoint(Offset offset) {
    return Positioned(
      left: (width / 2) + offset.dx - 5,
      top: (height / 2) + offset.dy - 5,
      child: Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
