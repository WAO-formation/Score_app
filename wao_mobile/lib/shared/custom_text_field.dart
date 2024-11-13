import 'package:flutter/material.dart';

import 'custom_text.dart';

class SecondaryCustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool isRequired;
  final Icon? suffixIcon;
  final String? prefix;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Color errorColor;
  final TextInputType keyboardType;
  final bool obscureText;
  final String labelText;
  final double? height;

  const SecondaryCustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.isRequired = false,
    this.suffixIcon,
    this.controller,
    this.validator,
    required this.errorColor,
    required Color borderColor,
    required this.keyboardType,
    required this.obscureText,
    required this.labelText,
    this.prefix,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: height, // Apply height if provided
          child: TextFormField(
            obscureText: obscureText,
            keyboardType: keyboardType,
            controller: controller,
            style: TextStyle(
              color: Colors.black.withOpacity(0.8),
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: false,
              contentPadding: height != null
                  ? EdgeInsets.symmetric(vertical: (height! - 16) / 2)
                  : const EdgeInsets.symmetric(vertical: 12.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  width: 2.0,
                  color: const Color(0xff6c757d).withOpacity(0.8),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  width: 1.5,
                  color: const Color(0xff6c757d).withOpacity(0.8),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  width: 1.5,
                  color: const Color(0xff6c757d).withOpacity(0.8),
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  width: 2.0,
                  color: errorColor,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  width: 2.0,
                  color: errorColor,
                ),
              ),
              suffixIcon: suffixIcon,
              prefixText: prefix,
              prefixStyle: AppStyles.informationText,
              labelText: labelText,
              labelStyle: TextStyle(
                fontSize: 16,
                color: const Color(0xff6c757d).withOpacity(0.8),
              ),
              hintText: hintText,
              hintStyle: TextStyle(
                color: const Color(0xff6c757d).withOpacity(0.8),
                fontSize: 16.0,
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}
