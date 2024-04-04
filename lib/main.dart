import 'package:ct484_project/firebase_options.dart';
import 'package:ct484_project/ui/auth/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photos Share',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: FlexColorScheme.light(scheme: FlexScheme.aquaBlue).toScheme,
        textTheme: GoogleFonts.robotoFlexTextTheme(),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}