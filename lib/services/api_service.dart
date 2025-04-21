// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_dto.dart';
import '../models/reply_dto.dart';

class ApiService {
  final String baseUrl = 'http://192.168.40.26:8080/task/book'; // 에뮬레이터에서 localhost 접근용

  // 1. 책 추천 등록
  Future<TaskDto> saveBook(TaskDto taskDto) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(taskDto.toJson()),
    );

    if (response.statusCode == 200) {
      return TaskDto.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('책 등록에 실패했습니다');
    }
  }

  // 2. 책 추천 수정
  Future<TaskDto> updateBook(TaskDto taskDto) async {
    final response = await http.put(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(taskDto.toJson()),
    );

    if (response.statusCode == 200) {
      return TaskDto.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('책 수정에 실패했습니다');
    }
  }

  // 3. 책 추천 삭제
  Future<bool> deleteBook(int bno) async {
    final response = await http.delete(
      Uri.parse('$baseUrl?bno=$bno'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('책 삭제에 실패했습니다');
    }
  }

  // 4. 책 추천 전체 조회
  Future<List<TaskDto>> getAllBooks() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((item) => TaskDto.fromJson(item)).toList();
    } else {
      throw Exception('책 목록을 불러오는데 실패했습니다');
    }
  }

  // 5. 책 개별 조회
  Future<TaskDto> getBookByBno(int bno) async {
    final response = await http.get(Uri.parse('$baseUrl/view?bno=$bno'));

    if (response.statusCode == 200) {
      return TaskDto.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('책 상세 정보를 불러오는데 실패했습니다');
    }
  }

  // 6. 리뷰 등록
  Future<ReplyDto> saveReply(ReplyDto replyDto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reply'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(replyDto.toJson()),
    );

    if (response.statusCode == 200) {
      return ReplyDto.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('리뷰 등록에 실패했습니다');
    }
  }

  // 7. 리뷰 삭제
  Future<bool> deleteReply(int rno) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/reply?rno=$rno'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('리뷰 삭제에 실패했습니다');
    }
  }

  // 8. 책 별 리뷰 전체 조회
  Future<List<ReplyDto>> getRepliesByBno(int bno) async {
    final response = await http.get(Uri.parse('$baseUrl/reply/view?bno=$bno'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((item) => ReplyDto.fromJson(item)).toList();
    } else {
      throw Exception('리뷰를 불러오는데 실패했습니다');
    }
  }
}