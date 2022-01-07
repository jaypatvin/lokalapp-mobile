import 'package:flutter/material.dart';

import '../../../models/chat_model.dart';

class ChatMember {
  final String? id;
  final String? displayName;
  final String? displayPhoto;
  final ChatType? type;

  const ChatMember({this.id, this.displayName, this.displayPhoto, this.type});
}

class ChatAvatar extends StatelessWidget {
  final String? displayName;
  final String? displayPhoto;
  final void Function()? onTap;
  final double radius;
  const ChatAvatar({
    required this.displayName,
    this.displayPhoto = '',
    this.onTap,
    this.radius = 25.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[600]!),
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: Colors.transparent,
          child: displayPhoto != null && displayPhoto!.isNotEmpty
              ? Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(displayPhoto!),
                    ),
                  ),
                )
              : Text(displayName![0]),
        ),
      ),
    );
  }
}
