void main(){
  //p.67 레코드 , dart3 부터 추가된 타입
  //튜플 = 값의 묶음
  //레코드에 속한 값들은 꼭 키를 가질 필요없음

  //1.레코드 생성하는 방법
  //방법1.
  var record =('first',a:2,b:true,'last');
  print(record);

  //방법2
  (String,int) record2;
  record2 = ('A String',123);
  print(record2);

  //3.레코드 값 호출
  print(record.$1); // first c출력
  print(record.a); // 2출력 키의 값을 반환을 해줌
  print(record.b); //true 출력
  print(record.$2); // last 출력 key가 존재하지 않은 두번째 value

  //4.JSON 형식
  var json = {'name':'Dash','age':10,'color':'blue'};
}