import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;

  CustomAppBar({
    required this.title,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(100.0), // Adjust the height as needed
      child: AppBar(
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        centerTitle: centerTitle,
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: const Icon(Icons.more_vert, color: Colors.white, size: 18.0),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    )
    ;
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
