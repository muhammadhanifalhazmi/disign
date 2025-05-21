import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

import 'package:get/get.dart';

import '../../../utils/theme.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  _deviceNameField() {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Device Name : "),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: controller.deviceNameController,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.devices_outlined,
                color: Colors.grey,
              ),
              labelText: "device name",
              border: OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: accent1Color)),
              hintStyle: secondaryTextStyle,
              hintText: "name this device",
              // enabledBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(20),
              //   borderSide: BorderSide(color: accent1Color),
              // ),
            ),
          ),
        ],
      ),
    );
  }

  _hwidField() {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 15),
      child: TextFormField(
        enabled: false,
        controller: controller.deviceIdController,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.perm_device_info,
            color: Colors.grey,
          ),
          labelText: "device id",
          labelStyle: primaryTextStyle,
          border: OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: accent1Color)),
          hintStyle: secondaryTextStyle,
          // hintText: "location",
          // enabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(20),
          //   borderSide: BorderSide(color: accent1Color),
          // ),
        ),
      ),
    );
  }

  _pinField() {
    return Obx(() => Container(
          margin: const EdgeInsetsDirectional.only(top: 15),
          child: Form(
            key: controller.pinFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("PIN for Transaction : "),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  maxLength: 6,
                  controller: controller.pinController,
                  obscureText: controller.isPinObscure.value,
                  keyboardType: TextInputType.number,
                  validator: (value) => controller.validatePin(value),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.security_outlined,
                      color: Colors.grey,
                    ),
                    labelText: 'PIN',
                    // this button is used to toggle the password visibility
                    suffixIcon: IconButton(
                        icon: Icon(controller.isObscure.value
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          controller.isPinObscure.value =
                              !controller.isPinObscure.value;
                        }),
                    border: OutlineInputBorder(
                        // width: 0.0 produces a thin "hairline" border
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: accent1Color)),
                    hintStyle: secondaryTextStyle,
                    hintText: "PIN for transaction",
                    // enabledBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(20),
                    //   borderSide: BorderSide(color: accent1Color),
                    // ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  _passwordConfirmField() {
    return Obx(() => Container(
          margin: const EdgeInsetsDirectional.only(top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Password Confirmation : "),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: controller.passwordConfirmController,
                obscureText: controller.isObscure.value,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Colors.grey,
                  ),
                  labelText: 're-enter password',
                  // this button is used to toggle the password visibility
                  suffixIcon: IconButton(
                      icon: Icon(controller.isObscure.value
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        controller.isObscure.value =
                            !controller.isObscure.value;
                      }),
                  border: OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: accent1Color)),
                  hintStyle: secondaryTextStyle,
                  hintText: "same as password",
                  // enabledBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(20),
                  //   borderSide: BorderSide(color: accent1Color),
                  // ),
                ),
              ),
            ],
          ),
        ));
  }

  _passwordField() {
    return Obx(() => Container(
          margin: const EdgeInsetsDirectional.only(top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Password for Login : "),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
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
                        controller.isObscure.value =
                            !controller.isObscure.value;
                      }),
                  border: OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: accent1Color)),
                  hintStyle: secondaryTextStyle,
                  hintText: "password",
                  // enabledBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(20),
                  //   borderSide: BorderSide(color: accent1Color),
                  // ),
                ),
              ),
            ],
          ),
        ));
  }

  _emailField() {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Email : "),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: controller.emailController,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.alternate_email_outlined,
                color: Colors.grey,
              ),
              labelText: "email",
              border: OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: accent1Color)),
              hintStyle: secondaryTextStyle,
              hintText: "Your email",
              // enabledBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(20),
              //   borderSide: BorderSide(color: accent1Color),
              // ),
            ),
          ),
        ],
      ),
    );
  }

  _locationField() {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 15),
      child: TextFormField(
        enabled: false,
        controller: controller.locationController,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.location_on_outlined,
            color: Colors.grey,
          ),
          labelText: "Country",
          labelStyle: primaryTextStyle,
          border: OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: accent1Color)),
          hintStyle: secondaryTextStyle,
          // hintText: "location",
          // enabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(20),
          //   borderSide: BorderSide(color: accent1Color),
          // ),
        ),
      ),
    );
  }

  _nameField() {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Full Name : "),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: controller.nameController,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.person,
                color: Colors.grey,
              ),
              labelText: "name",
              border: OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: accent1Color)),
              hintStyle: secondaryTextStyle,
              hintText: "Your full name",
              // enabledBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(20),
              //   borderSide: BorderSide(color: accent1Color),
              // ),
            ),
          ),
        ],
      ),
    );
  }

  _usernameField() {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Username for Login : "),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: controller.usernameController,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.person_outline,
                color: Colors.grey,
              ),
              labelText: "username",
              border: OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: accent1Color)),
              hintStyle: secondaryTextStyle,
              hintText: "username for sign in",
              // enabledBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(20),
              //   borderSide: BorderSide(color: accent1Color),
              // ),
            ),
          ),
        ],
      ),
    );
  }

  List<Step> getSteps() {
    return <Step>[
      Step(
        state:
            controller.currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: controller.currentStep >= 0,
        title: Text(controller.currentStep == 0 ? "Account" : ""),
        content: Column(
          children: [
            _usernameField(),
            _nameField(),
            _locationField(),
            _emailField(),
          ],
        ),
      ),
      Step(
        state:
            controller.currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: controller.currentStep >= 1,
        title: Text(controller.currentStep == 1 ? "Device" : ""),
        content: Column(
          children: [_hwidField(), _deviceNameField()],
        ),
      ),
      Step(
        state:
            controller.currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: controller.currentStep >= 2,
        title: Text(controller.currentStep >= 2 ? "Security" : ""),
        content: Column(
          children: [
            _pinField(),
            _passwordField(),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: FlutterPwValidator(
                  width: 350,
                  height: 50,
                  minLength: 6,
                  onSuccess: () => controller.isPasswordOk.value = true,
                  onFail: () => controller.isPasswordOk.value = false,
                  controller: controller.passwordController),
            ),
            _passwordConfirmField(),
          ],
        ),
      ),
    ];
  }

  _appBar(String text) {
    return AppBar(
      automaticallyImplyLeading: true,
      // leading: GestureDetector(
      //   child: Container(
      //       margin: const EdgeInsetsDirectional.only(top: defaultMargin),
      //       child: Icon(Icons.arrow_back, color: secondaryTextColor)),
      //   onTap: () => {},
      // ),
      title: Container(
        // margin: const EdgeInsets.only(top: defaultMargin),
        child: Text(
          text,
          style: secondaryTextStyle,
        ),
      ),
      centerTitle: true,
      backgroundColor: whiteColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: _appBar("Register"),
      body: SafeArea(
        child: Container(
            height: height,
            margin: const EdgeInsets.all(defaultMargin),
            child: Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(primary: primaryColor)),
              child: Obx(() => Stepper(
                    type: StepperType.horizontal,
                    currentStep: controller.currentStep.value,
                    onStepContinue: () => controller.onStepContinue(),
                    onStepCancel: () => controller.onStepCancel(),
                    steps: getSteps(),
                    controlsBuilder: (context, details) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            (controller.currentStep.value == 0)
                                ? const SizedBox()
                                : Expanded(
                                    child: ElevatedButton(
                                        onPressed: () =>
                                            controller.onStepCancel(),
                                        child: const Text('Back'))),
                            (controller.currentStep.value != 0)
                                ? const SizedBox(
                                    width: 16,
                                  )
                                : const SizedBox(),
                            Expanded(
                                child: ElevatedButton(
                                    onPressed: () =>
                                        controller.onStepContinue(),
                                    child: Text(
                                        (controller.currentStep.value == 2)
                                            ? 'Register'
                                            : 'Next'))),
                            // _registerBtn(),
                            // _registerBtn()
                          ],
                        ),
                      );
                    },
                  )),
            )),
      ),
    );
  }
}
