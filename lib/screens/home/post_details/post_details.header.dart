import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostDetailsHeader extends StatelessWidget {
  const PostDetailsHeader({
    Key? key,
    required this.firstName,
    required this.lastName,
    this.photo,
    this.onTap,
    this.spacing = 10.0,
  }) : super(key: key);

  final String firstName;
  final String lastName;
  final String? photo;
  final void Function()? onTap;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage:
                photo?.isNotEmpty ?? false ? NetworkImage(photo!) : null,
            radius: 24.0.r,
          ),
          SizedBox(width: spacing),
          Text(
            '$firstName $lastName',
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontSize: 19.0.sp),
          ),
        ],
      ),
    );
  }
}
