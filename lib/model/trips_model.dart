import 'package:flutter/material.dart';

class GetTrips {
  final String id;
  final DateTimeRange? dateRange;
  final String place;
  final String travelType;
  final int peopleCount;
  final String? budget;
  final int? tripStatus;

  GetTrips(
      {required this.id,
      required this.dateRange,
      required this.place,
      required this.travelType,
      required this.peopleCount,
      this.budget,
      this.tripStatus});

  factory GetTrips.fromJson(Map<String, dynamic> json) {
    return GetTrips(
      id: json['id'],
      dateRange: json['dateRange'] != null
          ? DateTimeRange(
              start: DateTime.parse(json['dateRange']['start']),
              end: DateTime.parse(json['dateRange']['end']),
            )
          : null,
      place: json['place'],
      travelType: json['travelType'],
      peopleCount: json['peopleCount'],
      budget: json['budget'],
      tripStatus: json['tripStatus'],
    );
  }
}
