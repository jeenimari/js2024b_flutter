// models/review.dart
class Review {
  final int? rno; // 리뷰 번호 (null일 경우 새 리뷰)
  final String rcontent; // 리뷰 내용
  final String rpw; // 리뷰 비밀번호
  final int bno; // 책 번호 (외래키)

  Review({
    this.rno,
    required this.rcontent,
    required this.rpw,
    required this.bno,
  });

  // JSON에서 Review 객체로 변환
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rno: json['rno'],
      rcontent: json['rcontent'],
      rpw: json['rpw'],
      bno: json['bno'],
    );
  }

  // Review 객체에서 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'rno': rno,
      'rcontent': rcontent,
      'rpw': rpw,
      'bno': bno,
    };
  }
}