import 'package:flutter/material.dart';

class VerticalSwipeButton extends StatefulWidget {
  final VoidCallback onSwipeComplete;
  const VerticalSwipeButton({required this.onSwipeComplete, super.key});

  @override
  State<VerticalSwipeButton> createState() => _VerticalSwipeButtonState();
}

class _VerticalSwipeButtonState extends State<VerticalSwipeButton>
    with SingleTickerProviderStateMixin {
  double _dragValue = 0.0;
  final double _maxDragDistance = 130.0; // Height of track minus button height
  late AnimationController _controller;
  late Animation<double> _arrowAnimation;

  // Colors from the design
  final Color _limeGreen = const Color(0xFFD2F63F);
  final Color _darkBg = const Color(0xFF1A1F2E);

  @override
  void initState() {
    super.initState();
    // Bouncing arrow animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    
    _arrowAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      // Move button up (negative dy) or down, clamped to track size
      _dragValue = (_dragValue - details.delta.dy).clamp(0.0, _maxDragDistance);
    });
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    // If dragged more than 70% up, complete the action
    if (_dragValue > _maxDragDistance * 0.7) {
      setState(() {
        _dragValue = _maxDragDistance; // Snap to top
      });
      Future.delayed(const Duration(milliseconds: 200), widget.onSwipeComplete);
    } else {
      // Snap back to bottom
      setState(() {
        _dragValue = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Animated Arrows
        AnimatedBuilder(
          animation: _arrowAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, -_arrowAnimation.value),
              child: Column(
                children: const [
                  Icon(Icons.keyboard_arrow_up, color: Colors.white54, size: 20),
                  Icon(Icons.keyboard_arrow_up, color: Colors.white54, size: 20),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        
        // Swipe Track
        GestureDetector(
          onVerticalDragUpdate: _handleVerticalDragUpdate,
          onVerticalDragEnd: _handleVerticalDragEnd,
          child: Container(
            height: 190,
            width: 65,
            decoration: BoxDecoration(
              color: _limeGreen,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // "Start" Text
                Positioned(
                  bottom: 75,
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      "Start",
                      style: TextStyle(
                        color: _darkBg,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                // Draggable Button
                Positioned(
                  bottom: _dragValue + 5,
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_upward,
                      color: _darkBg,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}