import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
                    globals.friendUid = doc.get('userUID');
                    if (globals.friendName == '') print(globals.friendName);
                    print('found ' + globals.friendName);
                    // // Getting data from map
                    // Map<String, dynamic> data = doc.data();
                    // int age = data['age'];
                  }
                  if (globals.friendName == '') print(globals.friendName);
                  //if (globals.friendName == '') ; // 신청받은 내용 출력 _ 그대로 그 페이지에 있기?
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
                  hintText: '친구 이메일 검색',
                  hintStyle: TextStyle(fontSize: 14, color: Palette.textColor1),
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("받은 신청",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('user/${globals.currentUid}/requests')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      return Container(
                          //padding:,
                          child: ListTile(
                        // 친구 프로필사진
                        leading: Icon(
                          Icons.circle,
                          color: Colors.grey[850],
                        ),
                        // 친구 이름

                        title: Text(docs[index]['name']),

                        trailing: TextButton(
                          //style: ButtonStyle(),
                          child: Text("수락"),
                          onPressed: () async {
                            User user =
                                await FirebaseAuth.instance.currentUser!;
                            final _userData = await FirebaseFirestore.instance
                                .collection('user')
                                .doc(docs[index]['uid'])
                                .get();

                            if (_userData.data() == null) {
                              Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            FirebaseFirestore.instance
                                .collection(
                                    'user/${globals.currentUid}/friends')
                                .add({
                              'uid': _userData.data()!['userUID'],
                              'name': _userData.data()!['userName'],
                            });

                            FirebaseFirestore.instance
                                .collection(
                                    'user/${_userData.data()!['userUID']}/friends')
                                .add({
                              'uid': globals.currentUid,
                              'name': globals.currentUsername,
                            });

                            firestore
                                .collection(
                                    'user/${globals.currentUid}/requests')
                                .doc(docs[index].id)
                                .delete();
                          },
                        ),
                      ));
                    },
                  );
                },
              )
            ],
          )),
    );
  }
}
