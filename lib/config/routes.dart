// config/routes.dart
import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/book_detail_screen.dart';
import '../screens/add_book_screen.dart';
import '../screens/edit_book_screen.dart';
import '../screens/add_review_screen.dart';
import '../models/book.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String bookDetail = '/book/detail';
  static const String addBook = '/book/add';
  static const String editBook = '/book/edit';
  static const String addReview = '/review/add';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case bookDetail:
        final args = settings.arguments as Map<String, dynamic>;
        final int bookId = args['bookId'];
        return MaterialPageRoute(
          builder: (_) => BookDetailScreen(bookId: bookId),
        );
      case addBook:
        return MaterialPageRoute(builder: (_) => const AddBookScreen());
      case editBook:
        final args = settings.arguments as Map<String, dynamic>;
        final Book book = args['book'];
        return MaterialPageRoute(
          builder: (_) => EditBookScreen(book: book),
        );
      case addReview:
        final args = settings.arguments as Map<String, dynamic>;
        final int bookId = args['bookId'];
        return MaterialPageRoute(
          builder: (_) => AddReviewScreen(bookId: bookId),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}