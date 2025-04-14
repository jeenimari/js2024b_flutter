// models/book.dart
class Book {
  final int? bno; // 책 번호 (null일 경우 새 책)
  final String title; // 책 제목
  final String author; // 저자
  final String content; // 소개내용
  final String pw; // 비밀번호
  final String? createAt; // 등록 날짜

  Book({
    this.bno,
    required this.title,
    required this.author,
    required this.content,
    required this.pw,
    this.createAt,
  });

  // JSON에서 Book 객체로 변환
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      bno: json['bno'],
      title: json['title'],
      author: json['author'],
      content: json['content'],
      pw: json['pw'],
      createAt: json['createAt'],
    );
  }

  // Book 객체에서 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'bno': bno,
      'title': title,
      'author': author,
      'content': content,
      'pw': pw,
    };
  }

  // Book 객체 복사본 생성 (수정 시 사용)
  Book copyWith({
    int? bno,
    String? title,
    String? author,
    String? content,
    String? pw,
    String? createAt,
  }) {
    return Book(
      bno: bno ?? this.bno,
      title: title ?? this.title,
      author: author ?? this.author,
      content: content ?? this.content,
      pw: pw ?? this.pw,
      createAt: createAt ?? this.createAt,
    );
  }
}