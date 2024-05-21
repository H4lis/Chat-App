import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Channel {
  final String id;
  final List<String> memberId;
  final String lastMessage;
  final Timestamp lastTime;  // Change to Timestamp
  final Map<String, bool> unread;
  final List<String> members;
  final String sendBy;

  Channel({
    required this.id,
    required this.memberId,
    required this.lastMessage,
    required this.lastTime,
    required this.unread,
    required this.members,
    required this.sendBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'memberId': memberId,
      'lastMessage': lastMessage,
      'lastTime': lastTime,  // Store as Timestamp
      'unread': unread,
      'members': members,
      'sendBy': sendBy,
    };
  }

  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
      id: map['id'] as String,
      memberId: List<String>.from(map['memberId'] as List<dynamic>),
      lastMessage: map['lastMessage'] as String,
      lastTime: map['lastTime'] as Timestamp,  // Read as Timestamp
      unread: Map<String, bool>.from(map['unread'] as Map<String, dynamic>),
      members: List<String>.from(map['members'] as List<dynamic>),
      sendBy: map['sendBy'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Channel.fromJson(String source) =>
      Channel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Channel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return Channel(
      id: snapshot.id,
      memberId: List<String>.from(snapshot['memberId'] as List<dynamic>),
      lastMessage: snapshot['lastMessage'] as String,
      lastTime: snapshot['lastTime'] as Timestamp,  // Read as Timestamp
      unread: Map<String, bool>.from(snapshot['unread'] as Map<String, dynamic>),
      members: List<String>.from(snapshot['members'] as List<dynamic>),
      sendBy: snapshot['sendBy'] as String,
    );
  }
}
