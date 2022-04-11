import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gw/screens/printSearchedFriend.dart';
import 'package:gw/globals.dart' as globals;

import '../config/palette.dart';

class FriendRequest extends StatefulWidget {
  const FriendRequest({Key? key}) : super(key: key);

  @override
  State<FriendRequest> createState() => _FriendRequestState();
}

class _FriendRequestState extends State<FriendRequest> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    //String friendName = '';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0), // AppBar 사이즈 지정
        child: AppBar(
          backgroundColor: Colors.white, // AppBar 색상 지정
          title: Text('친구 신청', style: TextStyle(color: Colors.black)),

          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_rounded),
          ),

          iconTheme: IconThemeData(color: Color.fromARGB(255, 32, 32, 32)),
          elevation: 0.0,

          centerTitle: true,
        ),
      ),
      body: Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                //key: ValueKey(2),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid address.';
                  }
                  return null;
                },
                onFieldSubmitted: (text) async {
                  final querySnapshot = await FirebaseFirestore.instance
                      .collection('user')
                      .where('email', isEqualTo: text)
                      .get();
                  //if (globals.friendName == '') print(globals.friendName);
                  for (var doc in querySnapshot.docs) {
                    // Getting data directly
                    //String name = doc.get('userName');
                    globals.friendName = doc.get('userName');
                    if (globals.friendName == '') print(globals.friendName);
                    print('found ' + globals.friendName);
                    print(globals.friendId);
                    // // Getting data from map
                    // Map<String, dynamic> data = doc.data();
                    // int age = data['age'];
                  }
                  if (globals.friendName == '') print(globals.friendName);
                  if (globals.friendName == '') ; // 신청받은 내용 출력 _ 그대로 그 페이지에 있기?
                  if (globals.friendName != '') {
                    // 검색 내용 출력
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => printSearchedFriend()));
                  }
                },
                // onChanged: (value) {
                //   userEmail = value;
                // },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Palette.iconColor,
                  ),
                  // enabledBorder: OutlineInputBorder(
                  //   borderSide:
                  //       BorderSide(color: Palette.textColor1),
                  //   borderRadius: BorderRadius.all(
                  //     Radius.circular(35.0),
                  //   ),
                  // ),
                  // focusedBorder: OutlineInputBorder(
                  //   borderSide:
                  //       BorderSide(color: Palette.textColor1),
                  //   borderRadius: BorderRadius.all(
                  //     Radius.circular(35.0),
                  //   ),
                  // ),
                  hintText: '친구 이메일 검색',
                  hintStyle: TextStyle(fontSize: 14, color: Palette.textColor1),
                  contentPadding: EdgeInsets.all(10),
                ),
              ),

              SizedBox(
                height: 8,
              ),
              // 친구 검색 결과 or 받은 신청 목록
              // if (globals.friendName == '')
              //   Container(
              //       child: Column(
              //     children: [
              //       SizedBox(
              //         height: 50,
              //       ),
              //       ListTile(
              //         title: Text("친구 검색 전"),
              //       )
              //     ],
              //   )),

              // if (globals.friendName != '')
              //   ListTile(
              //     leading: Icon(
              //       Icons.circle,
              //       color: Colors.grey[850],
              //     ),
              //     // 친구 이메일
              //     title: Text("친구 검색 후" + globals.friendName),
              //     // onTap: () {
              //     //   print("친구 is clicked");
              //     //   Navigator.push(context, MaterialPageRoute(builder: (context) {
              //     //     return FriendRequest();
              //     //   }));
              //     // },
              //     // '수락' 버튼으로 바꾸기
              //     trailing: IconButton(
              //         onPressed: () {
              //           print("친구 추가");
              //           // 목록에서 해당 data 사라지게
              //         },
              //         icon: Icon(Icons.add)),
              //   ),

              ListTile(
                // 친구 프로필사진
                leading: Icon(
                  Icons.circle,
                  color: Colors.grey[850],
                ),
                // 친구 이메일
                title: Text("받은 신청 목록이 뜹니다"),
                // onTap: () {
                //   print("친구 is clicked");
                //   Navigator.push(context, MaterialPageRoute(builder: (context) {
                //     return FriendRequest();
                //   }));
                // },
                // '수락' 버튼으로 바꾸기
                trailing: IconButton(
                    onPressed: () {
                      print("친구 추가");
                      // 목록에서 해당 data 사라지게
                    },
                    icon: Icon(Icons.add)),
              ),
            ],
          )),
    );
  }
}