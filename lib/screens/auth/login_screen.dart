import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../state/mvvm_builder.widget.dart';
import '../../state/views/hook.view.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/auth/login_screen.vm.dart';
import '../../widgets/overlays/screen_loader.dart';
import 'components/auth_input_form.dart';
import 'components/sso_block.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _LoginScreenView(),
      viewModel: LoginScreenViewModel(),
    );
  }
}

class _LoginScreenView extends HookView<LoginScreenViewModel>
    with HookScreenLoader<LoginScreenViewModel> {
  @override
  Widget screen(BuildContext context, LoginScreenViewModel vm) {
    final _emailController = useTextEditingController();
    final _passwordController = useTextEditingController();
    final _emailFocusNode = useFocusNode();
    final _passwordFocusNode = useFocusNode();
    final _scrollController = useScrollController();

    final _prevBottom = useRef(0.0);

    useValueChanged(MediaQuery.of(context).viewInsets.bottom, (_, __) async {
      if (MediaQuery.of(context).viewInsets.bottom != 0) {
        if (_prevBottom.value >= MediaQuery.of(context).viewInsets.bottom) {
          _prevBottom.value = MediaQuery.of(context).viewInsets.bottom;
          return;
        }

        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollController.animateTo(
            280.0.h - kToolbarHeight,
            duration: const Duration(milliseconds: 50),
            curve: Curves.linear,
          );
        });
      } else {
        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollController.animateTo(
            _scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 50),
            curve: Curves.linear,
          );
        });
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 280.0.h,
            automaticallyImplyLeading: false,
            backgroundColor: kYellowColor,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 5.0),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'LOKAL',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kOrangeColor,
                      fontSize: 24.0.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Your neighborhood plaza',
                    style: TextStyle(
                      fontSize: 14.0.sp,
                      color: kTealColor,
                      fontFamily: 'Goldplay',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              background: Container(
                color: kYellowColor,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: SvgPicture.asset(
                        kSvgBackgroundHouses,
                        fit: BoxFit.cover,
                        color: kOrangeColor,
                      ),
                    ),
                    Center(
                      child: Transform.translate(
                        offset: Offset(0, -30.0.h),
                        child: Hero(
                          tag: kSvgLokalLogoV2,
                          child: SvgPicture.asset(
                            kSvgLokalLogoV2,
                            fit: BoxFit.scaleDown,
                            color: kOrangeColor.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0.w),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30.0.h, bottom: 10.0.h),
                    child: AuthInputForm(
                      formKey: vm.formKey,
                      emailController: _emailController,
                      emailFocusNode: _emailFocusNode,
                      passwordController: _passwordController,
                      passwordFocusNode: _passwordFocusNode,
                      submitButtonLabel: 'SIGN IN',
                      passwordInputError: vm.errorMessage,
                      onFormChanged: vm.onFormChanged,
                      onFormSubmit: () async => performFuture(
                        () async => vm.emailLogin(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Text(
                      'FORGOT PASSWORD?',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    onTap: () {},
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 20.0.h,
                      bottom: 10.0.h,
                    ),
                    child: SocialBlock(
                      fbLogin: () async => performFuture(vm.facebookLogin),
                      googleLogin: () async => performFuture(vm.googleLogin),
                      appleLogin: () async => performFuture(vm.appleLogin),
                      buttonWidth: 50.0.w,
                    ),
                  ),
                  if (MediaQuery.of(context).viewInsets.bottom != 0)
                    const SizedBox(height: kKeyboardActionHeight),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
