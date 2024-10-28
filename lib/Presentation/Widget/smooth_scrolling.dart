import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomScrollViewWithSmoothScrolling extends StatelessWidget {
  final Widget child;

  const CustomScrollViewWithSmoothScrolling({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        dragStartBehavior:
            DragStartBehavior.down, // Allow smooth scrolling on drag start
        physics: const ClampingScrollPhysics(), // Prevent overscrolling
        child: child,
      ),
    );
  }
}
