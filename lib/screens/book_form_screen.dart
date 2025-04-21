import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_dto.dart';
import '../services/api_service.dart';

class BookFormScreen extends StatefulWidget {
  final TaskDto? book;

  BookFormScreen({this.book});

  @override
  _BookFormScreenState createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _contentController = TextEditingController();
  final _pwController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _titleController.text = widget.book!.title;
      _authorController.text = widget.book!.author;
      _contentController.text = widget.book!.content;
      _pwController.text = widget.book!.pw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book == null ? '책 추천 등록' : '책 추천 수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: '책 제목'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '책 제목을 입력해주세요';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _authorController,
                  decoration: InputDecoration(labelText: '저자'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '저자를 입력해주세요';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(labelText: '소개내용'),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '소개내용을 입력해주세요';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _pwController,
                  decoration: InputDecoration(labelText: '비밀번호'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력해주세요';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(widget.book == null ? '등록하기' : '수정하기'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final apiService = Provider.of<ApiService>(context, listen: false);

      try {
        final taskDto = TaskDto(
          bno: widget.book?.bno,
          title: _titleController.text,
          author: _authorController.text,
          content: _contentController.text,
          pw: _pwController.text,
        );

        if (widget.book == null) {
          await apiService.saveBook(taskDto);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('책 추천이 등록되었습니다')),
          );
        } else {
          await apiService.updateBook(taskDto);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('책 추천이 수정되었습니다')),
          );
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _contentController.dispose();
    _pwController.dispose();
    super.dispose();
  }
}
