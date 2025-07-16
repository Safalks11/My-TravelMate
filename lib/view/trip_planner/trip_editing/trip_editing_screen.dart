import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:main_project/model/trips_model.dart';
import 'package:main_project/view/trip_planner/trip_editing/trip_expense/trip_expenses_screen.dart';
import 'package:main_project/view/trip_planner/trip_editing/trip_items/trip_items_screen.dart';
import 'package:main_project/view/trip_planner/trip_editing/trip_notes/trip_notes_screen.dart';
import 'package:main_project/widgets/app_bar.dart';
import 'package:main_project/widgets/help_snackbar.dart';
import 'package:main_project/widgets/section_title.dart';

import '../../home/home_screen.dart';
import '../trip_main_screen/trip_main_bloc.dart';

class TripEditingScreen extends StatefulWidget {
  final GetTrips trip;
  const TripEditingScreen({super.key, required this.trip});

  @override
  State<TripEditingScreen> createState() => _TripEditingScreenState();
}

class _TripEditingScreenState extends State<TripEditingScreen> {
  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    final currentDate = DateFormat("dd/MM/yyyy").format(DateTime.now());
    final startDate = DateFormat("dd/MM/yyyy").format(trip.dateRange!.start);
    final endDate = DateFormat("dd/MM/yyyy").format(trip.dateRange!.end);
    return Scaffold(
      appBar: CustomAppBar(),
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        onPressed: () {
          DateTime current = DateFormat("dd/MM/yyyy").parse(currentDate);
          DateTime start = DateFormat("dd/MM/yyyy").parse(startDate);

          if (current.isBefore(start)) {
            showHelp(context, 'Failed', 'Trip not yet started');
          } else {
            context
                .read<TripMainBloc>()
                .add(UpdateTripStatusEvent(trip.id, DateTime.now(), 0));
            Get.offAll(() => HomeScreen(index: 2));
          }
        },
        label: Text('Mark Trip as Completed'),
        icon: Icon(Icons.check_circle),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade50, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.place_rounded,
                              size: 20, color: Colors.blue),
                          SizedBox(width: 10),
                          Text(
                            trip.place,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ))
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(
                          thickness: 1,
                          color: Colors.grey[300]), // Light separator
                      SizedBox(height: 10),
                      _buildDetailRow(Icons.calendar_today, "Dates",
                          "$startDate  -  $endDate"),
                      if (trip.budget != null && trip.budget!.isNotEmpty)
                        _buildDetailRow(
                            Icons.attach_money, "Budget", "\$${trip.budget}"),
                      _buildDetailRow(
                          Icons.directions_car, "Travel Type", trip.travelType),
                      _buildDetailRow(
                          Icons.people, "People", "${trip.peopleCount}"),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              buildSectionTitle('Plan your trip'),
              SizedBox(height: 10),
              SizedBox(
                height:
                    MediaQuery.sizeOf(context).height * 0.50, // Reduced height
                child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.1, // Makes cards smaller
                  children: [
                    _buildCard(
                        Icons.attach_money,
                        'Expenses',
                        () => Get.to(
                            () => TripExpensesScreen(tripId: '${trip.id}'))),
                    _buildCard(
                        Icons.backpack_outlined,
                        'Items',
                        () => Get.to(() => TripItemsScreen(
                              tripId: '${trip.id}',
                            ))),
                    _buildCard(
                        Icons.note_add_outlined,
                        'Notes',
                        () => Get.to(() => TripNotesScreen(
                              tripId: '${trip.id}',
                            ))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, VoidCallback onTap) {
    return SizedBox(
      width: 120,
      height: 80,
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.blue), // Reduced icon size
              SizedBox(height: 5),
              Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500)), // Smaller text
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
