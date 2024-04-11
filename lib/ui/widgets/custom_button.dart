import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    this.isLoading = false,
  });
  final String text;
  final VoidCallback onTap;
  bool isLoading;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(Colors.white12),
        backgroundColor:
            MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
        minimumSize: MaterialStateProperty.all<Size>(
          const Size(110, 45),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      onPressed: !isLoading ? onTap : null,
      child: !isLoading
          ? Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            )
          : const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
    );
  }
}
