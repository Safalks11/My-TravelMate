import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../controller/ai_trip_plan_controller.dart';

part 'ai_trip_plan_event.dart';
part 'ai_trip_plan_state.dart';

class AiTripPlanBloc extends Bloc<AiTripPlanEvent, AiTripPlanState> {
  final AiTripPlanController aiTripPlanController;

  AiTripPlanBloc(this.aiTripPlanController) : super(ChatbotInitial()) {
    on<GetTripPlan>((event, emit) async {
      emit(ChatbotLoading());
      final tripPlan = await aiTripPlanController.getTripPlan(
          event.travelType, event.place, event.budget, event.days);
      emit(ChatbotLoaded(tripPlan));
    });
  }
}
