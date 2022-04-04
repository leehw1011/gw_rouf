import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

import '../globals.dart' as globals;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
        print(loggedUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0), // AppBar 사이즈 지정
        child: AppBar(
          backgroundColor: Colors.white, // AppBar 색상 지정
          //title: Text('Main Screen', style: TextStyle(color: Colors.black)),
          leading: Image.asset(
            'assets/images/logo-black-2.png',
            //fit: BoxFit.contain,
            height: 50,
          ),
          iconTheme: IconThemeData(color: Color.fromARGB(255, 32, 32, 32)),
          elevation: 0.0,

          centerTitle: true,
          // actions: [
          //   IconButton(
          //       icon: Icon(Icons.menu),
          //       color: Colors.black,
          //       onPressed: () {
          //         print('menu button is clicked');
          //       }),
          //   // 로그아웃 버튼. 일단 두고 나중에 옮기자
          //   // IconButton(
          //   //   icon: Icon(
          //   //     Icons.exit_to_app_sharp,
          //   //     color: Colors.black,
          //   //   ),
          //   //   onPressed: () {
          //   //     FirebaseAuth.instance.signOut();
          //   //   },
          //   // )
          // ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // DrawerHeader(
            //   child: Container(
            //       child: Row(
            //     children: [
            //       CircleAvatar(
            //         backgroundImage: AssetImage('assets/images/profile1.jpg'),

            //       ),
            //       Column(
            //         children: [
            //           Text('noweeh'),
            //           Text('leehw1011@gmail.com'),
            //         ],
            //       )
            //     ],
            //   )),
            //   decoration: BoxDecoration(
            //       color: Colors.green[200],
            //       borderRadius: BorderRadius.only(
            //         bottomLeft: Radius.circular(20.0),
            //         bottomRight: Radius.circular(20.0),
            //       )),
            // ),
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/profile1.jpg'),
              ),
              accountName: Text('noweeh'),
              accountEmail: Text('leehw1011@gmail.com'),
              onDetailsPressed: () {
                print('arrow is clicked');
              },
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
              onTap: () async {
                final f = FirebaseFirestore.instance;
                await f
                    .collection('PROFILE')
                    .doc(globals.currentUser?.uid)
                    .set({'username': 'abcd'});
                print("친구 is clicked");
              },
              trailing: Icon(Icons.add),
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
              trailing: Icon(Icons.add),
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.grey[850],
              ),
              title: Text('로그아웃'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                //_authentication.signOut();
                // Navigator.pop(context);
                // Navigator.pop(context);
                print("Logout is clicked");
              },
              trailing: Icon(Icons.add),
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Main Screen',
          style: TextStyle(
              fontFamily: "rouf", fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
