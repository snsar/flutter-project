import 'package:flutter/material.dart';
import 'package:queyndz/screens/home/product_screen.dart';
import 'package:queyndz/screens/home/admin_screen.dart';
import 'package:queyndz/screens/home/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  bool _isAdmin = false;

  final List<String> _appBarTitles = [
    'Trang chủ',
    'Trang cá nhân',
  ];

  List<Widget> _widgetOptions = <Widget>[
    ProductScreen(),
    Profile(),
  ];

  @override
  void initState() {
    super.initState();
    _checkIfUserIsAdmin();
  }

  Future<void> _checkIfUserIsAdmin() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final Map<String, dynamic>? userData =
          userDoc.data() as Map<String, dynamic>?;
      final isAdmin = userData?['isAdmin'] == 1;
      if (isAdmin) {
        setState(() {
          _isAdmin = true;
          _appBarTitles.insert(1, 'Quản trị');
          _widgetOptions.insert(1, AdminScreen());
        });
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          if (_isAdmin)
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Quản trị',
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Trang cá nhân',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
