part of 'ai_trip_plan_bloc.dart';

@immutable
abstract class AiTripPlanEvent {}

class GetTripPlan extends AiTripPlanEvent {
  final String travelType;
  final String place;
  final String budget;
  final String days;

  GetTripPlan(this.travelType, this.place, this.budget, this.days);
}
