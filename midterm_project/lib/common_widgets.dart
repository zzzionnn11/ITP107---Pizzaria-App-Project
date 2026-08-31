import 'package:flutter/material.dart';

const orange = Color(0xFFFF6B4A);

/// A styled text field used by both the login and create-account forms.
class AccountField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffix;
  final String? Function(String?)? validator;

  const AccountField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.suffix,
    this.validator,
  });

  @override
  State<AccountField> createState() => _AccountFieldState();
}

class _AccountFieldState extends State<AccountField> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: hovering
              ? [
                  const BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ]
              : [],
        ),
        child: TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          validator: widget.validator,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelStyle: TextStyle(
              color: hovering ? orange : Colors.black54,
              fontSize: 11,
            ),
            hintStyle: const TextStyle(
              color: Color(0xFFAAAAAA),
              fontSize: 14,
            ),
            prefixIcon: Icon(
              widget.icon,
              color: hovering ? orange : const Color(0xFFAAAAAA),
              size: 20,
            ),
            suffixIcon: widget.suffix,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFFD0D0D0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: hovering ? orange : const Color(0xFFD0D0D0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: orange,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Colors.redAccent,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Colors.redAccent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget accountField({
  required String label,
  required String hint,
  required IconData icon,
  required TextEditingController controller,
  TextInputType? keyboardType,
  bool obscureText = false,
  bool readOnly = false,
  VoidCallback? onTap,
  Widget? suffix,
  String? Function(String?)? validator,
}) {
  return AccountField(
    label: label,
    hint: hint,
    icon: icon,
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscureText,
    readOnly: readOnly,
    onTap: onTap,
    suffix: suffix,
    validator: validator,
  );
}

/// A filled action button (used for "Sign in" / "Sign up") with a hover state.
class HoverButton extends StatefulWidget {
  final double height;
  final double borderRadius;
  final VoidCallback onTap;
  final Widget child;

  const HoverButton({
    super.key,
    required this.height,
    required this.borderRadius,
    required this.onTap,
    required this.child,
  });

  @override
  State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          color: hovering ? const Color(0xFFFF795C) : orange,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            onTap: widget.onTap,
            child: Center(child: widget.child),
          ),
        ),
      ),
    );
  }
}

Widget hoverButton({
  required double height,
  required double borderRadius,
  required VoidCallback onTap,
  required Widget child,
}) {
  return HoverButton(
    height: height,
    borderRadius: borderRadius,
    onTap: onTap,
    child: child,
  );
}

/// A small square social-login button (Facebook / Google) with a hover state.
class SocialButton extends StatefulWidget {
  final String name;
  final Widget child;
  final VoidCallback onTap;

  const SocialButton({
    super.key,
    required this.name,
    required this.child,
    required this.onTap,
  });

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 94,
        height: 48,
        decoration: BoxDecoration(
          color: hovering ? const Color(0xFFF8F8F8) : Colors.white,
          borderRadius: BorderRadius.circular(9),
          boxShadow: hovering
              ? [
                  const BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ]
              : [],
        ),
        child: OutlinedButton(
          onPressed: widget.onTap,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
            side: BorderSide(
              color: hovering ? orange : const Color(0xFFD0D0D0),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

Widget socialButton({
  required String name,
  required Widget child,
  required VoidCallback onTap,
}) {
  return SocialButton(
    name: name,
    onTap: onTap,
    child: child,
  );
}
