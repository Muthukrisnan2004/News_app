import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'category_news_screen.dart';
import 'dart:ui';
import 'DashboardPage.dart';
import 'ReportPage.dart';
import 'Profile.dart'; // Added import for ProfilePage

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'technology',
      'icon': Icons.computer,
      'gradient': [Color(0xFF6A11CB), Color(0xFF2575FC)],
    },
    {
      'name': 'sports',
      'icon': Icons.sports_basketball,
      'gradient': [Color(0xFFFF416C), Color(0xFFFF4B2B)],
    },
    {
      'name': 'business',
      'icon': Icons.business,
      'gradient': [Color(0xFF007ADF), Color(0xFF00ECBC)],
    },
    {
      'name': 'health',
      'icon': Icons.health_and_safety,
      'gradient': [Color(0xFF56CCF2), Color(0xFF2F80ED)],
    },
    {
      'name': 'entertainment',
      'icon': Icons.movie,
      'gradient': [Color(0xFFB721FF), Color(0xFF21D4FD)],
    },
    {
      'name': 'science',
      'icon': Icons.science,
      'gradient': [Color(0xFF11998E), Color(0xFF38EF7D)],
    },
    {
      'name': 'general',
      'icon': Icons.public,
      'gradient': [Color(0xFFFFB347), Color(0xFFFFCC33)],
    },
  ];

  late AnimationController _controller;
  late List<Animation<double>> _animations;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    // Cannot have CategoryScreen() here as it causes a recursive initialization
    // Fixed by using a placeholder initially
    Placeholder(),
    DashboardContent(),
    ReportsContent(),
    ProfileContent(),
    SettingsContent(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _animations = List.generate(
      categories.length,
          (index) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            (index / categories.length) * 0.7,
            ((index + 1) / categories.length) * 0.7 + 0.3,
            curve: Curves.easeOutBack,
          ),
        ),
      ),
    );

    _controller.forward();

    // Update pages after initialization to avoid recursive issues
    _pages[0] = this.widget;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation based on index
    if (index == 1) { // Dashboard
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => DashboardPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 0.5);
            var end = Offset.zero;
            var curve = Curves.easeOutExpo;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        ),
      );
    } else if (index == 2) { // Reports
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => ReportsPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 0.5);
            var end = Offset.zero;
            var curve = Curves.easeOutExpo;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        ),
      );
    } else if (index == 3) { // Profile - Added this condition
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 0.5);
            var end = Offset.zero;
            var curve = Curves.easeOutExpo;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text(
          'Discover News',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: SafeArea(
          bottom: false, // Keep this as false to avoid double padding
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Select a category',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    // Fix: Using a GridView.builder inside a Column might cause overflow
                    // Adding physics to handle overflow
                    physics: AlwaysScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    padding: EdgeInsets.only(bottom: 90), // Increased bottom padding
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _animations[index],
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _animations[index].value,
                            child: Opacity(
                              opacity: _animations[index].value,
                              child: _buildCategoryCard(context, index),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show personalized category selection dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color(0xFF16213E),
                title: Text(
                  'Personalize Your Feed',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                content: Text(
                  'Coming soon: Create your own custom news categories!',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text(
                      'OK',
                      style: GoogleFonts.poppins(
                        color: Colors.blue[300],
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF2575FC),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // FIX: Modified the bottom navigation bar to properly handle overflow
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Color(0xFF16213E),
        elevation: 10,
        child: Container(
          // Set a fixed height for the BottomAppBar content
          height: 60,
          child: Row(
            // Removed the mainAxisAlignment property to prevent overflow
            children: <Widget>[
              Expanded(child: _buildNavItem(0, Icons.home_outlined, 'Home')),
              Expanded(child: _buildNavItem(1, Icons.dashboard_outlined, 'Dashboard')),
              // Fixed width SizedBox to accommodate the FAB
              SizedBox(width: 60),
              Expanded(child: _buildNavItem(2, Icons.document_scanner_outlined, 'Reports')),
              Expanded(child: _buildNavItem(3, Icons.person_outline, 'Profile')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected
                ? Color(0xFF2575FC)
                : Colors.white54,
            size: 24,
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: isSelected
                  ? Color(0xFF2575FC)
                  : Colors.white54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, int index) {
    final category = categories[index];

    return Hero(
      tag: 'category-${category['name']}',
      child: Material(
        color: Colors.transparent,
        child: StatefulBuilder(
          builder: (context, setState) {
            return GestureDetector(
              onTap: () {
                // Haptic feedback
                HapticFeedback.mediumImpact();

                // Navigate to category news screen
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => CategoryNewsScreen(
                      category: category['name'],
                    ),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      var begin = Offset(0.0, 0.5);
                      var end = Offset.zero;
                      var curve = Curves.easeOutExpo;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      return SlideTransition(
                        position: animation.drive(tween),
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                  ),
                );
              },
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 1.0, end: 1.0),
                duration: Duration(milliseconds: 300),
                builder: (context, double scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: category['gradient'],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: category['gradient'][0].withOpacity(0.5),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: -15,
                              bottom: -15,
                              child: Icon(
                                category['icon'],
                                size: 80,
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    category['icon'],
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  Spacer(),
                                  Text(
                                    category['name'].toUpperCase(),
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Placeholder content widgets for each page
class DashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A2E),
      body: Center(
        child: Text(
          'Dashboard',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
    );
  }
}

class ReportsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A2E),
      body: Center(
        child: Text(
          'Reports',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
    );
  }
}

class ProfileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A2E),
      body: Center(
        child: Text(
          'Profile',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
    );
  }
}

class SettingsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A2E),
      body: Center(
        child: Text(
          'Settings',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
    );
  }
}

// Existing GlassmorphicContainer remains the same
class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final List<Color> gradientColors;

  const GlassmorphicContainer({
    Key? key,
    required this.child,
    this.borderRadius = 20,
    required this.gradientColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.5),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}