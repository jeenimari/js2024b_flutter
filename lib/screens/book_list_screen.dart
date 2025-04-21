// lib/screens/book_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_dto.dart';
import '../services/api_service.dart';
import 'book_detail_screen.dart';
import 'book_form_screen.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  late Future<List<TaskDto>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _refreshBooks();
  }

  void _refreshBooks() {
    _booksFuture = Provider.of<ApiService>(context, listen: false).getAllBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('책 추천 목록'),
      ),
      body: FutureBuilder<List<TaskDto>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('오류가 발생했습니다: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('추천된 책이 없습니다.'));
          }

          final books = snapshot.data!;
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(book.title),
                  subtitle: Text('저자: ${book.author}'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailScreen(bno: book.bno!),
                      ),
                    );
                    // 상세 페이지에서 돌아오면 목록 갱신
                    setState(() {
                      _refreshBooks();
                    });
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookFormScreen()),
          );
          // 등록 페이지에서 돌아오면 목록 갱신
          setState(() {
            _refreshBooks();
          });
        },
        child: Icon(Icons.add),
        tooltip: '책 추천 등록',
      ),
    );
  }
}