import 'package:flutter/material.dart';
import 'package:wao_mobile/shared/theme_data.dart';

import 'custom_text.dart';


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
          style: AppStyles.secondaryTitle.copyWith(color: lightColorScheme.surface),
        ),
        centerTitle: centerTitle,
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child:  Icon(Icons.more_vert, color: lightColorScheme.surface, size: 18.0),
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

class PrimaryCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final IconButton leading;


  const PrimaryCustomAppBar({
    required this.title,
    this.centerTitle = true,
    required this.leading,
  });




  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(100.0), // Adjust the height as needed
      child: AppBar(
        leading: leading,
        title: Text(
          title,
          style: AppStyles.secondaryTitle.copyWith(color: lightColorScheme.surface),
        ),
        centerTitle: centerTitle,
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child:  Icon(Icons.more_vert, color: lightColorScheme.surface, size: 18.0),
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
