import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/community.dart';
import '../../routers/app_router.dart';
import '../../state/mvvm_builder.widget.dart';
import '../../state/views/stateless.view.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/home/post_field.vm.dart';
import '../../widgets/custom_app_bar.dart';
import '../cart/cart_container.dart';
import 'notifications.dart';
import 'timeline.dart';

class Home extends HookWidget {
  static const routeName = '/home';
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _scrollController = useScrollController();
    final _postFieldHeight = useMemoized(() => 75.0.h, []);

    return Scaffold(
      backgroundColor: const Color(0xffF1FAFF),
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        titleText:
            context.watch<CommunityProvider>().community?.name ?? 'Community',
        titleStyle: const TextStyle(color: Colors.white),
        backgroundColor: kTealColor,
        buildLeading: false,
        actions: [
          IconButton(
            onPressed: () => context
                .read<AppRouter>()
                .keyOf(AppRoute.home)
                .currentState!
                .pushNamed(Notifications.routeName),
            icon: const Icon(Icons.notifications_outlined),
          )
        ],
      ),
      body: CartContainer(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Timeline(
                scrollController: _scrollController,
                firstIndexPadding: _postFieldHeight,
              ),
              _PostField(
                scrollController: _scrollController,
                height: _postFieldHeight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostField extends StatelessWidget {
  const _PostField({
    Key? key,
    this.height = 75.0,
    required this.scrollController,
  }) : super(key: key);

  final double height;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _PostFieldView(),
      viewModel: PostFieldViewModel(
        scrollController: scrollController,
        height: height,
      ),
    );
  }
}

class _PostFieldView extends StatelessView<PostFieldViewModel> {
  @override
  Widget render(BuildContext context, PostFieldViewModel vm) {
    return Transform.translate(
      offset: Offset(0, vm.postFieldOffset),
      child: Container(
        height: vm.height,
        width: double.infinity,
        color: kInviteScreenColor.withOpacity(0.7),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.0.w,
            vertical: 15.h,
          ),
          child: GestureDetector(
            onTap: vm.onDraftPostTapHandler,
            child: Container(
              height: 50.0.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.all(Radius.circular(15.0.r)),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "What's on your mind?",
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Icon(
                    MdiIcons.squareEditOutline,
                    color: Color(0xffE0E0E0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
