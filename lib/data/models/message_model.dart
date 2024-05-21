import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String textMessage;
  final String senderId;
  final Timestamp sendAt;
  final String channelId;

  Message({
    required this.id,
    required this.textMessage,
    required this.senderId,
    required this.sendAt,
    required this.channelId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'textMessage': textMessage,
      'senderId': senderId,
      'sendAt': sendAt,
      'channelId': channelId,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as String,
      textMessage: map['textMessage'] as String,
      senderId: map['senderId'] as String,
      sendAt: map['sendAt'] as Timestamp,
      channelId: map['channelId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Message.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return Message(
      id: snapshot.id,
      textMessage: snapshot['textMessage'] ?? '',
      senderId: snapshot['senderId'] ?? '',
      sendAt: snapshot['sendAt'],
      channelId: snapshot['channelId'] ?? '',
    );
  }
}
