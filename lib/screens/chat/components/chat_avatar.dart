import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/chat_model.dart';
import '../../../utils/constants/themes.dart';

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
        height: radius * 2,
        width: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black.withOpacity(0.3)),
          color: Colors.transparent,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0.r),
          child: Image.network(
            displayPhoto ?? '',
            fit: BoxFit.cover,
            errorBuilder: (_, e, stack) {
              return Center(
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: Text(
                    displayName![0],
                    style: Theme.of(context)
                        .primaryTextTheme
                        .subtitle1
                        ?.copyWith(color: kTealColor),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
