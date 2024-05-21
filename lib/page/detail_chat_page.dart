// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app/data/datasource/firebase_datasource.dart';
import 'package:chat_app/data/models/channel_model.dart';
import 'package:chat_app/data/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/data/models/user_model.dart';

import '../theme.dart';
import '../widget/chat_bubble.dart';

class DetailChatPage extends StatefulWidget {
  final UserModel partnerChat;
  DetailChatPage({
    Key? key,
    required this.partnerChat,
  }) : super(key: key);

  @override
  State<DetailChatPage> createState() => _DetailChatPageState();
}

class _DetailChatPageState extends State<DetailChatPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor3,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: backgroundColor1,
          leading: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
          title: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/afria.jpg"),
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.partnerChat.userName,
                    style: primaryTextStyle.copyWith(
                        fontWeight: semiBold, fontSize: 14),
                  ),
                  Text(
                    "Online",
                    style: subTitleTextStyle.copyWith(
                        fontWeight: light, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: defaultMargin, vertical: 20),
                child: StreamBuilder(
                    stream: FirebaseDataSource.instance.messageStream(
                        channelId(widget.partnerChat.id, currentUser!.uid)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final List<Message> messages = snapshot.data ?? [];
                      if (messages.isEmpty) {
                        return Center(
                          child: Text(
                            "No Messaage Found",
                            style: primaryTextStyle,
                          ),
                        );
                      }

                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        reverse: true,
                        padding: const EdgeInsets.all(10),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return ChatBubble(
                            direction: message.senderId == currentUser!.uid
                                ? Direction.right
                                : Direction.left,
                            message: message.textMessage,
                            photoUrl: null,
                            type: BubbleType.alone,
                          );
                        },
                      );
                    })),
          ),
          Row(
            children: [
              SizedBox(
                width: defaultMargin,
              ),
              Expanded(
                child: SizedBox(
                  height: 45,
                  child: TextField(
                    style: primaryTextStyle.copyWith(fontSize: 14),
                    controller: _messageController,
                    decoration: InputDecoration(
                      fillColor: backgroundColor4,
                      filled: true,
                      hintText: 'Type a message...',
                      hintStyle: subTitleTextStyle.copyWith(fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Set border radius here
                        borderSide: BorderSide
                            .none, // Optionally, you can remove the side border as well
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12)),
                child: IconButton(
                    onPressed: () {
                      return sendMessage();
                    },
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                    )),
              ),
              SizedBox(
                width: defaultMargin,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  void sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      return;
    }

    final channel = Channel(
      id: channelId(currentUser!.uid, widget.partnerChat.id),
      memberId: [currentUser!.uid, widget.partnerChat.id],
      lastMessage: _messageController.text.trim(),
      lastTime: Timestamp.now(),
      unread: {currentUser!.uid: false, widget.partnerChat.id: true},
      members: [currentUser!.uid, widget.partnerChat.id],
      sendBy: currentUser!.uid,
    );

    await FirebaseDataSource.instance
        .updateChannel(channel.id, channel.toMap());

    var docRef = FirebaseFirestore.instance.collection('messages').doc();
    var message = Message(
      id: docRef.id,
      textMessage: _messageController.text.trim(),
      senderId: currentUser!.uid,
      sendAt: Timestamp.now(),
      channelId: channel.id,
    );

    FirebaseDataSource.instance.addMessage(message);
    var channelUpdateData = {
      'lastMessageg': message.textMessage,
      'sendBy': currentUser!.uid,
      'lastTime': message.sendAt,
      'unread': {currentUser!.uid: false, widget.partnerChat.id: true}
    };
    FirebaseDataSource.instance.updateChannel(channel!.id, channelUpdateData);
    _messageController.clear();
  }
}
