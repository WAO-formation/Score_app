import 'package:flutter/material.dart';

import '../Theme/theme_data.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final Widget? leading;

  CustomAppBar({
    required this.title,
    this.centerTitle = true,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(100.0), // Adjust the height as needed
      child: AppBar(
        leading: leading,
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        centerTitle: centerTitle,
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: const Icon(Icons.more_vert, color: Colors.white, size: 18.0),
          ),
        ],
        backgroundColor: lightColorScheme.secondary,
      ),
    )
    ;
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
