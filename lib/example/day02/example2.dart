//Dart 언어는 단일 스레드 기반


//1. DIO 객체 생성 , java : new 클래스명() vs dart : 클래스명()
import 'package:dio/dio.dart';

final dio = Dio();



void main(){ //main 함수가 스레드를 갖고 코드 시작점

  print('dart start');
  //(3)해당함수 호출
  getHttp();
  postHttp();
}

//3.비동기 통신
//dio.HTTP메소드명("URL")vs axios.HTTP 메소드명("URL")
void getHttp() async{
  //(1) dio 통신 이용한 자바와 통신
 final response = await dio.get("http://localhost:8080/day03/task/course");

  //(2)응답 확인
  print(response.data);
}// fend

//4. dio.get("URL,data:{body})
void postHttp() async{
 try {
   //(1)보내고자 하는 내용물 JSON(dart map)

   final senddata = {"과정명": "수학"};
   final response = await dio.post(
       "http://localhost:8080/day03/task/course", data: senddata);

   //(3)응답확인
   print(response.data);
 }catch(e){print(e);}
}