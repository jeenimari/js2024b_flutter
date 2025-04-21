// lib/screens/book_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_dto.dart';
import '../models/reply_dto.dart';
import '../services/api_service.dart';
import 'book_form_screen.dart';

class BookDetailScreen extends StatefulWidget {
  final int bno;

  BookDetailScreen({required this.bno});

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late Future<TaskDto> _bookFuture;
  late Future<List<ReplyDto>> _repliesFuture;

  final _replyController = TextEditingController();
  final _replyPwController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    final apiService = Provider.of<ApiService>(context, listen: false);
    _bookFuture = apiService.getBookByBno(widget.bno);
    _repliesFuture = apiService.getRepliesByBno(widget.bno);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('책 상세 정보'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _showEditDialog(),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<TaskDto>(
                future: _bookFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('오류가 발생했습니다: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('책 정보를 찾을 수 없습니다.'));
                  }

                  final book = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('저자: ${book.author}', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 16),
                      Text(
                        '소개내용',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(book.content, style: TextStyle(fontSize: 16)),
                      SizedBox(height: 24),
                      Divider(),
                    ],
                  );
                },
              ),
              SizedBox(height: 16),
              Text(
                '리뷰',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              // 리뷰 목록
              FutureBuilder<List<ReplyDto>>(
                future: _repliesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('리뷰를 불러오는데 실패했습니다: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('리뷰가 없습니다.'));
                  }

                  final replies = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: replies.length,
                    itemBuilder: (context, index) {
                      final reply = replies[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(reply.rcontent),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => _showReplyDeleteDialog(reply.rno!),
                                    child: Text('삭제'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              // 리뷰 작성 폼
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '리뷰 작성',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _replyController,
                        decoration: InputDecoration(
                          hintText: '리뷰를 작성해주세요',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _replyPwController,
                        decoration: InputDecoration(
                          hintText: '비밀번호',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _submitReply,
                        child: Text('리뷰 등록'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 40),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitReply() async {
    if (_replyController.text.isEmpty || _replyPwController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('리뷰 내용과 비밀번호를 모두 입력해주세요')),
      );
      return;
    }

    try {
      final replyDto = ReplyDto(
        rcontent: _replyController.text,
        rpw: _replyPwController.text,
        bno: widget.bno,
      );

      await Provider.of<ApiService>(context, listen: false).saveReply(replyDto);

      // 입력 필드 초기화
      _replyController.clear();
      _replyPwController.clear();

      // 리뷰 목록 갱신
      setState(() {
        _refreshData();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('리뷰가 등록되었습니다')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('리뷰 등록에 실패했습니다: $e')),
      );
    }
  }

  void _showEditDialog() async {
    final book = await _bookFuture;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('비밀번호 확인'),
          content: TextField(
            controller: _passwordController,
            decoration: InputDecoration(hintText: '비밀번호 입력'),
            obscureText: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                if (_passwordController.text == book.pw) {
                  Navigator.pop(context);
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookFormScreen(book: book),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      _refreshData();
                    });
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('비밀번호가 일치하지 않습니다')),
                  );
                  Navigator.pop(context);
                }
                _passwordController.clear();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('책 삭제'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('정말 삭제하시겠습니까?'),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(hintText: '비밀번호 입력'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final book = await _bookFuture;
                  if (_passwordController.text != book.pw) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('비밀번호가 일치하지 않습니다')),
                    );
                    Navigator.pop(context);
                    return;
                  }

                  final result = await Provider.of<ApiService>(context, listen: false)
                      .deleteBook(widget.bno);

                  Navigator.pop(context); // 대화상자 닫기

                  if (result) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('책이 삭제되었습니다')),
                    );
                    Navigator.pop(context); // 상세 화면 닫기
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('삭제에 실패했습니다')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('오류가 발생했습니다: $e')),
                  );
                  Navigator.pop(context);
                }
                _passwordController.clear();
              },
              child: Text('삭제'),
            ),
          ],
        );
      },
    );
  }

  void _showReplyDeleteDialog(int rno) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('리뷰 삭제'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('정말 삭제하시겠습니까?'),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(hintText: '비밀번호 입력'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // 비밀번호 검증 로직이 필요하나 백엔드에 그런 API가 없음
                  // 실제로는 비밀번호 확인 후 삭제하는 API가 필요
                  final result = await Provider.of<ApiService>(context, listen: false)
                      .deleteReply(rno);

                  Navigator.pop(context);

                  if (result) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('리뷰가 삭제되었습니다')),
                    );
                    setState(() {
                      _refreshData();
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('리뷰 삭제에 실패했습니다')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('오류가 발생했습니다: $e')),
                  );
                  Navigator.pop(context);
                }
                _passwordController.clear();
              },
              child: Text('삭제'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _replyController.dispose();
    _replyPwController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}