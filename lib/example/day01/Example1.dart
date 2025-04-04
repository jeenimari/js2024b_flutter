//dart 언어
//1.주석
//한줄주석
/*여러줄 주석*/


//2.Dart 프로그램 진입점 함수 = main

//void main(){}



//3.콘솔 출력함수 = print();



//4. ctrl+ shift +f10

void main(){
  print("hello,world!");


  //1.문자열 타입
  String name= '유재석'; print(name);
  String name2 = "유재석"; print(name2);
  String name3 = "이름 : $name" ; print(name3);

  //2.숫자 타입 num : int/double 상위타입

  int year =2023; print(year); //정수
  double pi =3.14159; print(pi); //실수
  num year2 = 2023;  print(year2);
  num pi2 = 3.14159; print(pi2);

  //3. 불타입 bool

  bool darkmode = false; print(darkmode);

  //p.65 컬렉션 List<타입> 중복허용 vs Set<타입> 중복불가능 vs Map<타입 ,타입> key(중복x)-value(중복o)
  List<String>fruits= ['사과','바나나','딸기','포도'];
  print(fruits); print(fruits[3]); print(fruits.length);

  Set<int>odds = {1,3,5,7,9,9}; print(odds); //중복 걸러짐 인덱스를 부여하지않아서 중복을 허용하지않음

  Map<String,int>regionMap = {"서울":0 ,"인천":1, "대전":2,"부산":3,"대구":4,"광주":5,"울산":6,"세종":7,"세종":0};
  print(regionMap);
  print(regionMap['서울']); // 0 출력 값이 나옴



  //p.65 기타
   //1.Object : 모든 자료들을 Object(최상위타입)저장 , 타입변환 필요
  Object a= 1;
  Object b =3.14;
  Object c = "강호동";

  //2. dynamic : 동적 타입으로 대입이 되는 순간 타입 결정 , 타입변환 필요 없다.

  dynamic a1 = 1;
  dynamic a2 = 3.14;
  dynamic a3= "강호동";
  dynamic a4 = ['사과'];
  dynamic a5 = {1,3,4,};
  dynamic a6 = { "name":"유재석","age": 40 };

  //3.타입? : null 이 될 수 있는 타입 vs java Optional
  String? nickname = null;
  //String nickname = null; // 다트 3 부터 타입뒤에 '?' 붙여서 null 안정성 보장함

  //var : 처음에 할당된 값의 타입이 결정, dynamic 선언된 변수는 모든 타입들이 들어올 수 있다.

}