import 'package:flutter/gestures.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/common/rounded_small_button.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/controller/auth_controler.dart';
import 'package:twitter_clone/features/auth/view/login_view.dart';
import 'package:twitter_clone/features/auth/widgets/auth_field.dart';
import 'package:twitter_clone/theme/pallete.dart';

class SignInEmailValidator{
  static String validateEmail(String value){
    String res = "";
    if(value==""){
      res = "email is required";
    }
    return res;
  }
}

class SignInPasswordValidator{
  static String validatePassword(String value){
    String res = "";
    if(value==""){
      res = "password is required";
    }
    return res;
  }
}

class SignUpView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
    builder: (context) => const SignUpView(),
  );
  const SignUpView({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {

  final appbar = UIConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onSignUp(){
    ref.read(authControllerProvider.notifier).signUp(
      email: emailController.text,
      password: passwordController.text,
      context: context,
    );

    print(SignInEmailValidator.validateEmail(emailController.text));
    print(SignInPasswordValidator.validatePassword(passwordController.text));
  }
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: appbar,
      body: isLoading ?
      const Loader():
      Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [

                AuthField(
                  controller: emailController,
                  hintText: 'Email',
                ),
                const SizedBox(
                  height: 25,
                ),

                AuthField(
                  controller: passwordController,
                  hintText: 'Password',
                ),
                const SizedBox(
                  height: 40,
                ),

                Align(
                  alignment: Alignment.topRight,
                  child: RoundedSmallButton(
                    onTap: onSignUp,
                    label: 'Done',
                  ),
                ),
                const SizedBox(height:40),
                RichText(
                  text: TextSpan(
                    text: "Already have an account?",
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: const TextStyle(
                          color: Pallete.blueColor,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap=() {
                            Navigator.push(
                              context,
                              LoginView.route(),
                            );
                          },
                      ),
                    ],
                  ),
                ),
                //textspan
              ],
            ),
          ),
        ),
      ),
    );
  }
}
