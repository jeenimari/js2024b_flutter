// widgets/book_card.dart
import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/book.dart';
import '../config/routes.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final Function()? onTap;

  const BookCard({
    Key? key,
    required this.book,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {
        Navigator.pushNamed(
          context,
          AppRoutes.bookDetail,
          arguments: {'bookId': book.bno},
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              offset: const Offset(0, 3),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryColor,
                    Color(0xFF8982FF),
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.menu_book,
                size: 50,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: AppTheme.titleStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '저자: ${book.author}',
                    style: AppTheme.bodyStyle,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    book.content,
                    style: AppTheme.captionStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (book.createAt != null) ...[
                    const SizedBox(height: 8.0),
                    Text(
                      '등록: ${_formatDate(book.createAt!)}',
                      style: AppTheme.captionStyle.copyWith(
                        fontSize: 10.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}