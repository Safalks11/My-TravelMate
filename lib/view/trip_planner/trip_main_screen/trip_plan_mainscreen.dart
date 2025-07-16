import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:main_project/model/trips_model.dart';
import 'package:main_project/view/trip_planner/trip_editing/trip_editing_screen.dart';
import 'package:main_project/view/trip_planner/trip_main_screen/trip_main_bloc.dart';

class TripPlannerScreen extends StatefulWidget {
  final List<GetTrips> trips;

  const TripPlannerScreen({super.key, required this.trips});

  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<TripMainBloc>().add(FetchTripsEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          indicatorColor: Colors.pinkAccent,
          indicatorWeight: 3.0,
          labelColor: Colors.pinkAccent,
          unselectedLabelColor: Colors.black54,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
          ],
        ),
        Expanded(
            child: TabBarView(
          controller: _tabController,
          children: [
            BlocBuilder<TripMainBloc, TripMainState>(
              builder: (context, state) {
                if (state is TripLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TripsLoadedState) {
                  return UpComingTripsTab(trips: state.trips);
                } else {
                  return const Center(child: Text("Failed to load trips"));
                }
              },
            ),
            // UpComingTripsTab(trips: widget.trips),
            BlocBuilder<TripMainBloc, TripMainState>(
              builder: (context, state) {
                if (state is TripsLoadedState) {
                  return CompletedTripsTab(trips: state.trips);
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        )),
      ],
    );
  }
}

class UpComingTripsTab extends StatelessWidget {
  final List<GetTrips> trips;

  const UpComingTripsTab({super.key, required this.trips});

  @override
  Widget build(BuildContext context) {
    // Filter only upcoming trips (status = 1)
    final upcomingTrips = trips.where((trip) => trip.tripStatus == 1).toList();

    return upcomingTrips.isEmpty
        ? const Center(
            child: Text(
              "No Upcoming Trips",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: upcomingTrips.length,
            itemBuilder: (context, index) {
              final trip = upcomingTrips[index];
              final DateTime? date = trip.dateRange?.start;
              final String formattedMonthYear =
                  date != null ? DateFormat("MMM yyyy").format(date) : "N/A";
              final String formattedDate =
                  date != null ? DateFormat("d").format(date) : "N/A";
              final String formattedDay =
                  date != null ? DateFormat("E").format(date) : "N/A";

              return InkWell(
                onTap: () => Get.to(() => TripEditingScreen(trip: trip)),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.pinkAccent.withOpacity(0.2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            formattedDate,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.pinkAccent),
                          ),
                          Text(
                            formattedDay,
                            style:
                                TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    title: Text(
                      trip.place,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      formattedMonthYear,
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                            trip.peopleCount == 1
                                ? Icons.person
                                : trip.travelType == 'Couple'
                                    ? Icons.people_alt_outlined
                                    : Icons.people,
                            color: Colors.pinkAccent,
                            size: 22),
                        SizedBox(height: 4),
                        Text(
                          trip.travelType,
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 8),
          );
  }
}

class CompletedTripsTab extends StatelessWidget {
  final List<GetTrips> trips;

  const CompletedTripsTab({super.key, required this.trips});

  @override
  Widget build(BuildContext context) {
    // Filter only completed trips (status = 0)
    final completedTrips = trips.where((trip) => trip.tripStatus == 0).toList();

    return completedTrips.isEmpty
        ? const Center(
            child: Text(
              'No Completed Trips Yet',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: completedTrips.length,
            itemBuilder: (context, index) {
              final trip = completedTrips[index];
              final DateTime? date = trip.dateRange?.start;
              final String formattedMonthYear =
                  date != null ? DateFormat("MMM yyyy").format(date) : "N/A";
              final String formattedDate =
                  date != null ? DateFormat("d").format(date) : "N/A";
              final String formattedDay =
                  date != null ? DateFormat("E").format(date) : "N/A";
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blueAccent.withOpacity(0.2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (formattedDate),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.pinkAccent),
                        ),
                        Text(
                          (formattedDay),
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    trip.place,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    formattedMonthYear,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 22),
                      const SizedBox(height: 4),
                      Text(
                        trip.travelType,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 8),
          );
  }
}
