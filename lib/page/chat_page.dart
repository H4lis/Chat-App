import 'package:chat_app/data/datasource/firebase_datasource.dart';
import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/page/detail_chat_page.dart';
import 'package:chat_app/page/sign_in_page.dart';
import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  final currenUser = FirebaseAuth.instance.currentUser;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor3,
      appBar: AppBar(
        backgroundColor: backgroundColor1,
        title: Text(
          "Message Support",
          style: primaryTextStyle.copyWith(fontWeight: medium, fontSize: 18),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return SignInPage();
                  },
                ));
              },
              icon: Icon(Icons.logout),
              color: Colors.white,
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        child: StreamBuilder<List<UserModel>>(
            stream: FirebaseDataSource.instance.allUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final List<UserModel> users = (snapshot.data ?? [])
                  .where((element) => element.id != currenUser!.uid)
                  .toList();
              if (users.isEmpty) {
                return Center(
                  child: Text(
                    'No User found',
                    style: primaryTextStyle,
                  ),
                );
              }
              return ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                        color: backgroundColor2,
                        thickness: 1,
                      ),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return DetailChatPage(partnerChat: users[index]);
                          },
                        ));
                      },
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 33,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 54,
                                height: 54,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage("assets/afria.jpg"),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      users[index].userName,
                                      style: primaryTextStyle.copyWith(
                                          fontSize: 15),
                                    ),
                                    Text(
                                      "Good night, This item is on on on on on",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: subTitleTextStyle.copyWith(
                                          fontSize: 14, fontWeight: light),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Text(
                                "Now",
                                style: subTitleTextStyle.copyWith(fontSize: 10),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
