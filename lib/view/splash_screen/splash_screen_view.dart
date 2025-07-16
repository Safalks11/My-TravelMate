import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:main_project/view/login%20and%20registration/login/login_view.dart';
import 'package:main_project/view/splash_screen/splash_screen_bloc.dart';
import 'package:main_project/widgets/error_snackbar.dart';

import '../home/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashScreenBloc()..add(CheckAuthenticationEvent()),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocListener<SplashScreenBloc, SplashScreenState>(
          listener: (context, state) {
            if (state is SplashScreenNavigateToHome) {
              Get.offAll(() => HomeScreen(index: 0));
            } else if (state is SplashScreenNavigateToLogin) {
              Get.offAll(() => LoginScreen());
            } else if (state is SplashScreenError) {
              showError(context, 'Error', state.error);
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "assets/logo/app_icon.png",
                  height: 200,
                  width: 200,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "My TravelMate",
                  style: GoogleFonts.waitingForTheSunrise(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.green),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
