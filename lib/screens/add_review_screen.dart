// screens/add_review_screen.dart
import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/review.dart';
import '../services/api_service.dart';
import '../widgets/custom_text_field.dart';

class AddReviewScreen extends StatefulWidget {
  final int bookId;

  const AddReviewScreen({
    Key? key,
    required this.bookId,
  }) : super(key: key);

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  void dispose() {
    _contentController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final review = Review(
        rcontent: _contentController.text,
        rpw: _passwordController.text,
        bno: widget.bookId,
      );

      try {
        await _apiService.addReview(review);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('리뷰가 성공적으로 추가되었습니다.'),
              backgroundColor: AppTheme.successColor,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('오류: $e'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('리뷰 작성'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '이 책에 대한 리뷰를 남겨주세요',
                style: AppTheme.headlineStyle,
              ),
              const SizedBox(height: 24.0),
              CustomTextField(
                controller: _contentController,
                label: '리뷰 내용',
                hint: '책에 대한 감상이나 의견을 자유롭게 작성해주세요',
                icon: Icons.comment,
                isMultiLine: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '리뷰 내용을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: _passwordController,
                label: '비밀번호',
                hint: '삭제를 위한 비밀번호를 설정하세요',
                icon: Icons.lock,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해주세요';
                  }
                  if (value.length < 4) {
                    return '비밀번호는 최소 4자 이상이어야 합니다';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  '리뷰 등록하기',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}