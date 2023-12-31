import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_front/screens/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:owner_front/screens/home_screen.dart';
import 'package:owner_front/screens/splash_screen.dart';
import 'firebase/firebase_options.dart';

var kColorScheme = ColorScheme.fromSeed(seedColor: const Color(0xff0f2138));

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        scaffoldBackgroundColor: const Color(0xfffcfdfd),
        colorScheme: kColorScheme,
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme().copyWith(
          titleLarge: const TextStyle().copyWith(
            color: const Color(0xff343d48),
          ),
        ),
        appBarTheme: const AppBarTheme().copyWith(
          color: const Color(0xfffcfdfd),
          foregroundColor: const Color(0xff343d48),
        ),
        cardTheme: const CardTheme().copyWith(color: Colors.white),
        bottomSheetTheme: const BottomSheetThemeData()
            .copyWith(modalBackgroundColor: Colors.white),
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData().copyWith(
          backgroundColor: const Color(0xff0f2138),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snapshot.hasData) {
            return const HomePage();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
