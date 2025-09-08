import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'auth/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/report_violation_screen.dart';
import 'screens/reports_list_screen.dart';
import 'theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAppCheck.instance.activate(
      webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
      androidProvider: AndroidProvider.debug,
    );
  } catch (e) {
    log("Failed to initialize Firebase: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<AuthService>(
        builder: (context, authService, child) {
          final router = GoRouter(
            initialLocation: authService.user != null ? '/home' : '/login',
            routes: [
              GoRoute(
                path: '/login',
                builder: (context, state) => const LoginScreen(),
              ),
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
              GoRoute(
                path: '/report-violation',
                builder: (context, state) => const ReportViolationScreen(),
              ),
              GoRoute(
                path: '/reports',
                builder: (context, state) => const ReportsListScreen(),
              ),
            ],
          );

          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp.router(
                title: 'Civic Eye',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  textTheme: GoogleFonts.robotoTextTheme(
                    Theme.of(context).textTheme,
                  ),
                  appBarTheme: AppBarTheme(
                    backgroundColor: Colors.blue[700],
                    elevation: 0,
                    titleTextStyle: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                darkTheme: ThemeData.dark().copyWith(
                  textTheme: GoogleFonts.robotoTextTheme(
                    ThemeData.dark().textTheme,
                  ),
                  appBarTheme: AppBarTheme(
                    backgroundColor: Colors.grey[900],
                    elevation: 0,
                    titleTextStyle: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                themeMode: themeProvider.themeMode,
                routerConfig: router,
              );
            },
          );
        },
      ),
    );
  }
}
