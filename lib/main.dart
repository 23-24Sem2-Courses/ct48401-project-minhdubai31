import 'package:ct484_project/firebase_options.dart';
import 'package:ct484_project/models/post.dart';
import 'package:ct484_project/models/user.dart';
import 'package:ct484_project/services/comment_service.dart';
import 'package:ct484_project/services/firebase_auth_service.dart';
import 'package:ct484_project/services/firebase_storage_service.dart';
import 'package:ct484_project/services/post_service.dart';
import 'package:ct484_project/services/user_service.dart';
import 'package:ct484_project/ui/auth/auth_gate.dart';
import 'package:ct484_project/ui/auth/login_screen.dart';
import 'package:ct484_project/ui/auth/password_reset_screen.dart';
import 'package:ct484_project/ui/auth/signup_screen.dart';
import 'package:ct484_project/ui/screens/image_view_screen.dart';
import 'package:ct484_project/ui/screens/user_personal_post_screen.dart';
import 'package:ct484_project/ui/screens/create_edit_post_screen.dart';
import 'package:ct484_project/ui/screens/user_profile_edit_screen.dart';
import 'package:ct484_project/ui/screens/user_tab_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
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
        ),
        Provider<CommentService>(
          create: (ctx) => CommentService(),
        ),
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
            bottomSheetTheme: const BottomSheetThemeData(
              surfaceTintColor: Colors.white,
            ),
          ),
          onGenerateRoute: (settings) {
            String? routeName = settings.name;
            Object? args = settings.arguments;
            switch (routeName) {
              case UserPersonalPostScreen.routeName:
                args as Map<String, Object>;
                return MaterialPageRoute(
                  builder: (context) => UserPersonalPostScreen(
                    selectedPostIndex: args["selectedPostIndex"] as int,
                    userId: args["userId"] as String,
                  ),
                );
              case CreateEditPostScreen.routeName:
                return MaterialPageRoute(
                  builder: (context) {
                    args as Map<String, Object>;
                    return CreateEditPostScreen(
                      imageXFile: args['imageXFile'] as XFile?,
                      post: args['post'] as Post?,
                      postId: args['postId'] as String?,
                    );
                  },
                );
              case UserProfileEditScreen.routeName:
                return MaterialPageRoute(
                  builder: (context) =>
                      UserProfileEditScreen(updateUser: args as User),
                );
              case ImageViewScreen.routeName:
                return MaterialPageRoute(
                  builder: (context) => ImageViewScreen(
                    imageUrl: args as String,
                  ),
                );
              case UserTabScreen.routeName:
                return MaterialPageRoute(
                  builder: (context) => UserTabScreen(userId: args as String),
                );
              default:
                return null;
            }
          },
          routes: {
            PasswordResetScreen.routeName: (context) =>
                const PasswordResetScreen(),
            LoginScreen.routeName: (context) => const LoginScreen(),
            SignUpScreen.routeName: (context) => const SignUpScreen(),
          },
          home: const AuthGate(),
        ),
      ),
    );
  }
}
