import 'package:chat_app/page/sign_in_page.dart';
import 'package:chat_app/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sign Up",
            style:
                primaryTextStyle.copyWith(fontSize: 24, fontWeight: semiBold),
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            "Register and Happy Shoping",
            style: subTitleTextStyle.copyWith(fontWeight: regular),
          )
        ],
      );
    }

    Widget inputFullname() {
      return Container(
        margin: EdgeInsets.only(top: 70),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Full Name",
            style: primaryTextStyle.copyWith(fontWeight: medium, fontSize: 16),
          ),
          SizedBox(
            height: 12,
          ),
          TextField(
            style: primaryTextStyle.copyWith(fontWeight: regular, fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.person,
                color: primaryColor,
              ),
              filled: true,
              fillColor: backgroundColor2,
              hintStyle:
                  subTitleTextStyle.copyWith(fontWeight: regular, fontSize: 14),
              hintText: 'Your Full Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          )
        ]),
      );
    }

    Widget inputUserName() {
      return Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Username",
            style: primaryTextStyle.copyWith(fontWeight: medium, fontSize: 16),
          ),
          SizedBox(
            height: 12,
          ),
          TextField(
            controller: _nameController,
            style: primaryTextStyle.copyWith(fontWeight: regular, fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.brightness_1,
                color: primaryColor,
              ),
              filled: true,
              fillColor: backgroundColor2,
              hintStyle:
                  subTitleTextStyle.copyWith(fontWeight: regular, fontSize: 14),
              hintText: 'Your Username',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          )
        ]),
      );
    }

    Widget inputEmail() {
      return Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Email Address",
            style: primaryTextStyle.copyWith(fontWeight: medium, fontSize: 16),
          ),
          SizedBox(
            height: 12,
          ),
          TextField(
            controller: _emailController,

            style: primaryTextStyle.copyWith(fontWeight: regular, fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.email_rounded,
                color: primaryColor,
              ),
              filled: true,
              fillColor: backgroundColor2,
              hintStyle:
                  subTitleTextStyle.copyWith(fontWeight: regular, fontSize: 14),
              hintText: 'Your Email Address',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          )
        ]),
      );
    }

    Widget inputPassword() {
      return Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Password",
            style: primaryTextStyle.copyWith(fontWeight: medium, fontSize: 16),
          ),
          SizedBox(
            height: 12,
          ),
          TextField(
            controller: _passwordController,
            style: primaryTextStyle.copyWith(fontWeight: regular, fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.email_rounded,
                color: primaryColor,
              ),
              filled: true,
              fillColor: backgroundColor2,
              hintStyle:
                  subTitleTextStyle.copyWith(fontWeight: regular, fontSize: 14),
              hintText: 'Your Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          )
        ]),
      );
    }

    Widget SignUpButton() {
      return Container(
        margin: EdgeInsets.only(top: 30),
        height: 50,
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          onPressed: () {},
          child: Container(
            height: 50,
            width: double.infinity,
            // decoration: BoxDecoration(color: primaryColor),
            child: Center(
              child: GestureDetector(
                onTap: () {
                 register();
                },
                child: Text(
                  "Sign Up",
                  style: primaryTextStyle.copyWith(
                      fontWeight: medium, fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget footer() {
      return Container(
        margin: EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account?",
              style:
                  subTitleTextStyle.copyWith(fontWeight: regular, fontSize: 12),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/sign-in");
              },
              child: Text(
                " Sign In",
                style: secondartTexstyle.copyWith(
                    fontWeight: medium, fontSize: 12, color: primaryColor),
              ),
            )
          ],
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor1,
        body: Container(
          margin: EdgeInsets.all(defaultMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(),
              inputFullname(),
              inputUserName(),
              inputEmail(),
              inputPassword(),
              SignUpButton(),
              Spacer(),
              footer()
            ],
          ),
        ),
      ),
    );
  }

  void register() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({'name': _nameController.text, 'email': _emailController.text});

      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return SignInPage();
        },
      ));
    } catch (e) {
      print(e.toString());
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Registration Failed'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: Text("Ok"),
                )
              ],
            );
          });
    }
  }
}
