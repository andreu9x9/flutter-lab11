import 'package:flutter/material.dart';
import 'screens/store_home_screen.dart';

void main() {
  runApp(const AsyncStoreApp());
}

class AsyncStoreApp extends StatelessWidget {
  const AsyncStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Інтернет-магазин (Async)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal.shade100,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(46),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.teal,
            side: const BorderSide(color: Colors.teal),
            minimumSize: const Size.fromHeight(46),
          ),
        ),
      ),
      home: const StoreHomeScreen(),
    );
  }
}