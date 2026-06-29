import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_me/dashboard.dart';
import 'package:hire_me/providers/nav_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GoogleFonts.pendingFonts([
    GoogleFonts.dmSans(),
    GoogleFonts.poppins(),
    GoogleFonts.inter(),
    GoogleFonts.jetBrainsMono(),
  ]);

  runApp(
    ChangeNotifierProvider(
      create: (_) => NavProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zohaib Hassan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF050505),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF00F5FF),
        ),
      ),
      home: const Dashboard(),
    );
  }
}