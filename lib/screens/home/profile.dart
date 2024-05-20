import 'package:flutter/material.dart';
import 'package:queyndz/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  User? user;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>?;
        });
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayName = userData?['name'] ?? 'Không xác định';
    String role = userData?['isAdmin'] == 1 ? 'Quản trị' : 'Người dùng';
    String gender = userData?['gender'] == 1 ? 'Nam' : 'Nữ';

    // Replace AssetImage with an Icon for the user placeholder
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang Cá Nhân'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 40),
            CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.person,
                size: 50,
              ),
              backgroundColor: Colors.transparent,
            ),
            SizedBox(height: 20),
            Text(
              'Xin chào, $displayName',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Add Text widgets for gender and role
            Text(
              'Giới tính: $gender',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              'Vai trò: $role',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(30.0),
              color: Theme.of(context).primaryColor,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                onPressed: () async {
                  await _auth.signOut();
                },
                child: Text(
                  "Đăng xuất",
                  style: TextStyle(color: Theme.of(context).primaryColorLight),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
