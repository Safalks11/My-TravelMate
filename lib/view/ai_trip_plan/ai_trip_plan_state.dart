part of 'ai_trip_plan_bloc.dart';

@immutable
abstract class AiTripPlanState {}

class ChatbotInitial extends AiTripPlanState {}

class ChatbotLoading extends AiTripPlanState {}

class ChatbotLoaded extends AiTripPlanState {
  final String tripPlan;

  ChatbotLoaded(this.tripPlan);
}
