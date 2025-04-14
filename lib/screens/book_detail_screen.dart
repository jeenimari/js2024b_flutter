// screens/book_detail_screen.dart
import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../config/routes.dart';
import '../models/book.dart';
import '../models/review.dart';
import '../services/api_service.dart';
import '../widgets/review_card.dart';
import '../widgets/password_dialog.dart';

class BookDetailScreen extends StatefulWidget {
  final int bookId;

  const BookDetailScreen({
    Key? key,
    required this.bookId,
  }) : super(key: key);

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final ApiService _apiService = ApiService();
  late Future<Book> _bookFuture;
  late Future<List<Review>> _reviewsFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _isLoading = true;
      _bookFuture = _apiService.getBookByBno(widget.bookId);
      _reviewsFuture = _apiService.getReviewsByBookId(widget.bookId);
    });
  }

  void _deleteBook(Book book) {
    showDialog(
      context: context,
      builder: (context) => PasswordDialog(
        title: '비밀번호 확인',
        message: '책 등록 시 설정한 비밀번호를 입력하세요.',
        onConfirm: (password) async {
          if (password == book.pw) {
            Navigator.pop(context);
            setState(() {
              _isLoading = true;
            });

            try {
              final result = await _apiService.deleteBook(book.bno!);
              if (result) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('책이 삭제되었습니다.')),
                );
                Navigator.pop(context); // 상세 화면 나가기
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('책 삭제 실패'),
                    backgroundColor: AppTheme.errorColor,
                  ),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('오류: $e'),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            } finally {
              setState(() {
                _isLoading = false;
              });
            }
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

  void _editBook(Book book) {
    showDialog(
      context: context,
      builder: (context) => PasswordDialog(
        title: '비밀번호 확인',
        message: '책 등록 시 설정한 비밀번호를 입력하세요.',
        onConfirm: (password) {
          if (password == book.pw) {
            Navigator.pop(context);
            Navigator.pushNamed(
              context,
              AppRoutes.editBook,
              arguments: {'book': book},
            ).then((_) => _loadData());
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

  Future<void> _deleteReview(int rno) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _apiService.deleteReview(rno);
      if (result) {
        setState(() {
          _reviewsFuture = _apiService.getReviewsByBookId(widget.bookId);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('리뷰 삭제 실패'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('오류: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('책 상세정보'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<Book>(
        future: _bookFuture,
        builder: (context, bookSnapshot) {
          if (bookSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (bookSnapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '오류가 발생했습니다: ${bookSnapshot.error}',
                    style: AppTheme.bodyStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          } else if (!bookSnapshot.hasData) {
            return const Center(
              child: Text('책 정보를 찾을 수 없습니다.'),
            );
          }

          final book = bookSnapshot.data!;
          return CustomScrollView(
            slivers: [
              // 책 정보 영역
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 책 제목 및 관리 버튼
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              book.title,
                              style: AppTheme.headlineStyle,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editBook(book),
                            color: AppTheme.accentColor,
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteBook(book),
                            color: Colors.red,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      // 저자
                      Text(
                        '저자: ${book.author}',
                        style: AppTheme.subtitleStyle,
                      ),
                      const SizedBox(height: 16.0),
                      // 소개 내용
                      const Text(
                        '소개',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          book.content,
                          style: AppTheme.bodyStyle,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      // 등록 날짜
                      if (book.createAt != null)
                        Text(
                          '등록일: ${_formatDate(book.createAt!)}',
                          style: AppTheme.captionStyle,
                        ),
                    ],
                  ),
                ),
              ),

              // 리뷰 영역 제목
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '리뷰',
                        style: AppTheme.titleStyle,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.addReview,
                            arguments: {'bookId': book.bno},
                          ).then((_) => _loadData());
                        },
                        icon: const Icon(Icons.add_comment),
                        label: const Text('리뷰 작성'),
                      ),
                    ],
                  ),
                ),
              ),

              // 리뷰 목록
              FutureBuilder<List<Review>>(
                future: _reviewsFuture,
                builder: (context, reviewsSnapshot) {
                  if (reviewsSnapshot.connectionState == ConnectionState.waiting) {
                    return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (reviewsSnapshot.hasError) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.orange,
                                size: 40,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '리뷰를 불러오는 중 오류가 발생했습니다: ${reviewsSnapshot.error}',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (!reviewsSnapshot.hasData || reviewsSnapshot.data!.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.comment_outlined,
                                color: Colors.grey,
                                size: 40,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '아직 작성된 리뷰가 없습니다.\n첫 리뷰를 작성해보세요!',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  final reviews = reviewsSnapshot.data!;
                  return SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          return ReviewCard(
                            review: reviews[index],
                            onDeleteReview: _deleteReview,
                          );
                        },
                        childCount: reviews.length,
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.addReview,
            arguments: {'bookId': widget.bookId},
          ).then((_) => _loadData());
        },
        backgroundColor: AppTheme.accentColor,
        child: const Icon(Icons.add_comment),
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