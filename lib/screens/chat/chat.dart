import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../models/chat_model.dart';
import '../../models/shop.dart';
import '../../providers/auth.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../services/database/collections/chats.collection.dart';
import '../../services/database/database.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import 'components/chat_avatar.dart';
import 'components/chat_stream.dart';

class Chat extends StatefulWidget {
  static const routeName = '/chat';
  const Chat({super.key});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with TickerProviderStateMixin {
  late final TabController _tabController;

  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;
  late final ChatsCollection _db;

  late Stream<List<ChatModel>> _userChatStream;
  Stream<List<ChatModel>>? _shopChatStream;

  @override
  void initState() {
    super.initState();
    _db = context.read<Database>().chats;
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _tabController.addListener(_tabSelectionHandler);
    _colorAnimation = ColorTween(
      begin: kTealColor,
      end: kPurpleColor,
    ).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    final user = context.read<Auth>().user!;
    final shops = context.read<Shops>().findByUser(user.id);
    _userChatStream = _db.getUserChats(user.id);
    if (shops.isNotEmpty) {
      _shopChatStream = _db.getUserChats(shops.first.id);
    }
  }

  void _tabSelectionHandler() {
    setState(() {
      switch (_tabController.index) {
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
        // height: 120.0.h,
        height: 135,
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
          final userShops = shops.findByUser(user.id);

          if (_shopChatStream == null && userShops.isNotEmpty) {
            _shopChatStream = _db.getUserChats(userShops.first.id);
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
      title: const Text(
        'Chats',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Goldplay',
          fontWeight: FontWeight.w600,
          fontSize: 20,
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
  final TabController tabController;
  const _ChatAppBarBottom({required this.tabController});

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  Widget _tabChild({
    String? imgUrl,
    required String name,
    required int index,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ChatAvatar(
            displayName: name,
            displayPhoto: imgUrl,
            radius: index == tabController.index ? 25 : 16,
          ),
          SizedBox(width: tabController.index == index ? 12 : 10),
          Flexible(
            child: Text(
              name,
              softWrap: true,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Goldplay',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color:
                    tabController.index == index ? Colors.black : Colors.white,
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
      padding: const EdgeInsets.only(bottom: 13, left: 16, right: 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.white.withOpacity(0.5),
        ),
        child: TabBar(
          controller: tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.white,
          ),
          tabs: [
            _tabChild(
              imgUrl: user.profilePhoto,
              name: user.displayName,
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
