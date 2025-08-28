import 'package:flutter/material.dart';
import '../../core/constant/color.dart';

class CustomButton extends StatelessWidget {
  final String txt;
  final VoidCallback onPress;

  CustomButton({
    required this.txt,
    required this.onPress,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: primaryColor, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: TextButton(
            child: Text(
              txt,
              style: const TextStyle(
                  fontFamily: 'ProximaSoft',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
            onPressed: onPress,
          ),
        ),
      ),
    );
  }
}
