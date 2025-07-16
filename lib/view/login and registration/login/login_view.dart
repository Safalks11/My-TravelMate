import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_core/src/get_main.dart';
import 'package:main_project/constants/auth_textformfield_inputdecoration.dart';
import 'package:main_project/controller/form_validation/form_validator.dart';
import 'package:main_project/view/admin/admin_home.dart';
import 'package:main_project/view/home/home_screen.dart';
import 'package:main_project/view/login%20and%20registration/login/login_bloc.dart';
import 'package:main_project/view/login%20and%20registration/registration/registration_view.dart';
import 'package:main_project/widgets/error_snackbar.dart';
import 'package:main_project/widgets/success_snackbar.dart';

import '../../../controller/firebase_helper/firebase_helper.dart';
import '../../../widgets/loading_bottomsheet.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final loginEmailController = TextEditingController();
  final loginPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
        create: (context) => LoginBloc(),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            height: size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    filterQuality: FilterQuality.low,
                    colorFilter: ColorFilter.srgbToLinearGamma(),
                    image: AssetImage("assets/bg_images/reg_bg.jpg"))),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: true,
              body: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: BlocConsumer<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginLoading) {
                        showLoadingBottomSheet(); // Show loading indicator
                      } else {
                        // Close BottomSheet if open
                        if (Get.isBottomSheetOpen ?? false) {
                          Get.back(); // Close the BottomSheet
                        }

                        if (state is AdminLoginSuccess) {
                          Get.offAll(() => AdminHomeScreen());
                          showSuccess(context, "Admin Signed In !",
                              "You have successfully logged in as Admin...");
                        } else if (state is LoginSuccess) {
                          Get.offAll(() => HomeScreen(index: 0));
                          showSuccess(context, "Signed In !",
                              "You have successfully logged in...");
                        } else if (state is LoginFailure) {
                          showError(context, 'Login failed!', state.error);
                        }
                      }
                    },
                    builder: (context, state) {
                      bool isLoading = state is LoginLoading;
                      final isPasswordVisible =
                          state is PasswordVisibilityToggled
                              ? state.showPassword
                              : false;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: size.height * 0.18),
                          Text(
                            "Welcome Back, Explorer !",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Sign in to continue your journey and\ndiscover new adventures",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: size.height * 0.035),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 15),
                            child: TextFormField(
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.emailAddress,
                              controller: loginEmailController,
                              validator: FormValidator.simpleEmailValidator,
                              decoration: buildInputDecoration(
                                  hintText: "Email",
                                  prefixIcon: Icons.email_outlined),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 15),
                              child: TextFormField(
                                cursorColor: Colors.black,
                                controller: loginPassController,
                                validator: FormValidator.validatePassword,
                                obscureText: !isPasswordVisible,
                                decoration: buildInputDecoration(
                                    hintText: "Password",
                                    prefixIcon: Icons.lock_outline_rounded,
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        // Trigger password visibility toggle event
                                        context.read<LoginBloc>().add(
                                              TogglePasswordVisibilityEvent(
                                                  !isPasswordVisible),
                                            );
                                      },
                                      child: Icon(
                                        isPasswordVisible
                                            ? FontAwesomeIcons.eye
                                            : FontAwesomeIcons.eyeSlash,
                                        size: 20,
                                      ),
                                    )),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () async {
                                      final email =
                                          loginEmailController.text.trim();
                                      final validationMessage =
                                          FormValidator.simpleEmailValidator(
                                              email);
                                      if (validationMessage != null) {
                                        showError(context, 'Invalid Email',
                                            validationMessage);
                                        return;
                                      }
                                      await FirebaseHelper().forgotPassword(
                                          context,
                                          loginEmailController.text.trim());
                                    },
                                    child: Text(
                                      "Forgot your password ?",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700),
                                    ))
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.020),
                          SizedBox(
                            width: size.width * 0.85,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        Get.focusScope?.unfocus();

                                        final email =
                                            loginEmailController.text.trim();
                                        final password =
                                            loginPassController.text.trim();
                                        context.read<LoginBloc>().add(
                                            LoginUserEvent(
                                                email: email,
                                                password: password));
                                      }
                                    },
                              style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all(Colors.redAccent),
                                  shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)))),
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.055),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 12.0),
                                  child: Container(
                                    height:
                                        2, // Set the thickness of the divider
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.grey.shade700,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  " Or continue with ",
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 12.0),
                                  child: Container(
                                    height:
                                        2, // Set the thickness of the divider
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.grey.shade700,
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.045),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10)),
                                child: SvgPicture.asset(
                                  'assets/logo/google.svg',
                                  width: 35,
                                  height: 35,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10)),
                                child: SvgPicture.asset(
                                  'assets/logo/apple.svg',
                                  width: 35,
                                  height: 35,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10)),
                                child: SvgPicture.asset(
                                  'assets/logo/facebook.svg',
                                  width: 35,
                                  height: 35,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.045),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.to(
                                    () => RegScreen(),
                                    transition: getx.Transition.fadeIn,
                                    duration: const Duration(milliseconds: 700),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: const Text(
                                  "Sign Up Here!",
                                  style: TextStyle(
                                    color: Colors.orangeAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
