import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:main_project/model/places&hotels_model.dart';
import 'package:main_project/model/trips_model.dart';
import 'package:main_project/view/home/home_screen.dart';
import 'package:main_project/view/trip_planner/add_trip/add_trip_bloc.dart';
import 'package:main_project/widgets/app_bar.dart';
import 'package:main_project/widgets/error_snackbar.dart';
import 'package:main_project/widgets/help_snackbar.dart';
import 'package:main_project/widgets/success_snackbar.dart';

import '../../widgets/section_title.dart';
import '../../widgets/traveltype_widget.dart';

class TripDetailsScreen extends StatefulWidget {
  final DateTimeRange? dateRange;
  final String? place;

  const TripDetailsScreen({super.key, this.dateRange, this.place});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  final TextEditingController _budgetController = TextEditingController();
  String? _selectedGroup;
  int _number = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildSectionTitle('Add Trip Details'),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TravelTypeWidget(
                    text: "Solo",
                    icon: Icons.person,
                    isSelected: _selectedGroup == "Solo",
                    onTap: () {
                      setState(() {
                        _selectedGroup = "Solo";
                        _number = 1;
                      });
                    },
                  ),
                  TravelTypeWidget(
                    text: "Couple",
                    icon: Icons.group,
                    isSelected: _selectedGroup == "Couple",
                    onTap: () {
                      setState(() {
                        _selectedGroup = "Couple";
                        _number = 2;
                      });
                    },
                  ),
                  TravelTypeWidget(
                    text: "Family",
                    icon: Icons.family_restroom,
                    isSelected: _selectedGroup == "Family",
                    onTap: () {
                      setState(() {
                        _selectedGroup = "Family";
                      });
                    },
                  ),
                  TravelTypeWidget(
                    text: "Friends",
                    icon: Icons.groups_sharp,
                    isSelected: _selectedGroup == "Friends",
                    onTap: () {
                      setState(() {
                        _selectedGroup = "Friends";
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _selectedGroup == "Family" || _selectedGroup == "Friends"
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        width: double.infinity,
                        height: MediaQuery.sizeOf(context).height * 0.05,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (_number > 2) {
                                    _number--;
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.horizontal_rule,
                                color:
                                    _number == 2 ? Colors.grey : Colors.black,
                              ),
                            ),
                            Text(
                              "${_number.toString()} People",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              tooltip: "Add people",
                              onPressed: () {
                                setState(() {
                                  _number++;
                                });
                              },
                              icon: const Icon(Icons.add),
                            )
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Budget',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 30),
              BlocListener<AddTripBloc, AddTripState>(
                listener: (context, state) {
                  if (state is TripSubmissionSuccess) {
                    Get.offAll(() => HomeScreen(index: 2));
                    showSuccess(context, "Success", "Trip added successfully!");
                  } else if (state is TripSubmissionFailure) {
                    showError(context, "Error", state.error);
                  }
                },
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.green),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                  ),
                  onPressed: () {
                    if (_selectedGroup == null) {
                      showHelp(context, "Error",
                          "Please select a place and date range.");

                      return;
                    }

                    final String placeName = widget.place ?? '';
                    final DateTimeRange dateRange = widget.dateRange!;

                    BlocProvider.of<AddTripBloc>(context).add(SubmitTripEvent(
                      trip: GetTrips(
                        place: placeName,
                        dateRange: dateRange,
                        travelType: '$_selectedGroup',
                        peopleCount: _number,
                        budget: _budgetController.text.isNotEmpty
                            ? _budgetController.text
                            : null,
                        tripStatus: 1,
                        id: '',
                      ),
                    ));
                  },
                  label: Text("Done"),
                  icon: Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
