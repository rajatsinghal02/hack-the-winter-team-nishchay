import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../widgets/vertical_swipe_button.dart';
// In lib/screens/onboarding_screen.dart
import 'login_screen.dart'; // Import this

// --- 1. RAINDROP MODEL CLASS ---
class Raindrop {
  double x;
  double y;
  double speed;
  double size;
  double opacity;

  Raindrop({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
  });
}

// --- 2. MAIN SCREEN WIDGET ---
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final math.Random _random = math.Random();
  final List<Raindrop> _raindrops = [];
  bool _isInitialized =
      false; // New flag to ensure we init once with correct size

  final int _numberOfDrops = 15; // Increased slightly for better coverage

  @override
  void initState() {
    super.initState();
    // Setup Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Generate drops using the ACTUAL screen dimensions
  void _initializeRaindrops(double width, double height) {
    _raindrops.clear();
    for (int i = 0; i < _numberOfDrops; i++) {
      _raindrops.add(
        Raindrop(
          x:
              _random.nextDouble() *
              width, // Valid width guarantees full screen spread
          // Random Y from -100 (top) to height (bottom) so rain is everywhere immediately
          y: _random.nextDouble() * height,
          speed:
              1.5 +
              _random.nextDouble() * 2.0, // Slightly faster for visibility
          size: 20.0 + _random.nextDouble() * 15.0,
          opacity: 0.3 + _random.nextDouble() * 0.4,
        ),
      );
    }
  }

  // Update physics
  void _updateRainPositions(double height, double width) {
    for (var drop in _raindrops) {
      drop.y += drop.speed;

      // Reset when it hits the bottom
      if (drop.y > height) {
        drop.y = -50; // Reset to just above the screen
        drop.x = _random.nextDouble() * width; // New random X
        drop.speed = 1.5 + _random.nextDouble() * 2.0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // FIX: Initialize drops here where we are 100% sure 'size' is valid
    if (!_isInitialized && size.width > 0) {
      _initializeRaindrops(size.width, size.height);
      _isInitialized = true;
    }

    final double logoTopPosition = size.height * 0.1;
    final double logoHeight = size.height * 0.3;

    return Scaffold(
      backgroundColor: const Color(0xFF050916),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // LAYER 1: RAIN ANIMATION
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // Pass current size to update logic
                _updateRainPositions(size.height, size.width);

                return Stack(
                  children: _raindrops.map((drop) {
                    return Positioned(
                      left: drop.x,
                      top: drop.y,
                      child: Icon(
                        Icons.water_drop,
                        size: drop.size,
                        color: const Color(
                          0xFFD2F63F,
                        ).withValues(alpha: drop.opacity),
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            // LAYER 2: DRONE LOGO
            Positioned(
              top: logoTopPosition,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  height: logoHeight,
                  child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                ),
              ),
            ),

            // LAYER 3: TEXT CONTENT
            Positioned(
              bottom: size.height * 0.1,
              left: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "STRETCH\nYOUR MIND\nAND",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "DEEP DIVE",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 1.5
                        ..color = Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // LAYER 4: SWIPE BUTTON
            Positioned(
              bottom: size.height * 0.1,
              right: 30,
              child: VerticalSwipeButton(
                onSwipeComplete: () {
                  _controller.stop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
