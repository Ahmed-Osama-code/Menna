import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vigil/widgets/gps_page.dart';
import 'package:vigil/widgets/owner_page.dart';
import 'package:vigil/widgets/pairing_page.dart';
import 'package:vigil/widgets/patient_page.dart';

class MainScreen extends StatefulWidget {
  // Added an optional initialIndex parameter. PatientPage is at index 0.
  final int initialIndex;

  const MainScreen({
    super.key,
    this.initialIndex = 2, // Default remains 2 (PairingPage) if not specified
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  // Changed from hardcoded '2' to a 'late' variable assigned in initState
  late int _currentScreen;
  late AnimationController _popupController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isInitialized = false;

  final List<Widget> screens = [
    const PatientPage(),
    const OwnerPage(),
    const PairingPage(),
    const GpsPage(),
  ];

  final List<String> _pageLabels = ['patient', 'owner', 'pairing', 'GPS'];

  final List<String> _svgIcons = [
    'assets/images/patient.svg',
    'assets/images/owner.svg',
    'assets/images/pairing.svg',
    'assets/images/gps.svg',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the screen using the passed parameter
    _currentScreen = widget.initialIndex;
    _setupAnimations();
    _isInitialized = true;
  }

  void _setupAnimations() {
    _popupController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _popupController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _popupController, curve: Curves.easeIn));

    _popupController.forward();
  }

  @override
  void dispose() {
    _popupController.dispose();
    super.dispose();
  }

  void _onNavItemTapped(int index) {
    if (_currentScreen != index) {
      setState(() {
        _currentScreen = index;
      });

      _popupController.reset();
      _popupController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: IndexedStack(index: _currentScreen, children: screens),
              ),
              _buildNavigationBarWithPopup(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBarWithPopup() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CustomPaint(
          painter: NavBarPainter(selectedIndex: _currentScreen),
          child: Container(
            height: 70,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF64CDC6), Color(0xFF136A88)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) => _buildNavItem(index)),
              ),
            ),
          ),
        ),
        Positioned(
          left: _getPopupLeftPosition(),
          top: -20,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF64CDC6),
                      Color(0xFF136A88),
                    ],
                  ),
                ),
                child: Center(
                  child: SizedBox(
                    width: 26,
                    height: 26,
                    child: SvgPicture.asset(
                      _svgIcons[_currentScreen],
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _getPopupLeftPosition() {
    final screenWidth = MediaQuery.of(context).size.width;
    const horizontalPadding = 16.0;
    final availableWidth = screenWidth - (horizontalPadding * 2);
    final itemWidth = availableWidth / 4;
    final itemCenter = horizontalPadding + (itemWidth * (_currentScreen + 0.5));
    const popupWidth = 50.0;
    return itemCenter - (popupWidth / 2);
  }

  Widget _buildNavItem(int index) {
    final isSelected = _currentScreen == index;
    return GestureDetector(
      onTap: () => _onNavItemTapped(index),
      child: AnimatedOpacity(
        opacity: isSelected ? 0.2 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 30,
              child: SvgPicture.asset(
                _svgIcons[index],
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _pageLabels[index],
              style: TextStyle(
                color: Colors.white.withOpacity(isSelected ? 0 : 0),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavBarPainter extends CustomPainter {
  final int selectedIndex;
  NavBarPainter({required this.selectedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.transparent
      ..blendMode = BlendMode.dstOut;

    const horizontalPadding = 16.0;
    final availableWidth = size.width - (horizontalPadding * 2);
    final itemWidth = availableWidth / 4;
    final cutoutX = horizontalPadding + (itemWidth * (selectedIndex + 0.5));
    const cutoutRadius = 28.0;

    canvas.drawCircle(Offset(cutoutX, 0), cutoutRadius, paint);
  }

  @override
  bool shouldRepaint(NavBarPainter oldDelegate) =>
      oldDelegate.selectedIndex != selectedIndex;
}