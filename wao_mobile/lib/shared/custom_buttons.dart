import 'package:flutter/material.dart';
import 'package:wao_mobile/shared/theme_data.dart';

class PrimaryButtonWidget extends StatelessWidget {
  const PrimaryButtonWidget({
    super.key,
    required this.label,
    required this.onTap,
    this.width = 160,
    this.color,
    this.colorText,
  });

  final String label;
  final VoidCallback onTap;
  final double width;
  final Color? color;
  final Color? colorText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Container(
          height: 40,
          width: width,
          decoration: BoxDecoration(
            color: color ?? lightColorScheme.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: colorText ?? Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SecondaryButtonWidget extends StatelessWidget {
  const SecondaryButtonWidget({
    super.key,
    required this.label,
    required this.onTap,
    this.width = 160,
    this.color,
    this.colorText,
  });

  final String label;
  final VoidCallback onTap;
  final double width;
  final Color? color;
  final Color? colorText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Container(
          height: 40,
          width: width,
          decoration: BoxDecoration(
            color: color ?? lightColorScheme.primary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: lightColorScheme.primary),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: colorText ?? lightColorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CartButtonWidget extends StatelessWidget {
  const CartButtonWidget({
    super.key,
    required this.label,
    required this.onTap,
    this.width = 130,
    this.height = 30,
    this.color,
    this.colorText,
  });

  final String label;
  final VoidCallback? onTap;
  final double width;
  final double height;
  final Color? color;
  final Color? colorText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: color ?? lightColorScheme.primary,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: colorText ?? Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}