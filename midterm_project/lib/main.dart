import 'package:flutter/material.dart';
import 'welcome_view.dart';
import 'login_view.dart';
import 'create_account_view.dart';
import 'home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pizzeria',
      theme: ThemeData(
        primaryColor: const Color(0xFFFF6B4A),
        fontFamily: 'Roboto',
      ),
      home: const RootScreen(),
    );
  }
}

enum AppView { welcome, login, createAccount, home }

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final List<AppView> _stack = [AppView.welcome];
  String _homeGreeting = '';

  AppView get _current => _stack.last;

  // Equivalent of Navigator.push: adds a new view on top.
  void _push(AppView view) => setState(() => _stack.add(view));

  // Equivalent of Navigator.pushReplacement: swaps the current top view.
  void _replace(AppView view) => setState(() => _stack[_stack.length - 1] = view);

  // Equivalent of Navigator.maybePop: goes back if there's somewhere to go.
  void _pop() {
    if (_stack.length > 1) {
      setState(() => _stack.removeLast());
    }
  }

  void _goToLogin() => _push(AppView.login);
  void _goToCreateAccount() => _push(AppView.createAccount);
  void _switchToCreateAccount() => _replace(AppView.createAccount);
  void _switchToLogin() => _replace(AppView.login);

  void _onSignInSuccess(String email) {
    setState(() {
      _homeGreeting = 'Signed in as $email';
      _stack[_stack.length - 1] = AppView.home;
    });
  }

  void _onAccountCreated(String firstName, String email) {
    setState(() {
      _homeGreeting = 'Welcome, $firstName! Your account has been created.';
      _stack[_stack.length - 1] = AppView.home;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_current) {
      case AppView.welcome:
        return WelcomeView(
          onSignIn: _goToLogin,
          onCreateAccount: _goToCreateAccount,
        );

      case AppView.login:
        return LoginView(
          onBack: _pop,
          onGoToSignUp: _switchToCreateAccount,
          onSignInSuccess: _onSignInSuccess,
        );

      case AppView.createAccount:
        return CreateAccountView(
          onBack: _pop,
          onGoToSignIn: _switchToLogin,
          onAccountCreated: _onAccountCreated,
        );

      case AppView.home:
        return HomeView(
          greeting: _homeGreeting,
          onBack: _pop,
        );
    }
  }
}
