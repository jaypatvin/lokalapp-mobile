import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/app_navigator.dart';
import '../../models/lokal_user.dart';
import '../../providers/auth.dart';
import '../../providers/users.dart';
import '../../routers/app_router.dart';
import '../../routers/chat/props/chat_details.props.dart';
import '../../utils/constants/themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../chat/chat_details.dart';
import '../chat/components/chat_avatar.dart';
import '../profile/profile_screen.dart';

class CommunityMembers extends HookWidget {
  const CommunityMembers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _nameStyle = useMemoized<TextStyle?>(
      () =>
          Theme.of(context).textTheme.subtitle2?.copyWith(color: Colors.black),
    );
    final _headerStyle = useMemoized<TextStyle?>(
      () =>
          Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.black),
    );
    final _admins = useMemoized<List<LokalUser>>(
      () => context
          .read<Users>()
          .users
          .where((user) => user.roles.admin)
          .toList(),
    );
    final _users =
        useMemoized<List<LokalUser>>(() => context.read<Users>().users);

    final _onChatUsers = useCallback<void Function(String userId)>(
      (String userId) {
        // AppRouter.rootNavigatorKey.currentState?.pop();
        context.read<AppRouter>()
          ..keyOf(AppRoute.root).currentState?.pop()
          ..navigateTo(
            AppRoute.chat,
            ChatDetails.routeName,
            arguments: ChatDetailsProps(
              members: [context.read<Auth>().user!.id, userId],
            ),
          );
      },
      [],
    );

    final _onUserPressed = useCallback<void Function(String userId)>(
      (String userId) {
        if (context.read<Auth>().user!.id == userId) {
          context.read<AppRouter>()
            ..keyOf(AppRoute.root).currentState?.pop()
            ..jumpToTab(AppRoute.profile);
          return;
        }

        // otherwise, we push a new screen inside the current navigation stack
        final appRoute = context.read<AppRouter>().currentTabRoute;
        context.read<AppRouter>()
          ..keyOf(AppRoute.root).currentState?.pop()
          ..pushDynamicScreen(
            appRoute,
            AppNavigator.appPageRoute(
              builder: (_) => ProfileScreen(
                userId: userId,
              ),
            ),
          );
      },
      [],
    );

    return Scaffold(
      appBar: const CustomAppBar(
        titleText: 'Community Members',
        titleStyle: TextStyle(color: Colors.white),
        backgroundColor: kTealColor,
      ),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Text('Admins', style: _headerStyle),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final _admin = _admins[index];
                  return Column(
                    children: [
                      ListTile(
                        tileColor: Colors.white,
                        contentPadding: EdgeInsets.zero,
                        onTap: () => _onUserPressed(_admin.id),
                        leading: ChatAvatar(
                          radius: 21,
                          displayPhoto: _admin.profilePhoto,
                          displayName: _admin.displayName,
                        ),
                        title: Text(
                          _admin.displayName,
                          style: _nameStyle,
                        ),
                        trailing: GestureDetector(
                          onTap: () => _onChatUsers(_admin.id),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: kNavyColor, width: 2),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                MdiIcons.messageProcessingOutline,
                                color: kNavyColor,
                                size: 21,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (index != _admins.length - 1)
                        const Divider(
                          color: Color(0XFFE0E0E0),
                        ),
                    ],
                  );
                },
                childCount: _admins.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 20),
              child: Text('Members', style: _headerStyle),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final _user = _users[index];
                  return Column(
                    children: [
                      ListTile(
                        tileColor: Colors.white,
                        contentPadding: EdgeInsets.zero,
                        onTap: () => _onUserPressed(_user.id),
                        leading: ChatAvatar(
                          radius: 21,
                          displayPhoto: _user.profilePhoto,
                          displayName: _user.displayName,
                        ),
                        title: Text(
                          _user.displayName,
                          style: _nameStyle,
                        ),
                        trailing: GestureDetector(
                          onTap: () => _onChatUsers(_user.id),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: kNavyColor, width: 2),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                MdiIcons.messageProcessingOutline,
                                color: kNavyColor,
                                size: 21,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (index != _users.length - 1)
                        const Divider(
                          color: Color(0XFFE0E0E0),
                        ),
                    ],
                  );
                },
                childCount: _users.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
