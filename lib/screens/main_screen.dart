import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutterfire_ui/auth.dart';
import 'package:gw/screens/friend_request.dart';
import 'package:gw/globals.dart' as globals;

import 'calendar_screen.dart';
//import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';

//import '../globals.dart' as globals;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime selectedDate = DateTime.now();
  List<String> listOfDays = ["월", "화", "수", "목", "금", "토", "일"];
  final _authentication = FirebaseAuth.instance;

  User? loggedUser;
  String? userName;

  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      User user = await _authentication.currentUser!;
      if (user != null) {
        loggedUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> getUserName() async {
    User user = await _authentication.currentUser!;
    final _userData =
        await FirebaseFirestore.instance.collection('user').doc(user.uid).get();

    while (_userData.data() == null) {
      Center(
        child: CircularProgressIndicator(),
      );
    }

    globals.currentUsername = _userData.data()!['userName'];
    globals.currentUid = _userData.data()!['userUID'];
    return _userData.data()!['userName'];
  }

  Future<String> getUserEmail() async {
    // 여력이 된다면 이거 해결하기..
    // 불러오는 코드 필요 없는데 빼면 실행 순서 꼬여서 오류남 ㅜㅜ

    User user = await _authentication.currentUser!;
    final _userData =
        await FirebaseFirestore.instance.collection('user').doc(user.uid).get();

    return await loggedUser!.email.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0), // AppBar 사이즈 지정
          child: AppBar(
            backgroundColor: Colors.white, // AppBar 색상 지정
            leading: Image.asset(
              'assets/images/logo-black-2.png',
              //fit: BoxFit.contain,
              height: 50,
            ),
            iconTheme: IconThemeData(color: Color.fromARGB(255, 32, 32, 32)),
            elevation: 0.0,

            centerTitle: true,
          ),
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Container(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            AssetImage('assets/images/profile1.jpg'),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 25, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder(
                                future: getUserName(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData == false) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text(
                                      'Error: ${snapshot.error}',
                                    );
                                  } else {
                                    return Text(
                                      snapshot.data.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                }),
                            FutureBuilder(
                                future: getUserEmail(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData == false) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text(
                                      'Error: ${snapshot.error}',
                                    );
                                  } else {
                                    return Text(snapshot.data.toString(),
                                        style: TextStyle(
                                            //color: Colors.white,
                                            ));
                                  }
                                }),
                            // StreamBuilder(
                            //   stream: FirebaseFirestore.instance
                            //       .collection(
                            //           'user/${globals.currentUid}/friends')
                            //       .snapshots(),
                            //   builder: (BuildContext context,
                            //       AsyncSnapshot<dynamic> snapshot) {
                            //     if (snapshot.connectionState ==
                            //         ConnectionState.waiting) {
                            //       return Center(
                            //         child: CircularProgressIndicator(),
                            //       );
                            //     }
                            //     final docs = snapshot.data!.docs;
                            //     return TextButton(
                            //       onPressed: () {
                            //         print('친구 목록 창으로 넘어갈거임~');
                            //       },
                            //       child: Text('친구 ${docs.length.toString()}',
                            //           style: TextStyle(
                            //             color: Colors.black,
                            //             fontSize: 11,
                            //           )),
                            //     );
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
                decoration: BoxDecoration(
                    color: Colors.green[200],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    )),
              ),
              ListTile(
                leading: Icon(
                  Icons.favorite,
                  color: Colors.grey[850],
                ),
                title: Text('친구'),
                onTap: () {
                  print("친구 is clicked");
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FriendRequest();
                  }));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.grey[850],
                ),
                title: Text('설정'),
                onTap: () {
                  print("Setting is clicked");
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.grey[850],
                ),
                title: Text('로그아웃'),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  print("Logout is clicked");
                },
              ),
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Column(
            children: [
              TextButton.icon(
                onPressed: () {
                  //CalendarScreen();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CalendarScreen()));
                },
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black,
                  size: 16,
                ),
                label: Text(
                    selectedDate.year.toString() +
                        "/" +
                        selectedDate.month.toString() +
                        "/" +
                        selectedDate.day.toString() +
                        " (" +
                        listOfDays[selectedDate.weekday - 1] +
                        ")",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    )),
              ),
              SizedBox(
                height: 220,
              ),
              Text("여기에 "),
            ],
          ),
          // child: Text(
          //     selectedDate.year.toString() +
          //         "/" +
          //         selectedDate.month.toString() +
          //         "/" +
          //         selectedDate.day.toString() +
          //         " (" +
          //         listOfDays[selectedDate.weekday - 1] +
          //         ")",
          //     style: TextStyle(
          //       fontSize: 16,
          //     )),

          //child: CalendarScreen(),
        ),
        // child: Text(
        //   'Main Screen',
        //   style: TextStyle(
        //       fontFamily: "rouf", fontSize: 24, fontWeight: FontWeight.bold),
        // ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addCategory(context);
            print("floating buttons is clicked");
          },
          child: Icon(Icons.add),
        ));
  }
}

void addCategory(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("할 일 추가",
            style: TextStyle(
              fontSize: 14,
            )),
        //content: new Text("Alert Dialog body"),
        content: Container(
            child: Column(
          children: [
            Container(
                child: Row(children: [
              for (int i = 0; i < 4; i++)
                Column(
                  children: [
                    IconButton(
                      icon: Image.asset(
                          'assets/images/TaskIcon/${globals.tasks[i]}.png'),
                      iconSize: 20,
                      onPressed: () {},
                    ),
                    Text(
                      globals.tasks[i], //"공부",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
            ])),
            Row(
              children: [],
            )
          ],
        )),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
