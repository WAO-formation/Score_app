import 'package:flutter/material.dart';

import '../../shared/custom_text.dart';
import '../../shared/theme_data.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final double fontSize;

  // Constructor
  const PrimaryButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.backgroundColor,
    this.borderColor,
    this.fontSize = 15.0,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? lightColorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: borderColor ?? lightColorScheme.primary,
            width: 2.0,
          ),
        ),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
      ),
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: AppStyles.informationText.copyWith(fontSize: fontSize),
      ),
    );
  }
}
