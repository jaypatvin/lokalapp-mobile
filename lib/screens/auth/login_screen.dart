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

    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedContainer(
            color: kYellowColor,
            height: bottom == 0 ? 280.0.h : 150.h,
            duration: const Duration(milliseconds: 100),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: kSvgLokalLogoV2,
                        child: SvgPicture.asset(kSvgLokalLogoV2),
                      ),
                      Hero(
                        tag: '${kSvgLokalLogoV2}_title',
                        child: Text(
                          'LOKAL',
                          style: TextStyle(
                            color: kOrangeColor,
                            fontSize: 24.0.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Hero(
                        tag: '${kSvgLokalLogoV2}_subTitle',
                        child: Text(
                          'Your neighborhood plaza',
                          style: TextStyle(
                            fontSize: 14.0.sp,
                            color: kTealColor,
                            fontFamily: 'Goldplay',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30.0.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0.w),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AuthInputForm(
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
                SizedBox(height: 10.0.h),
                InkWell(
                  child: Text(
                    'FORGOT PASSWORD?',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  onTap: () {},
                ),
                SizedBox(height: 20.0.h),
                SocialBlock(
                  fbLogin: () async => performFuture(vm.facebookLogin),
                  googleLogin: () async => performFuture(vm.googleLogin),
                  appleLogin: () async => performFuture(vm.appleLogin),
                  buttonWidth: 50.0.w,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
