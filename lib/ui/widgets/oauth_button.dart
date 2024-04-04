import 'package:flutter/material.dart';

class OauthButton extends StatelessWidget {
  OauthButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.imageAsset,
    required this.buttonColor,
    required this.textColor,
    this.overlayColor,
    this.borderColor,
  });
  final String text;
  final VoidCallback onTap;
  final String imageAsset;
  final Color textColor;
  final Color buttonColor;
  Color? overlayColor;
  Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all<Color>(
            overlayColor != null ? overlayColor! : Colors.white12,
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            buttonColor,
          ),
          minimumSize: MaterialStateProperty.all<Size>(
            const Size(150, 50),
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: borderColor != null
                  ? BorderSide(color: borderColor!)
                  : BorderSide.none,
            ),
          ),
        ),
        onPressed: onTap,
        child: SizedBox(
          width: 250,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(imageAsset),
                height: 20,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16
                ),
              )
            ],
          ),
        ));
  }
}
