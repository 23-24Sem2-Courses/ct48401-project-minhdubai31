// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String label;
  String? error;
  bool? autofocus;
  bool? obscureText;

  CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.label,
    this.error,
    this.autofocus,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText != null ? obscureText! : false,
      autofocus: autofocus != null ? autofocus! : false,
      decoration: InputDecoration(
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        filled: true,
        fillColor: const Color(0xfff2f2f6),
        hintText: hintText,
        hintStyle: const TextStyle(color: Color.fromRGBO(0, 0, 0, 0.4)),
        label: Text(label),
        labelStyle: const TextStyle(color: Color.fromRGBO(0, 0, 0, 0.4)),
        floatingLabelStyle: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w600,
        ),
        error: error != null ? Text(error!) : null,
      ),
    );
  }
}
