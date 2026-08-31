import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'account_store.dart';
import 'common_widgets.dart';

class LoginView extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onGoToSignUp;
  final void Function(String email) onSignInSuccess;

  const LoginView({
    super.key,
    required this.onBack,
    required this.onGoToSignUp,
    required this.onSignInSuccess,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late final TapGestureRecognizer _signUpRecognizer;

  @override
  void initState() {
    super.initState();

    _signUpRecognizer = TapGestureRecognizer()..onTap = widget.onGoToSignUp;

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    );

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          ),
        );
    _entranceController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _shakeController.dispose();
    _entranceController.dispose();
    _signUpRecognizer.dispose();
    super.dispose();
  }

  void _playShake() => _shakeController.forward(from: 0);

  void _handleLogoDoubleTap() {
    _playShake();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pizzeria Logo Double-Tapped! 🍕'),
        duration: Duration(seconds: 1),
        backgroundColor: orange,
      ),
    );
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reset Password'),
        content: const Text(
          'A password reset link will be sent to your registered email '
          'address. Please check your inbox after confirming.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: orange,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password reset link sent! Check your email.'),
                  backgroundColor: orange,
                ),
              );
            },
            child: const Text('Send Link'),
          ),
        ],
      ),
    );
  }

  // ---- Validation logic ----
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  void _handleSignIn() {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (!AccountStore.authenticate(email, password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    widget.onSignInSuccess(email);
  }

  void _handleSocialSignIn(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logged-in via $provider successfully!'),
        backgroundColor: orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final spacing = height < 800 ? 14.0 : 18.0;
    final topSpacing = height < 800 ? 18.0 : 22.0;

    return Scaffold(
      backgroundColor: const Color(0xFF241A18),
      body: Stack(
        children: [
          Container(
            height: 130,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF211817), Color(0xFF2D211E)],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 2),

                  Center(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onDoubleTap: _handleLogoDoubleTap,
                      child: AnimatedBuilder(
                        animation: _shakeAnimation,
                        builder: (context, child) {
                          final progress = _shakeAnimation.value;
                          final wiggle =
                              8 *
                              (1 - progress) *
                              (progress == 0
                                  ? 0
                                  : (progress * 6).floor() % 2 == 0
                                  ? 1
                                  : -1);
                          return Transform.translate(
                            offset: Offset(
                              _shakeController.isAnimating
                                  ? wiggle.toDouble()
                                  : 0,
                              0,
                            ),
                            child: child,
                          );
                        },
                        child: SizedBox(
                          width: 110,
                          height: 96,
                          child: Center(
                            child: Image.asset(
                              'assets/images/PIZZERIA_LOGO.png',
                              width: 62,
                              height: 62,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.local_pizza,
                                    color: orange,
                                    size: 55,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    constraints: BoxConstraints(minHeight: height - 98),
                    padding: EdgeInsets.fromLTRB(
                      21,
                      25,
                      21,
                      height < 800 ? 22 : 30,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: widget.onBack,
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: orange,
                                      size: 27,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                      minWidth: 30,
                                      minHeight: 30,
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  const Text(
                                    'Welcome Back!',
                                    style: TextStyle(
                                      color: orange,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: topSpacing),

                              accountField(
                                label: 'Email',
                                hint: 'Enter email',
                                icon: Icons.mail_outline,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: _validateEmail,
                              ),

                              SizedBox(height: spacing),

                              accountField(
                                label: 'Password',
                                hint: 'Enter password',
                                icon: Icons.lock_outline,
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                validator: _validatePassword,
                                suffix: IconButton(
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.grey,
                                    size: 21,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onLongPress: _showForgotPasswordDialog,
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Long-press for password reset options',
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Forgot password?',
                                    style: TextStyle(
                                      color: orange,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              hoverButton(
                                height: 53,
                                borderRadius: 16,
                                onTap: _handleSignIn,
                                child: const Text(
                                  'Sign in',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 31),

                              Row(
                                children: [
                                  const Expanded(
                                    child: Divider(color: Color(0xFFD0D0D0)),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      'Sign in with',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                    child: Divider(color: Color(0xFFD0D0D0)),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 18),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  socialButton(
                                    name: 'Facebook',
                                    onTap: () =>
                                        _handleSocialSignIn('Facebook'),
                                    child: const Icon(
                                      Icons.facebook,
                                      color: Color(0xFF1877F2),
                                      size: 26,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  socialButton(
                                    name: 'Google',
                                    onTap: () => _handleSocialSignIn('Google'),
                                    child: Image.asset(
                                      'assets/images/google_logo.png',
                                      width: 26,
                                      height: 26,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Text(
                                                'G',
                                                style: TextStyle(
                                                  color: orange,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 17),

                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: "Don't have an account? ",
                                      ),
                                      TextSpan(
                                        text: 'Sign up',
                                        style: const TextStyle(
                                          color: orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        recognizer: _signUpRecognizer,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
