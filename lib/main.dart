
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meowmedia/screen/splash_screen.dart';
import 'package:meowmedia/util/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ulqnlpbabjsblfceytet.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVscW5scGJhYmpzYmxmY2V5dGV0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY3NDE1NzEsImV4cCI6MjA4MjMxNzU3MX0.iw4HTHZzdFbL-wt4V1EL9flV_hp9WOLBdLFToF8xOAE'
  );
  
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor:
        Color.fromARGB(0, 255, 255, 255), // Make status bar transparent
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArtVerse',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}