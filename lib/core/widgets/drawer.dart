import 'package:flutter/material.dart';

class FloatingDrawer extends StatefulWidget {
  final VoidCallback onClose;

  const FloatingDrawer({super.key,required this.onClose});

  @override
  State<FloatingDrawer> createState() => _FloatingDrawerState();
}

class _FloatingDrawerState extends State<FloatingDrawer> {
  bool isEditing = false; // To toggle between text and textfield
  final TextEditingController _controller = TextEditingController();
  bool isHovered = false; // To detect hover effect
  bool isSelected = false; // To track if the drawer is selected

  @override
  void initState() {
    super.initState();
    _controller.text = 'Cooketh Flow'; // Initial text
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background overlay to close the drawer when tapped
        GestureDetector(
          onTap: widget.onClose,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        // Floating drawer
        Positioned(
          top: 20, // Adjust position as needed
          left: 20, // Adjust position as needed
          child: Material(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.black, // Blue outline if selected
                  width: 2.0, // Border width
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        isEditing = !isEditing; // Toggle editing state
                      });
                    },
                    onTap: () {
                      setState(() {
                        isSelected = !isSelected; // Toggle selected state
                      });
                    },
                    child: MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          isHovered = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          isHovered = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: isEditing
                              ? TextField(
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(), // Adding outline to text field
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'Frederik',
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  onSubmitted: (_) {
                                    setState(() {
                                      isEditing = false; // Exit edit mode on submit
                                    });
                                  },
                                )
                              : AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: isHovered
                                        ? Border(bottom: BorderSide(color: Colors.blue, width: 2))
                                        : Border.all(color: Colors.transparent),
                                  ),
                                  child: Text(
                                    _controller.text,
                                    style: TextStyle(
                                      fontFamily: 'Frederik',
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Option 1'),
                    onTap: widget.onClose,
                  ),
                  ListTile(
                    title: Text('Option 2'),
                    onTap: widget.onClose,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
