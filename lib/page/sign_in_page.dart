import 'package:chat_app/page/chat_page.dart';
import 'package:chat_app/theme.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Login",
            style:
                primaryTextStyle.copyWith(fontSize: 24, fontWeight: semiBold),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            "Sign In to Countinue",
            style: subTitleTextStyle.copyWith(fontWeight: regular),
          )
        ],
      );
    }

    Widget inputEmail() {
      return Container(
        margin: const EdgeInsets.only(top: 70),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Email Address",
            style: primaryTextStyle.copyWith(fontWeight: medium, fontSize: 16),
          ),
          const SizedBox(
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
        margin: const EdgeInsets.only(top: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Password",
            style: primaryTextStyle.copyWith(fontWeight: medium, fontSize: 16),
          ),
          const SizedBox(
            height: 12,
          ),
          TextField(
            controller: _passwordController,
            style: primaryTextStyle.copyWith(fontWeight: regular, fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock,
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

    Widget signInButton() {
      return Container(
        margin: const EdgeInsets.only(top: 30),
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
                  login();
                },
                child: Text(
                  "Sign In",
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
        margin: const EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account",
              style:
                  subTitleTextStyle.copyWith(fontWeight: regular, fontSize: 12),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/sign-up');
              },
              child: Text(
                " Sign up",
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
              inputEmail(),
              inputPassword(),
              signInButton(),
              const Spacer(),
              footer()
            ],
          ),
        ),
      ),
    );
  }

  void login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ChatPage();
          },
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Registration Failed'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: const Text("Ok"),
                )
              ],
            );
          });
    }
  }
}
