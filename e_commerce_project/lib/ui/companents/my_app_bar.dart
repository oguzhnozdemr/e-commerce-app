import 'package:flutter/material.dart';


import '../tools/app_colors.dart';
import 'WaveClipper.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {

  //this: Bu sınıfı işaret eder(MyAppBar) - self(ios)
  //super: Kalıtım, bir üst sınıfı işaret eder



  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: mainColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}