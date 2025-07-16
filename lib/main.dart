import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:main_project/view/ai_trip_plan/ai_trip_plan_bloc.dart';
import 'package:main_project/view/chatbot_screen/chatbot_bloc.dart';
import 'package:main_project/view/home/home_bloc.dart';
import 'package:main_project/view/splash_screen/splash_screen_view.dart';
import 'package:main_project/view/trip_planner/add_trip/add_trip_bloc.dart';
import 'package:main_project/view/trip_planner/trip_editing/trip_expense/trip_expense_bloc.dart';
import 'package:main_project/view/trip_planner/trip_editing/trip_items/trip_items_bloc.dart';
import 'package:main_project/view/trip_planner/trip_editing/trip_notes/trip_notes_bloc.dart';
import 'package:main_project/view/trip_planner/trip_main_screen/trip_main_bloc.dart';

import 'controller/ai_trip_plan_controller.dart';
import 'controller/chatbot_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  final chatbotController = ChatbotController();
  final aiTripPlanController = AiTripPlanController();

  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => HomeBloc()..add(HomeInitialEvent())),
    BlocProvider(create: (context) => TripMainBloc()..add(FetchTripsEvent())),
    BlocProvider(create: (context) => ExpenseBloc()),
    BlocProvider(create: (context) => TripItemsBloc()),
    BlocProvider(create: (context) => TripNotesBloc()),
    BlocProvider(create: (context) => AddTripBloc()),
    BlocProvider(create: (context) => ChatbotBloc(chatbotController)),
    BlocProvider(create: (context) => AiTripPlanBloc(aiTripPlanController)),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Nunito',
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(10)))))),
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
