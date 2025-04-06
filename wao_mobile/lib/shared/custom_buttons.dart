import 'package:flutter/material.dart';

class AuthenticationButtons extends StatelessWidget {
  const AuthenticationButtons({
    super.key,
    required this.label,
    required this.onTap,
    this.width = 260,
    this.color = Colors.black,
    this.colorText = Colors.white,
  });

  final String label;
  final VoidCallback onTap;
  final double width;
  final Color color;
  final Color colorText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Container(
            height: 45,
            width: width,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: colorText,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            )
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
    this.color = Colors.black,
    this.colorText = Colors.white,
  });

  final String label;
  final VoidCallback onTap;
  final double width;
  final Color color;
  final Color colorText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Container(
            height: 40,
            width: width,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: colorText,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            )
        ),
      ),
    );
  }
}

class CartButtons extends StatelessWidget {
  const CartButtons({
    super.key,
    required this.label,
    required this.onTap,
    this.width = 130,
    this.height = 30,
    this.color = Colors.black,
    this.colorText = Colors.white,
  });

  final String label;
  final VoidCallback? onTap;
  final double width;
  final double height;
  final Color color;
  final Color colorText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: colorText,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            )
        ),
      ),
    );
  }
}

class PrimaryCartButtons extends StatelessWidget {
  const PrimaryCartButtons({
    super.key,
    required this.label,
    required this.onTap,
    this.width = 200,
    this.color = Colors.white,
    this.colorText = Colors.black,
  });

  final String label;
  final VoidCallback onTap;
  final double width;
  final Color color;
  final Color colorText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Container(
            height: 50,
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Colors.black,
                )
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: colorText,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            )
        ),
      ),
    );
  }
}