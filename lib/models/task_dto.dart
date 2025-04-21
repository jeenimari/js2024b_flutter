import 'package:js2024b_app/models/reply_dto.dart';

class TaskDto {
  int? bno;
  String title;
  String author;
  String content;
  String pw;
  DateTime? createAt;
  List<ReplyDto>? replies;

  TaskDto({
    this.bno,
    required this.title,
    required this.author,
    required this.content,
    required this.pw,
    this.createAt,
    this.replies,
  });

  factory TaskDto.fromJson(Map<String, dynamic> json) {
    return TaskDto(
      bno: json['bno'],
      title: json['title'],
      author: json['author'],
      content: json['content'],
      pw: json['pw'],
      createAt: json['createAt'] != null ? DateTime.parse(json['createAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (bno != null) 'bno': bno,
      'title': title,
      'author': author,
      'content': content,
      'pw': pw,
    };
  }
}
