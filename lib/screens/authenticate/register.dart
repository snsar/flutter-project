import 'package:queyndz/models/loginuser.dart';
import 'package:queyndz/models/registeruser.dart';
import 'package:queyndz/services/auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function? toggleView;
  Register({this.toggleView});

  @override
  State<StatefulWidget> createState() {
    return _Register();
  }
}

class _Register extends State<Register> {
  final AuthService _auth = AuthService();

  bool _obscureText = true;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  int _gender = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
      controller: _name,
      autofocus: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Trường này là bắt buộc';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Họ tên",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final genderField = DropdownButtonFormField<int>(
      value: _gender,
      items: [
        DropdownMenuItem<int>(
          value: 0,
          child: Text("Nữ"),
        ),
        DropdownMenuItem<int>(
          value: 1,
          child: Text("Nam"),
        ),
      ],
      onChanged: (int? value) {
        setState(() {
          _gender = value!;
        });
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Giới tính",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final emailField = TextFormField(
        controller: _email,
        autofocus: false,
        validator: (value) {
          if (value != null) {
            if (value.contains('@') && value.endsWith('.com')) {
              return null;
            }
            return 'Enter a Valid Email Address';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Email",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final passwordField = TextFormField(
        obscureText: _obscureText,
        controller: _password,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Trường này là bắt buộc';
          }
          if (value.trim().length < 8) {
            return 'Mật khẩu phải lớn hơn 8 kí tự';
          }
          // Return null if the entered password is valid
          return null;
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Password",
            suffixIcon: IconButton(
              icon:
                  Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final txtbutton = TextButton(
        onPressed: () {
          widget.toggleView!();
        },
        child: const Text('Đến trang login'));

    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            dynamic result = await _auth.registerEmailPassword(RegisterUser(
              email: _email.text,
              password: _password.text,
              name: _name.text,
              gender: _gender,
            ));
            if (result.uid == null) {
              //null means unsuccessfull authentication
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(result.code),
                    );
                  });
            }
          }
        },
        child: Text(
          "Đăng ký",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Đăng ký'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        // Bao bọc phần tử chính trong SingleChildScrollView
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 25.0),
                    nameField,
                    const SizedBox(height: 25.0),
                    genderField,
                    const SizedBox(height: 25.0),
                    emailField,
                    const SizedBox(height: 25.0),
                    passwordField,
                    const SizedBox(height: 25.0),
                    txtbutton,
                    const SizedBox(height: 35.0),
                    registerButton,
                    const SizedBox(height: 15.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
