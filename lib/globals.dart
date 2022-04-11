library gw.globals;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

var currentUser = FirebaseAuth.instance.currentUser;
String friendId = '';
String friendName = '';
