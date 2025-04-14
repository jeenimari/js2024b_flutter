// screens/add_book_screen.dart
import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/book.dart';
import '../services/api_service.dart';
import '../widgets/custom_text_field.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({Key? key}) : super(key: key);

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _contentController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitBook() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final book = Book(
        title: _titleController.text,
        author: _authorController.text,
        content: _contentController.text,
        pw: _passwordController.text,
      );

      try {
        await _apiService.addBook(book);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('책이 성공적으로 추가되었습니다.'),
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
        title: const Text('책 추천하기'),
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
                '새로운 책을 추천해주세요!',
                style: AppTheme.headlineStyle,
              ),
              const SizedBox(height: 24.0),
              CustomTextField(
                controller: _titleController,
                label: '책 제목',
                hint: '책 제목을 입력하세요',
                icon: Icons.book,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '책 제목을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: _authorController,
                label: '저자',
                hint: '저자 이름을 입력하세요',
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '저자 이름을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: _contentController,
                label: '책 소개',
                hint: '책에 대한 간단한 소개나 추천 이유를 남겨주세요',
                icon: Icons.description,
                isMultiLine: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '책 소개를 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: _passwordController,
                label: '비밀번호',
                hint: '수정/삭제를 위한 비밀번호를 설정하세요',
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
                onPressed: _submitBook,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  '책 추천하기',
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