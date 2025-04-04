void main(){
  int a = 2;
  int b = 1;
  print(a+b); // 3

  String firstName = 'jeongjoo';
  String lastName = 'Lee';
  String FullName = lastName + ' ' + firstName;

  //뺄셈
  int a1 = 2;
  int b1 = 1;
  print(a1- b1);

  //- 표현식
  int a2 = 2;
  print(-a2);


  //* 곱셈
  int a3 = 6;
  int b3 = 3;
  print(a3*b3);

  // 나눗셈
  int a4 = 10;
  int b4 = 4;

  print(a4/b4);

  // 몫 결과가 정수인 나눗셈
  int a5 =10;
  int b5 = 4;
  print(a5~/b5); //2.5

  //나눗셈의 나머지
  int a6 = 10;
  int b6 = 4;
  print(a6%b6);

  // ++변수

  int c = 0;
  print(++c);
  print(c);

  //변수 ++ 후위증감
  print(c++);
  print(c);

  // --변수
  int c1=1;
  print(--c1);//0
  print(c1);

  //변수--
  int c2= 1;
  print(c1--);
  print(c1);

  //== 두값이 같은지 비교 두값이 같은경우 true

  int c3= 2;
  int d = 1;
  print(c3==d); // false


  //!= 두값이 다른지 비교
  print(c3!=d); //true

  //> 한값이 다른 값보다 큰지 비교
  int a10 = 2;
  int b10 = 1;
  print(a10>b10);// true
  print(a10<b10); // false


  // 한 값이 다른 값보다 크거나 같은 지 비교 왼쪽에 위치한 값이 크거나 같은경우 true >=
  int a11 = 2;
  int b11 = 1;

  print(a11>=b11); // true;
  print(a11<=b11); // 왼쪽외 위치한값이 작거나 같은경우 true

  // =
  int a12 = 1;
  print(a12); // 1
  a12= 2; //재할당

  print(a12); // 2

  // += -+ *=  변수에 사칙연산 이후 재할당

  a *= 3;
  //a = a*3

  //!표현식
  int f = 2;
  int g = 1;
  bool result = f > g;
  print(!result); // false

  //|| : 여러개의 표현식을 Or 조건으로 이어줌 여러개의 표현식 중 하나의 표현식만 true여도 true

  int z = 3;
  int x = 2;
  int v = 1;
  print(z>3);
  print(x<v);
  print(z>x || x>v);

  //&& 여러개의 표현식을 and 조건으로 이어줌 둘다 참이여야만 true

  print(z>x && x<v);



}