import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
  });
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(Colors.white12),
        backgroundColor:
            MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
        minimumSize: MaterialStateProperty.all<Size>(const Size(120, 50)),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      onPressed: onTap,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
