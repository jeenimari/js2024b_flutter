class ReplyDto {
  int? rno;
  String rcontent;
  String rpw;
  int bno;

  ReplyDto({
    this.rno,
    required this.rcontent,
    required this.rpw,
    required this.bno,
  });

  factory ReplyDto.fromJson(Map<String, dynamic> json) {
    return ReplyDto(
      rno: json['rno'],
      rcontent: json['rcontent'],
      rpw: json['rpw'],
      bno: json['bno'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (rno != null) 'rno': rno,
      'rcontent': rcontent,
      'rpw': rpw,
      'bno': bno,
    };
  }
}