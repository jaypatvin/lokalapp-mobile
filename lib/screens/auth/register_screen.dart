import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../providers/community.dart';
import '../../state/mvvm_builder.widget.dart';
import '../../state/views/hook.view.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/auth/register_screen.vm.dart';
import '../../widgets/overlays/screen_loader.dart';
import 'components/auth_input_form.dart';
import 'components/sso_block.dart';

class RegisterScreen extends StatelessWidget {
  static const routeName = '/register';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _RegisterScreenView(),
      viewModel: RegisterScreenViewModel(),
    );
  }
}

class _RegisterScreenView extends HookView<RegisterScreenViewModel>
    with HookScreenLoader<RegisterScreenViewModel> {
  @override
  Widget screen(BuildContext context, RegisterScreenViewModel vm) {
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
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 50),
          curve: Curves.linear,
        );
      }
    });

    return Scaffold(
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
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 5.0),
              collapseMode: CollapseMode.pin,
              title: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to',
                    style: TextStyle(
                      fontSize: 24.0.sp,
                      fontWeight: FontWeight.w500,
                      color: kNavyColor,
                    ),
                  ),
                  Text(
                    context.watch<CommunityProvider>().community?.name ??
                        'the Community',
                    style: TextStyle(
                      fontSize: 24.0.sp,
                      fontWeight: FontWeight.bold,
                      color: kNavyColor,
                    ),
                  ),
                ],
              ),
              // background: const DecoratedBox(
              //   decoration: BoxDecoration(color: kYellowColor),
              // ),
              background: SvgPicture.asset(
                kSvgBackgroundHouses,
                fit: BoxFit.cover,
                color: kOrangeColor,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0.w),
              child: Column(
                children: [
                  SizedBox(height: 30.0.h),
                  Center(
                    child: Text(
                      'Create an account below',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17.0.sp,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0.w),
                    child: AuthInputForm(
                      formKey: vm.formKey,
                      emailController: _emailController,
                      emailFocusNode: _emailFocusNode,
                      passwordController: _passwordController,
                      passwordFocusNode: _passwordFocusNode,
                      passwordValidator: vm.passwordValidator,
                      submitButtonLabel: 'REGISTER',
                      onFormChanged: vm.onFormChanged,
                      emailInputError: vm.errorMessage,
                      onFormSubmit: () async => performFuture(
                        () async => vm.emailSignUp(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        ),
                      ),
                    ),
                  ),
                  SocialBlock(
                    appleLogin: () async => performFuture(vm.appleSignUp),
                    fbLogin: () async => performFuture(vm.facebookSignUp),
                    googleLogin: () async => performFuture(vm.googleSignUp),
                    buttonWidth: 50.0.w,
                  ),
                  SizedBox(height: 10.0.h),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
