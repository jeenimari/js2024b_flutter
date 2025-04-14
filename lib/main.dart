// main.dart
import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'config/routes.dart';

void main() {
  runApp(const BookSharingApp());
}

class BookSharingApp extends StatelessWidget {
  const BookSharingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '북쉐어 - 익명 도서 추천 앱',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}