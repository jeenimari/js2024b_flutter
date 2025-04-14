// widgets/review_card.dart
import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/review.dart';
import 'password_dialog.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final Function(int) onDeleteReview;

  const ReviewCard({
    Key? key,
    required this.review,
    required this.onDeleteReview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더 영역
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.comment_outlined,
                    size: 18.0,
                    color: AppTheme.accentColor,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    '익명 리뷰',
                    style: AppTheme.subtitleStyle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 20.0,
                    ),
                    onPressed: () => _showDeleteConfirmation(context),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8.0),
                    splashRadius: 24.0,
                    tooltip: '리뷰 삭제',
                  ),
                ],
              ),
            ),

            // 내용 영역
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.rcontent,
                    style: AppTheme.bodyStyle,
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'ID: #${review.rno}',
                        style: AppTheme.captionStyle.copyWith(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('리뷰 삭제'),
        content: const Text('이 리뷰를 삭제하시겠습니까? 삭제하려면 비밀번호를 입력하세요.'),
        actions: [
          TextButton(
            child: const Text('취소'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('삭제'),
            onPressed: () {
              Navigator.pop(context);
              _showPasswordDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PasswordDialog(
        title: '비밀번호 확인',
        message: '리뷰 작성 시 설정한 비밀번호를 입력하세요.',
        onConfirm: (password) {
          if (password == review.rpw) {
            onDeleteReview(review.rno!);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('리뷰가 삭제되었습니다.')),
            );
          } else {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('비밀번호가 일치하지 않습니다.'),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          }
        },
      ),
    );
  }
}