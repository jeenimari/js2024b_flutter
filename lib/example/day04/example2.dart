//example2. dart : text 입력 폼

//1.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:js2024b_app/main.dart';

void main(){
  runApp(MyApp());
}
//2. 상태가 있는 앱 화면 선언
class MyApp extends StatefulWidget{
  //상태를 사용할 위젯명 설정
  MyAppState createState() => MyAppState();

}
//2-2 앱 화면
class MyAppState extends State<MyApp>{
  //1. 입력 컨트롤러 이용한 입력값들을 제어함 .
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  final TextEditingController controller3 = TextEditingController();

  void onEvent(){
    print(controller1.text);
    print(controller2.text);
    print(controller3.text);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Scaffold(
        appBar: AppBar(title: Text("입력화면"),),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 30,),  //빈공간 위젯을 이용하여 높이 설정 ( 여백 역할)

              Text("아래 내용들을 입력해주세요."), // 텍스트 출력 위젯
              SizedBox(height: 30,),  //빈공간 위젯을 이용하여 높이 설정 ( 여백 역할)

              TextField(controller: controller1,), // 텍스트 입력 위젯
              SizedBox(height: 30,),

              TextField(maxLines: 5,
                decoration: InputDecoration(labelText : "가이드텍스트"),
                maxLength: 30,controller: controller2,),
              SizedBox(height: 30,),

              TextField(maxLines: 5,controller: controller3,), //최대 입력 출수 제한 , 입력에따라 자동 확장된다.
              SizedBox(height: 30,),

              TextButton(onPressed: onEvent, child: Text("클릭시 입력값을 출력합니다."),
              )
            ],
          ) ,
        ),
      ) ,
    );
  }
}