import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/community.dart';
import '../../state/mvvm_builder.widget.dart';
import '../../state/views/hook.view.dart';
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

    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              width: double.infinity,
              height: bottom == 0 ? 280.0.h : 150.h,
              color: kYellowColor,
              duration: Duration(milliseconds: 100),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: "Welcome",
                      child: Center(
                        child: Text(
                          "Welcome to",
                          style: TextStyle(
                            fontSize: 25.0.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Hero(
                      tag: "Community",
                      child: Center(
                        child: Text(
                          context.watch<CommunityProvider>().community?.name ??
                              'Community',
                          style: TextStyle(
                            fontSize: 25.0.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.0.h),
            Center(
              child: Text(
                "Create an account below",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17.0.sp,
                ),
              ),
            ),
            SizedBox(height: 20.0.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0.w),
              child: AuthInputForm(
                formKey: vm.formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                passwordValidator: vm.passwordValidator,
                submitButtonLabel: "REGISTER",
                onFormChanged: vm.onFormChanged,
                emailInputError: vm.errorMessage,
                onFormSubmit: () async => performFuture(
                  () async => await vm.emailSignUp(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0.h),
            SocialBlock(
              appleLogin: () async => await performFuture(vm.appleSignUp),
              fbLogin: () async => await performFuture(vm.facebookSignUp),
              googleLogin: () async => await performFuture(vm.googleSignUp),
              buttonWidth: 50.0.w,
            ),
            //SizedBox(height: 30.0.h)
          ],
        ),
      ),
    );
  }
}

// enum LoginType { email, google, facebook, apple }

// class RegisterScreen extends StatefulWidget {
//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> with ScreenLoader {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   void _signUpUser({
//     required LoginType type,
//     String? email,
//     String? password,
//   }) async {
//     final auth = context.read<Auth>();
//     try {
//       switch (type) {
//         case LoginType.email:
//           await auth.signUp(email!, password!);
//           break;
//         case LoginType.google:
//           await auth.loginWithGoogle();
//           break;
//         case LoginType.facebook:
//           await auth.loginWithFacebook();
//           break;
//         case LoginType.apple:
//           await auth.loginWithApple();
//           break;
//       }

//       if (auth.user == null) {
//         int count = 0;
//         Navigator.popUntil(context, (_) => count++ >= 2);
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => ProfileRegistration()),
//         );
//       } else {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => BottomNavigation()),
//           (route) => false,
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       debugPrint(e.message);
//       switch (e.code) {
//       }
//     } catch (e) {
//       // TODO: do something with error
//       print(e);
//     }
//   }

//   String? _passwordValidator(String? input) {
//     String? error;

//     final String numCharacterError = 'Must have at least 8 characters.';
//     final String numberError = 'Must have at least one number.';
//     final String specialError = 'Must have at least one special character.';

//     if (input == null || input.isEmpty) {
//       return '$numCharacterError\n$numberError\n$specialError';
//     }

//     if (input.length < 8) {
//       if (error == null) error = '';
//       error += '$numCharacterError\n';
//     }

//     if (!input.contains(RegExp(r'[0-9]'))) {
//       if (error == null) error = '';
//       error += '$numberError\n';
//     }

//     final pattern = r"[ `!@#$%^&*()_+\-=\[\]{};'" + r':"\\|,.<>\/?~]';
//     if (!input.contains(RegExp(pattern))) {
//       if (error == null) error = '';
//       error += '$specialError\n';
//     }

//     return error?.trim();
//   }

//   @override
//   Widget screen(BuildContext context) {
//     final bottom = MediaQuery.of(context).viewInsets.bottom;
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisAlignment: MainAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             AnimatedContainer(
//               width: double.infinity,
//               height: bottom == 0 ? 280.0.h : 150.h,
//               color: kYellowColor,
//               duration: Duration(milliseconds: 100),
//               child: SafeArea(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Hero(
//                       tag: "Welcome",
//                       child: Center(
//                         child: Text(
//                           "Welcome to",
//                           style: TextStyle(
//                             fontSize: 25.0.sp,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Hero(
//                       tag: "Community",
//                       child: Center(
//                         child: Text(
//                           "White Plains",
//                           style: TextStyle(
//                             fontSize: 25.0.sp,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 30.0.h),
//             Center(
//               child: Text(
//                 "Create an account below",
//                 style: TextStyle(
//                   fontWeight: FontWeight.w500,
//                   fontSize: 17.0.sp,
//                 ),
//               ),
//             ),
//             SizedBox(height: 20.0.h),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 30.0.w),
//               child: AuthInputForm(
//                 formKey: _formKey,
//                 emailController: _emailController,
//                 passwordController: _passwordController,
//                 passwordValidator: _passwordValidator,
//                 submitButtonLabel: "REGISTER",
//                 onFormChanged: () => setState(() {}),
//                 onFormSubmit: () {
//                   if (!_formKey.currentState!.validate()) return;
//                   _signUpUser(
//                     type: LoginType.email,
//                     email: _emailController.text.trim(),
//                     password: _passwordController.text.trim(),
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: 20.0.h),
//             SocialBlock(
//               fbLogin: () => _signUpUser(type: LoginType.facebook),
//               googleLogin: () => _signUpUser(type: LoginType.google),
//               buttonWidth: 50.0.w,
//             ),
//             //SizedBox(height: 30.0.h)
//           ],
//         ),
//       ),
//     );
//   }
// }
