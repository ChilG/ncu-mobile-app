import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:list_view_demo/constants/app_strings.dart';
import 'package:list_view_demo/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.sarabunTextTheme(),
      ),
      home: const MyHomePage(title: AppStrings.homeTitle),
    );
  }
}
