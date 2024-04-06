import 'package:ct484_project/firebase_options.dart';
import 'package:ct484_project/services/firebase_auth_service.dart';
import 'package:ct484_project/ui/auth/auth_gate.dart';
import 'package:ct484_project/ui/auth/login_screen.dart';
import 'package:ct484_project/ui/auth/password_reset_screen.dart';
import 'package:ct484_project/ui/auth/signup_screen.dart';
import 'package:ct484_project/ui/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: (ctx) => FirebaseAuthService(FirebaseAuth.instance),
        ),
      ],
      child: MaterialApp(
        title: 'Photos Share',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: ThemeData(
          colorScheme:
              FlexColorScheme.light(scheme: FlexScheme.aquaBlue).toScheme,
          textTheme: GoogleFonts.robotoFlexTextTheme(),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme:
              FlexColorScheme.dark(scheme: FlexScheme.aquaBlue).toScheme,
          textTheme: GoogleFonts.robotoFlexTextTheme(),
          useMaterial3: true,
        ),
        routes: {
          HomeScreen.routeName: (context) => const HomeScreen(),
          PasswordResetScreen.routeName: (context) =>
              const PasswordResetScreen(),
          LoginScreen.routeName: (context) => const LoginScreen(),
          SignUpScreen.routeName: (context) => const SignUpScreen(),
        },
        home: const AuthGate(),
      ),
    );
  }
}
