import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';

import 'avatar.dart';

enum BubbleType {
  top,
  middle,
  bottom,
  alone,
}

enum Direction {
  left,
  right,
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.direction,
    required this.message,
    required this.type,
    this.photoUrl,
  }) : super(key: key);
  final Direction direction;
  final String message;
  final String? photoUrl;
  final BubbleType type;

  @override
  Widget build(BuildContext context) {
    final isOnLeft = direction == Direction.left;
    return Row(
      mainAxisAlignment:
          isOnLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(width: isOnLeft ? 4 : 0),
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          margin: EdgeInsets.symmetric(vertical: 2),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: _borderRadius(direction, type),
            color: isOnLeft ? backgroundColor4 : bubbleChatColor,
          ),
          child: Text(
            message,
            style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: regular),
          ),
        ),
      ],
    );
  }

  Widget _buildLeading(BubbleType type) {
    if (type == BubbleType.alone || type == BubbleType.bottom) {
      return const Avatar(
        radius: 12,
      );
    }
    return const SizedBox(width: 24);
  }

  BorderRadius _borderRadius(Direction dir, BubbleType type) {
    const radius1 = Radius.circular(15);
    const radius2 = Radius.circular(5);
    switch (type) {
      case BubbleType.top:
        return dir == Direction.left
            ? const BorderRadius.only(
                topLeft: radius1,
                topRight: radius1,
                bottomLeft: radius2,
                bottomRight: radius1,
              )
            : const BorderRadius.only(
                topLeft: radius1,
                topRight: radius1,
                bottomLeft: radius1,
                bottomRight: radius2,
              );

      case BubbleType.middle:
        return dir == Direction.left
            ? const BorderRadius.only(
                topLeft: radius2,
                topRight: radius1,
                bottomLeft: radius2,
                bottomRight: radius1,
              )
            : const BorderRadius.only(
                topLeft: radius1,
                topRight: radius2,
                bottomLeft: radius1,
                bottomRight: radius2,
              );
      case BubbleType.bottom:
        return dir == Direction.left
            ? const BorderRadius.only(
                topLeft: radius2,
                topRight: radius1,
                bottomLeft: radius1,
                bottomRight: radius1,
              )
            : const BorderRadius.only(
                topLeft: radius1,
                topRight: radius2,
                bottomLeft: radius1,
                bottomRight: radius1,
              );
      case BubbleType.alone:
        return BorderRadius.circular(15);
    }
  }
}
