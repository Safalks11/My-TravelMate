import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get.dart';
import 'package:main_project/controller/form_validation/form_validator.dart';
import 'package:main_project/view/login%20and%20registration/registration/registration_bloc.dart';
import 'package:main_project/widgets/error_snackbar.dart';
import 'package:main_project/widgets/loading_bottomsheet.dart';

import '../../../constants/auth_textformfield_inputdecoration.dart';
import '../../../widgets/success_snackbar.dart';
import '../login/login_view.dart';

class RegScreen extends StatelessWidget {
  RegScreen({super.key});

  final regUserNameController = TextEditingController();

  final regEmailController = TextEditingController();

  final regPassController = TextEditingController();

  final regConfPassController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => RegistrationBloc(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  filterQuality: FilterQuality.low,
                  colorFilter: ColorFilter.srgbToLinearGamma(),
                  fit: BoxFit.fitHeight,
                  image: AssetImage("assets/bg_images/reg_bg.jpg"))),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: BlocConsumer<RegistrationBloc, RegistrationState>(
                  listener: (context, state) {
                    if (state is RegistrationLoading) {
                      showLoadingBottomSheet();
                    } else if (state is RegistrationSuccess) {
                      Get.to(() => LoginScreen());
                      FocusScope.of(context).unfocus();
                      showSuccess(context, 'Success',
                          'You have registered successfully!');
                    } else if (state is RegistrationFailure) {
                      Get.back();
                      showError(context, 'Error', state.error);
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is RegistrationLoading;
                    final isPasswordVisible = state is PasswordVisibilityToggled
                        ? state.showPassword
                        : false;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: size.height * 0.10),
                        Column(
                          children: [
                            Text(
                              "Start Your Adventure Today !",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Create an account and unlock a world of\ntravel deals, tips, and destinations",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.030),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 15),
                          child: TextFormField(
                              controller: regUserNameController,
                              validator: FormValidator.validateName,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              decoration: buildInputDecoration(
                                  hintText: "Name",
                                  prefixIcon: Icons.person_outline)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 15),
                          child: TextFormField(
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.emailAddress,
                              enableSuggestions: true,
                              validator: FormValidator.simpleEmailValidator,
                              textInputAction: TextInputAction.next,
                              controller: regEmailController,
                              decoration: buildInputDecoration(
                                  hintText: "Email",
                                  prefixIcon: Icons.email_outlined)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 15, bottom: 5),
                          child: TextFormField(
                            cursorColor: Colors.black,
                            validator: FormValidator.validatePassword,
                            controller: regPassController,
                            obscureText: !isPasswordVisible,
                            decoration: buildInputDecoration(
                                hintText: "Password",
                                prefixIcon: Icons.lock_outline,
                                helperText:
                                    "Password length must contain 6 characters",
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    // Trigger password visibility toggle event
                                    context.read<RegistrationBloc>().add(
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
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 15),
                          child: TextFormField(
                              cursorColor: Colors.black,
                              validator: (value) =>
                                  FormValidator.validateConfirmPassword(
                                      value, regPassController.text),
                              textInputAction: TextInputAction.done,
                              controller: regConfPassController,
                              obscureText: true,
                              decoration: buildInputDecoration(
                                  hintText: "Confirm Password",
                                  prefixIcon: Icons.lock_outline)),
                        ),
                        SizedBox(height: size.height * 0.025),
                        SizedBox(
                          width: size.width * 0.85,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      Get.focusScope?.unfocus();
                                      context.read<RegistrationBloc>().add(
                                            RegisterUserEvent(
                                              email: regEmailController.text
                                                  .trim(),
                                              password:
                                                  regPassController.text.trim(),
                                              username: regUserNameController
                                                  .text
                                                  .trim(),
                                            ),
                                          );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Sign Up",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.040),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: Container(
                                  height: 2, // Set the thickness of the divider
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
                                  height: 2, // Set the thickness of the divider
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
                        SizedBox(height: size.height * 0.040),
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
                        SizedBox(height: size.height * 0.035),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.to(
                                  () => LoginScreen(),
                                  transition: getx
                                      .Transition.fadeIn, // Slide from bottom
                                  duration: const Duration(
                                      milliseconds:
                                          700), // Smooth animation speed
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: const Text(
                                "Sign In Here!",
                                style: TextStyle(
                                    color: Colors.orangeAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
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
      ),
    );
  }
}
