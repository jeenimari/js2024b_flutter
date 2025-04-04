
int add(int a,int b){
  return a+b;
}

void main(){
  int number = 31;
  if(number % 2 ==1){
    print("홀수!");
  }else{
    print("짝수!");
  }




  String light = "red";
  if(light =="green"){
    print("초록불");
  }else if(light=="yellow"){
    print("노란불");
  }else if(light=="red"){
    print("빨간불!");
  }else(
  print("잘못된 신호입니다.")
  );


  String light1 = "purple";
  if(light1 == "green"){
    print("초록불!");
  }else if(light1 == "yellow"){
    print("노란불");
  }else if(light1 == "red"){
    print("빨간불!");
  }


  //반복문
  for(int i =0; i<100; i++){
    print(i+1);
  }

  List<String>subjects = ["자료구조","이산수학","알고리즘","플러터"];
  for(String subject in subjects){
    print(subjects);
  }
  //
  // int i = 0;
  // while(i<100){
  //   print(i+1);
  //   i= i+1;
  // }
  //


  // int i1=0;
  // while(true){
  //   print(i1+1);
  //   i=i+1;
  // }

  int i2 = 0;
  while(true){
    print(i2+1);
    i2=i2+1;
    if(i2==100){
      break;
    }
  } // while end

  for(int i=0; i<100; i++){
    if(i%2==0){
      continue;
    }
    print(i+1);
  }


  //함수

  int number1 = add(1,2);
  print(number1);


//스위치
switch(number){
  case 1:
    print('one');
}

const a = 'a';
const b = 'b';
const obj = [ a, b];
switch(obj){
  case[a,b]:
    print('$a,$b');
}

//
// switch (obj){
//   case 1: print('one'); //정수가 1인경우
//
//   case >= first && <= last: print('in range');
//
//   case (var a,var b):print('a=$a,b=$b');
//   default:
// }


}// m end



//