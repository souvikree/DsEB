import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Screen/splash_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/splash_screen',
      routes: {
        // '/home': (context) => const HomeScreen(),
        // '/login': (context) => const LoginScreen(),
        // '/register': (context) => const RegistrationScreen(),
        // '/prediction': (context) => const PredictionScreen(),
        '/splash_screen': (context) => const MySplashScreen(),
         },
    );
  }
}

