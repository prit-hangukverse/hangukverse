import 'package:flutter/material.dart';

class MenuToggleButton extends StatelessWidget {
  final VoidCallback onTap;

  const MenuToggleButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu_sharp, color: Colors.white, size: 30),
      onPressed: onTap,
    );
  }
}
