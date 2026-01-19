import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/tactical_lineup_screen.dart';
import 'screens/squad_management_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF101622),
        primaryColor: const Color(0xFF0d59f2),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),

      ),
      home: const TacticalLineupScreen(),
      routes: {
        '/tactical': (context) => const TacticalLineupScreen(),
        '/squad': (context) => const SquadManagementScreen(),
      },
    );
  }
}
