import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showFlushbar({required BuildContext context, required String message, Color? color}) {
  Flushbar(
    message: message,
    duration: const Duration(seconds: 3),
    animationDuration: const Duration(milliseconds: 300),
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    borderRadius: BorderRadius.circular(8),
    borderColor: color ?? Theme.of(context).colorScheme.error,
    borderWidth: 1,
    backgroundColor: Colors.white,
    messageColor: color ?? Theme.of(context).colorScheme.error,
  ).show(context);
}
