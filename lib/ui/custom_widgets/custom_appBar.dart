import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? felxibleSpace;
  final List<Widget>? actions;

  CustomAppBar({this.leading, this.actions,this.felxibleSpace});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: felxibleSpace,
      automaticallyImplyLeading: false,
      actions: actions,
      centerTitle: true,

      //You can customize the elevation as needed
    );
  }

  @override

  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
