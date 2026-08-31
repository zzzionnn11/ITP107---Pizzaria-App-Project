import 'package:flutter/material.dart';

const snackBarColor = Color(0xFFFF6B4A);

/// The original "WelcomeScreen". Instead of pushing new routes, it calls
/// back up to the single root screen, which swaps which view is shown.
class WelcomeView extends StatefulWidget {
  final VoidCallback onSignIn;
  final VoidCallback onCreateAccount;

  const WelcomeView({
    super.key,
    required this.onSignIn,
    required this.onCreateAccount,
  });

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isSpinning = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSpinning() {
    if (_controller.isAnimating) {
      _controller.stop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pizza spinning paused!'),
          backgroundColor: snackBarColor,
        ),
      );
    } else {
      _controller.repeat();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pizza spinning resumed!'),
          backgroundColor: snackBarColor,
        ),
      );
    }

    setState(() {
      _isSpinning = _controller.isAnimating;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF221A1A),
              Color(0xFF4A342B),
              Color(0xFFC8BBB4),
              Color(0xFFF2F6F8),
            ],
            stops: [0.0, 0.35, 0.75, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -45,
              left: -50,
              child: Image.asset(
                'assets/images/Pepperoni_Pizza.png',
                width: isSmallScreen ? 130 : 150,
              ),
            ),
            Positioned(
              top: 15,
              right: -60,
              child: Image.asset(
                'assets/images/Veggie_Pizza.png',
                width: isSmallScreen ? 155 : 180,
              ),
            ),
            Positioned(
              top: 310,
              left: -60,
              child: Image.asset(
                'assets/images/Hawaiian_Pizza.png',
                width: isSmallScreen ? 110 : 130,
              ),
            ),
            Positioned(
              top: 115,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onLongPress: _toggleSpinning,
                  child: RotationTransition(
                    turns: _controller,
                    child: AnimatedOpacity(
                      opacity: _isSpinning ? 1.0 : 0.6,
                      duration: const Duration(milliseconds: 200),
                      child: Image.asset(
                        'assets/images/Big_pizza.png',
                        width: isSmallScreen ? 200 : 230,
                        height: isSmallScreen ? 200 : 230,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onDoubleTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Pizzeria Logo Double-Tapped! 🍕',
                              ),
                              backgroundColor: snackBarColor,
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/images/PIZZERIA_LOGO.png',
                          width: 65,
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 10),
                      const Text(
                        'Crave some',
                        strutStyle: StrutStyle(
                          fontSize: 53,
                          height: 1.0,
                          forceStrutHeight: true,
                        ),
                        style: TextStyle(
                          fontSize: 53,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.3,
                          height: 1.0,
                        ),
                      ),

                      const Text(
                        'Pizzeria!',
                        strutStyle: StrutStyle(
                          fontSize: 53,
                          height: 1.0,
                          forceStrutHeight: true,
                        ),
                        style: TextStyle(
                          fontSize: 53,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFFF6B4A),
                          height: 1.0,
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.only(top: 7),
                        child: Text(
                          'Select an option below to continue',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6E6E6E),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Sign in -> swap the root's view state, no Navigator.
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: widget.onSignIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B4A),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: const Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Create account -> swap the root's view state.
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: widget.onCreateAccount,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side: const BorderSide(
                              color: Color(0xFFFF6B4A),
                              width: 1.8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: const Text(
                            'Create an account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFF6B4A),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
