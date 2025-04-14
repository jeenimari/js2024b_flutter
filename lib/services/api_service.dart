// services/api_service.dart
import 'dart:convert';
import "package:http/http.dart" as http;
import '../models/book.dart';
import '../models/review.dart';

class ApiService {
  // API 기본 URL (실제 배포 환경에 맞게 변경 필요)
  static const String baseUrl = 'http://localhost8080'; // 기본 localhost URL (에뮬레이터용)

  // 책 관련 엔드포인트
  static const String bookEndpoint = '/task/book';

  // HTTP 헤더
  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  // 모든 책 목록 조회
  Future<List<Book>> getAllBooks() async {
    final response = await http.get(
      Uri.parse('$baseUrl$bookEndpoint'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books: ${response.statusCode}');
    }
  }

  // 개별 책 조회
  Future<Book> getBookByBno(int bno) async {
    final response = await http.get(
      Uri.parse('$baseUrl$bookEndpoint/view?bno=$bno'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Book.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load book: ${response.statusCode}');
    }
  }

  // 책 추가
  Future<Book> addBook(Book book) async {
    final response = await http.post(
      Uri.parse('$baseUrl$bookEndpoint'),
      headers: headers,
      body: json.encode(book.toJson()),
    );

    if (response.statusCode == 200) {
      return Book.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add book: ${response.statusCode}');
    }
  }

  // 책 수정
  Future<Book> updateBook(Book book) async {
    final response = await http.put(
      Uri.parse('$baseUrl$bookEndpoint'),
      headers: headers,
      body: json.encode(book.toJson()),
    );

    if (response.statusCode == 200) {
      return Book.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update book: ${response.statusCode}');
    }
  }

  // 책 삭제
  Future<bool> deleteBook(int bno) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$bookEndpoint?bno=$bno'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete book: ${response.statusCode}');
    }
  }

  // 리뷰 관련 메소드
  // 책에 대한 모든 리뷰 조회
  Future<List<Review>> getReviewsByBookId(int bno) async {
    final response = await http.get(
      Uri.parse('$baseUrl$bookEndpoint/reply/view?bno=$bno'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Review.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reviews: ${response.statusCode}');
    }
  }

  // 리뷰 추가
  Future<Review> addReview(Review review) async {
    final response = await http.post(
      Uri.parse('$baseUrl$bookEndpoint/reply'),
      headers: headers,
      body: json.encode(review.toJson()),
    );

    if (response.statusCode == 200) {
      return Review.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add review: ${response.statusCode}');
    }
  }

  // 리뷰 삭제
  Future<bool> deleteReview(int rno) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$bookEndpoint/reply?rno=$rno'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete review: ${response.statusCode}');
    }
  }
}