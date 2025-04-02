import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'category_screen.dart';



class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Globe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF6C63FF),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6C63FF),
          secondary: Color(0xFF00D3B8),
          background: Color(0xFF121212),
        ),
        fontFamily: 'Montserrat',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
          displayMedium: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
          bodyLarge: TextStyle(
            fontSize: 16.0,
            color: Colors.white70,
            height: 1.5,
          ),
        ),
      ),
      home: const OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.6, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.easeOutExpo;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 1000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          // Animated Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1A1A2E),
                  const Color(0xFF121212),
                ],
              ),
            ),
          ),

          // Background Particles
          Positioned.fill(
            child: CustomPaint(
              painter: ParticlesPainter(),
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                // Hero Section with Globe Animation
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Center(
                        child: SizedBox(
                          height: 240,
                          width: 240,
                          child: GlobeAnimation(),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Title and Description
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        children: [
                          Text(
                            'News Globe',
                            style: Theme.of(context).textTheme.displayLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Stay informed with breaking news and trending stories from around the world',
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Get Started Button
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                    child: GradientButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CategoryScreen()),
                        );
                      },
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),

          // FAB for Quick Preview
          Positioned(
            right: 24,
            top: 48,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: FloatingActionButton(
                heroTag: 'previewFab',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Trending news preview'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: const Icon(Icons.trending_up),
                elevation: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GlobeAnimation extends StatefulWidget {
  const GlobeAnimation({Key? key}) : super(key: key);

  @override
  _GlobeAnimationState createState() => _GlobeAnimationState();
}

class _GlobeAnimationState extends State<GlobeAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: GlobePainter(_controller.value),
          child: Container(),
        );
      },
    );
  }
}

class GlobePainter extends CustomPainter {
  final double animationValue;

  GlobePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2.2;

    // Draw the globe base
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF6C63FF).withOpacity(0.7),
          const Color(0xFF3F3D9E).withOpacity(0.5),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, paint);

    // Draw the globe grid
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw latitude lines
    for (int i = 0; i < 8; i++) {
      final latRadius = radius * (i + 1) / 8;
      canvas.drawCircle(center, latRadius, linePaint);
    }

    // Draw longitude lines with rotation
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(animationValue * 2 * math.pi);

    for (int i = 0; i < 12; i++) {
      final angle = i * math.pi / 6;
      final x1 = radius * math.cos(angle);
      final y1 = radius * math.sin(angle);
      final x2 = -radius * math.cos(angle);
      final y2 = -radius * math.sin(angle);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), linePaint);
    }

    // Draw news points (locations)
    final spotPaint = Paint()
      ..color = const Color(0xFF00D3B8)
      ..style = PaintingStyle.fill;

    // Random news spots
    final random = math.Random(42);
    for (int i = 0; i < 10; i++) {
      final angle = random.nextDouble() * 2 * math.pi;
      final distance = random.nextDouble() * 0.8 + 0.2; // Between 0.2 and 1.0
      final x = radius * distance * math.cos(angle + animationValue * 2 * math.pi);
      final y = radius * distance * math.sin(angle + animationValue * 2 * math.pi);

      canvas.drawCircle(Offset(x, y), 3.0, spotPaint);

      // Draw pulsating effect
      if (i % 3 == 0) {
        final pulseFactor = (math.sin(animationValue * 2 * math.pi + i) + 1) / 2;
        final pulsePaint = Paint()
          ..color = const Color(0xFF00D3B8).withOpacity(0.3 * (1 - pulseFactor))
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(x, y), 8.0 * pulseFactor + 4, pulsePaint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant GlobePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class ParticlesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);

    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.5 + 0.5;

      final opacity = random.nextDouble() * 0.2 + 0.1;
      final paint = Paint()
        ..color = Colors.white.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GradientButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const GradientButton({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  _GradientButtonState createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [
                const Color(0xFF6C63FF),
                const Color(0xFF00D3B8),
              ],
            ),
            boxShadow: _isPressed
                ? []
                : [
              BoxShadow(
                color: const Color(0xFF6C63FF).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

// Simple Home Page to navigate to
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('News Globe'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Welcome to News Globe!'),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'homeFab',
        onPressed: () {},
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}