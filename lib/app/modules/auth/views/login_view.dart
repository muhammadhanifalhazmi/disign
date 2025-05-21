import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../utils/theme.dart';
import '../../../widget/header_widget.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  _loginBtn() {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
          onPressed: () => controller.loginWithRetry(),
          style: ButtonStyle(
              fixedSize: WidgetStateProperty.all<Size>(const Size(190, 40)),
              backgroundColor: WidgetStateProperty.all<Color>(primaryColor),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ))),
          child: Text(
            "sign",
            style: primaryTextStyle.copyWith(color: whiteColor),
          )),
    );
  }

  _passwordField() {
    return Obx(() => Container(
          margin: const EdgeInsetsDirectional.only(top: 15),
          child: TextFormField(
            controller: controller.passwordController,
            obscureText: controller.isObscure.value,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: Colors.grey,
              ),
              labelText: 'password',
              // this button is used to toggle the password visibility
              suffixIcon: IconButton(
                  icon: Icon(controller.isObscure.value
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    controller.isObscure.value = !controller.isObscure.value;
                  }),
              border: OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: accent1Color)),
              hintStyle: secondaryTextStyle,
              hintText: "password",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: accent1Color),
              ),
            ),
          ),
        ));
  }

  _loginField() {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 15),
      child: TextFormField(
        controller: controller.usernameController,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.person_outline,
            color: Colors.grey,
          ),
          labelText: "username",
          border: OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: accent1Color)),
          hintStyle: secondaryTextStyle,
          hintText: "username",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: accent1Color),
          ),
        ),
      ),
    );
  }

  _footer() {
    return Container(
      margin: const EdgeInsets.only(bottom: defaultMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("don’t have account? ", style: secondaryTextStyle),
          InkWell(
            onTap: () => controller.redirectToRegister(),
            child: Text("Sign Up ",
                style: secondaryTextStyle.copyWith(
                    decoration: TextDecoration.underline, color: primaryColor)),
          ),
    
          // LinkedTextWidget(
          //   text: 'Sign Up',
          //   routeName: '/register-first',
          //   colour: primaryColor,
          // )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: defaultMargin),
            child: Obx(() => (controller.isLoading.value)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomHeaderWidget(
                          title: 'Sign  In',
                          subTitle: 'with your disign account',
                          marginTop: 150),
                      const SizedBox(height: 5),
                      // const CustomTextFieldWidget(text: 'disignID'),
                      // const CustomTextFieldWidget(text: 'password'),
                      _loginField(),
                      _passwordField(),
                      const SizedBox(height: 20),
                      // LinkedTextWidget(
                      //     text: 'forgot id or password?',
                      //     routeName: '',
                      //     colour: secondaryTextColor),
                      const SizedBox(height: 35),
                      _loginBtn(),
                      const Spacer(),
                      _footer(),
                    ],
                  ))),
      ),
    );
  }
}
