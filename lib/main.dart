import 'package:ct484_project/firebase_options.dart';
import 'package:ct484_project/services/firebase_auth_service.dart';
import 'package:ct484_project/services/firebase_storage_service.dart';
import 'package:ct484_project/services/post_service.dart';
import 'package:ct484_project/services/user_service.dart';
import 'package:ct484_project/ui/auth/auth_gate.dart';
import 'package:ct484_project/ui/auth/login_screen.dart';
import 'package:ct484_project/ui/auth/password_reset_screen.dart';
import 'package:ct484_project/ui/auth/signup_screen.dart';
import 'package:ct484_project/ui/home/home_screen.dart';
import 'package:ct484_project/ui/pages/create_new_post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        Provider<FirebaseStorageService>(
          create: (ctx) => FirebaseStorageService(FirebaseStorage.instance),
        ),
        Provider<PostService>(
          create: (ctx) => PostService(),
        ),
        Provider<UserService>(
          create: (ctx) => UserService(),
        )
      ],
      // CHANGE THE COLOR OF STATUS BAR
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white),
        child: MaterialApp(
          title: 'Photos Share',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme:
                FlexColorScheme.light(scheme: FlexScheme.aquaBlue).toScheme,
            textTheme: GoogleFonts.robotoFlexTextTheme(),
            useMaterial3: true,
          ),
          routes: {
            HomeScreen.routeName: (context) => const HomeScreen(),
            PasswordResetScreen.routeName: (context) =>
                const PasswordResetScreen(),
            LoginScreen.routeName: (context) => const LoginScreen(),
            SignUpScreen.routeName: (context) => const SignUpScreen(),
            CreateNewPostScreen.routeName: (context) =>
                const CreateNewPostScreen(),
          },
          home: const AuthGate(),
        ),
      ),
    );
  }
}
