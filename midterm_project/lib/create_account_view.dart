import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'account_store.dart';
import 'common_widgets.dart';

class CreateAccountView extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onGoToSignIn;
  final void Function(String firstName, String email) onAccountCreated;

  const CreateAccountView({
    super.key,
    required this.onBack,
    required this.onGoToSignIn,
    required this.onAccountCreated,
  });

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView>
    with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();

  final email = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final birthdate = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  DateTime? selectedBirthdate;
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool agreed = false;

  late AnimationController shakeController;
  late Animation<double> shakeAnimation;

  late final TapGestureRecognizer termsRecognizer;
  late final TapGestureRecognizer signInRecognizer;

  @override
  void initState() {
    super.initState();
    shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    shakeAnimation = CurvedAnimation(
      parent: shakeController,
      curve: Curves.elasticIn,
    );

    termsRecognizer = TapGestureRecognizer()..onTap = showTerms;
    signInRecognizer = TapGestureRecognizer()..onTap = widget.onGoToSignIn;
  }

  @override
  void dispose() {
    email.dispose();
    firstName.dispose();
    lastName.dispose();
    birthdate.dispose();
    password.dispose();
    confirmPassword.dispose();
    shakeController.dispose();
    termsRecognizer.dispose();
    signInRecognizer.dispose();
    super.dispose();
  }

  void playShake() => shakeController.forward(from: 0);

  void logoDoubleTapped() {
    playShake();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pizzeria Logo Double-Tapped! 🍕'),
        duration: Duration(seconds: 1),
        backgroundColor: orange,
      ),
    );
  }

  void socialTapped(String name) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logged-in via $name successfully!'),
        duration: const Duration(seconds: 1),
        backgroundColor: orange,
      ),
    );
  }

  Future<void> pickBirthdate() async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate:
          selectedBirthdate ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(colorScheme: const ColorScheme.light(primary: orange)),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        selectedBirthdate = date;
        birthdate.text =
            '${date.month.toString().padLeft(2, '0')}/'
            '${date.day.toString().padLeft(2, '0')}/'
            '${date.year}';
      });
    }
  }

  String? requiredField(String? value, String name) {
    if (value == null || value.trim().isEmpty) {
      return '$name is required';
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  String? confirmValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password.text) return 'Passwords do not match';
    return null;
  }

  void submit() {
    final formValid = formKey.currentState?.validate() ?? false;
    if (!formValid) return;

    if (!agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms & Conditions to continue.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final emailText = email.text.trim();

    if (AccountStore.emailExists(emailText)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An account with this email already exists.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    AccountStore.register(emailText, password.text);

    widget.onAccountCreated(firstName.text.trim(), emailText);
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
                colors: [
                  Color(0xFF211817),
                  Color(0xFF2D211E),
                  Color(0xFFF4EDE8),
                ],
                stops: [0.0, 0.55, 1.0],
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
                      onDoubleTap: logoDoubleTapped,
                      child: AnimatedBuilder(
                        animation: shakeAnimation,
                        builder: (context, child) {
                          final progress = shakeAnimation.value;
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
                              shakeController.isAnimating
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
                    child: Form(
                      key: formKey,
                      child: Column(
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
                                'Create Account',
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
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            validator: emailValidator,
                          ),

                          SizedBox(height: spacing),

                          accountField(
                            label: 'First name',
                            hint: 'Enter first name',
                            icon: Icons.person_outline,
                            controller: firstName,
                            validator: (v) => requiredField(v, 'First name'),
                          ),

                          SizedBox(height: spacing),

                          accountField(
                            label: 'Last name',
                            hint: 'Enter last name',
                            icon: Icons.person_outline,
                            controller: lastName,
                            validator: (v) => requiredField(v, 'Last name'),
                          ),

                          SizedBox(height: spacing),

                          accountField(
                            label: 'Birthdate',
                            hint: 'Select birthdate',
                            icon: Icons.calendar_today_outlined,
                            controller: birthdate,
                            readOnly: true,
                            onTap: pickBirthdate,
                            validator: (_) => selectedBirthdate == null
                                ? 'Birthdate is required'
                                : null,
                          ),

                          SizedBox(height: spacing),

                          accountField(
                            label: 'Password',
                            hint: 'Enter password',
                            icon: Icons.lock_outline,
                            controller: password,
                            obscureText: hidePassword,
                            validator: passwordValidator,
                            suffix: IconButton(
                              onPressed: () =>
                                  setState(() => hidePassword = !hidePassword),
                              icon: Icon(
                                hidePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey,
                                size: 21,
                              ),
                            ),
                          ),

                          SizedBox(height: spacing),

                          accountField(
                            label: 'Confirm Password',
                            hint: 'Confirm password',
                            icon: Icons.lock_outline,
                            controller: confirmPassword,
                            obscureText: hideConfirmPassword,
                            validator: confirmValidator,
                            suffix: IconButton(
                              onPressed: () => setState(
                                () =>
                                    hideConfirmPassword = !hideConfirmPassword,
                              ),
                              icon: Icon(
                                hideConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey,
                                size: 21,
                              ),
                            ),
                          ),

                          const SizedBox(height: 13),

                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: agreed,
                                  activeColor: orange,
                                  onChanged: (value) =>
                                      setState(() => agreed = value ?? false),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13,
                                    ),
                                    children: [
                                      const TextSpan(text: 'Agree with '),
                                      TextSpan(
                                        text: 'Terms & Conditions',
                                        style: const TextStyle(
                                          color: orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        recognizer: termsRecognizer,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          hoverButton(
                            height: 53,
                            borderRadius: 16,
                            onTap: submit,
                            child: const Text(
                              'Sign up',
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
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  'Sign up with',
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
                                onTap: () => socialTapped('Facebook'),
                                child: const Icon(
                                  Icons.facebook,
                                  color: Color(0xFF1877F2),
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 10),
                              socialButton(
                                name: 'Google',
                                onTap: () => socialTapped('Google'),
                                child: Image.asset(
                                  'assets/images/google_logo.png',
                                  width: 26,
                                  height: 26,
                                  errorBuilder: (context, error, stackTrace) =>
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

                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'Already have an account? ',
                                ),
                                TextSpan(
                                  text: 'Sign in',
                                  style: const TextStyle(
                                    color: orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: signInRecognizer,
                                ),
                              ],
                            ),
                          ),
                        ],
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

  void showTerms() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Terms & Conditions'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(
              'Welcome to Pizzeria! By creating an account and using this '
              'app, you agree to the following terms.\n\n'
              '1. Account Registration\n'
              'You must provide accurate and complete information when '
              'creating an account. You are responsible for keeping your '
              'password secure and for all activity under your account.\n\n'
              '2. Orders and Payment\n'
              'All orders placed through the app are subject to '
              'availability. Prices are shown at checkout and may change '
              'without prior notice. Payment must be completed before an '
              'order is confirmed.\n\n'
              '3. Delivery\n'
              'Estimated delivery times are approximate and may vary due '
              'to weather, traffic, or order volume. We are not '
              'responsible for delays caused by factors outside our '
              'control.\n\n'
              '4. Cancellations and Refunds\n'
              'Orders may be cancelled before they enter preparation. '
              'Once preparation has started, cancellations may not be '
              'accepted. Refunds, if applicable, will be processed within '
              'a reasonable time.\n\n'
              '5. User Conduct\n'
              'You agree not to misuse the app, interfere with its '
              'normal operation, or attempt to access accounts that are '
              'not yours.\n\n'
              '6. Changes to These Terms\n'
              'We may update these terms from time to time. Continued '
              'use of the app after changes are made means you accept '
              'the updated terms.\n\n'
              '7. Contact\n'
              'For questions about these terms, please contact our '
              'support team through the app.',
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: orange)),
          ),
        ],
      ),
    );
  }
}
