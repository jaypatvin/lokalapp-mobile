import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../models/shop.dart';
import '../../providers/auth.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../services/database.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import 'components/chat_avatar.dart';
import 'components/chat_stream.dart';

class Chat extends StatefulWidget {
  static const routeName = '/chat';
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with TickerProviderStateMixin {
  TabController? _tabController;

  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  late Stream<QuerySnapshot<Map<String, dynamic>>> _userChatStream;
  Stream<QuerySnapshot<Map<String, dynamic>>>? _shopChatStream;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _tabController!.addListener(_tabSelectionHandler);
    _colorAnimation = ColorTween(
      begin: kTealColor,
      end: kPurpleColor,
    ).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    final user = context.read<Auth>().user!;
    final shops = context.read<Shops>().findByUser(user.id);
    _userChatStream = Database.instance.getUserChats(user.id);
    if (shops.isNotEmpty) {
      _shopChatStream = Database.instance.getUserChats(shops.first.id);
    }
  }

  void _tabSelectionHandler() {
    setState(() {
      switch (_tabController?.index) {
        case 0:
          _animationController.reverse();
          break;
        case 1:
          _animationController.forward();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _ChatAppBar(
        height: 120.0.h,
        backgroundColor: _colorAnimation.value,
        bottom: _ChatAppBarBottom(
          tabController: _tabController,
        ),
      ),
      body: Consumer2<Shops, Products>(
        builder: (ctx, shops, products, _) {
          if (shops.isLoading || products.isLoading) {
            return SizedBox.expand(
              child: Lottie.asset(kAnimationLoading, fit: BoxFit.cover),
            );
          }

          final user = context.read<Auth>().user!;
          final _shops = shops.findByUser(user.id);

          if (_shopChatStream == null && _shops.isNotEmpty) {
            _shopChatStream = Database.instance.getUserChats(_shops.first.id);
          }

          return TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              ChatStream(chatStream: _userChatStream),
              ChatStream(chatStream: _shopChatStream),
            ],
          );
        },
      ),
    );
  }
}

// needed for the custom height of the appbar
class _ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;
  const _ChatAppBar({
    this.height = 50.0,
    this.backgroundColor,
    this.bottom,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Chats',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Goldplay',
          fontWeight: FontWeight.w600,
          fontSize: 22.0.sp,
        ),
      ),
      centerTitle: true,
      backgroundColor: backgroundColor,
      bottom: bottom,
    );
  }
}

// This is the tab controller for the user  & shop chats
class _ChatAppBarBottom extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final TabController? tabController;
  const _ChatAppBarBottom({this.height = 50.0, this.tabController});

  @override
  Size get preferredSize => Size.fromHeight(height);

  Widget _tabChild({
    String? imgUrl,
    required String name,
    required int index,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.w),
      child: Row(
        children: [
          ChatAvatar(
            displayName: name,
            displayPhoto: imgUrl,
            radius: index == tabController?.index ? 22.0.r : 13.0.r,
          ),
          SizedBox(width: 5.0.w),
          Flexible(
            child: Text(
              name,
              softWrap: true,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.0.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<Auth>().user!;
    final shops = context.watch<Shops>().findByUser(user.id);
    final Shop? shop = shops.isNotEmpty ? shops.first : null;

    return Container(
      padding: EdgeInsets.only(bottom: 14.0.h, left: 14.0.w, right: 14.0.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0.r),
          color: Colors.white.withOpacity(0.5),
        ),
        child: TabBar(
          controller: tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0.r),
            color: Colors.white,
          ),
          tabs: [
            _tabChild(
              imgUrl: user.profilePhoto,
              name: user.displayName!,
              index: 0,
            ),
            _tabChild(
              imgUrl: shop?.profilePhoto,
              name: shop?.name ?? 'My Shop',
              index: 1,
            )
          ],
        ),
      ),
    );
  }
}
