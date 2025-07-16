import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:main_project/view/home/home_bloc.dart';
import 'package:main_project/view/trip_planner/trip_details_screen.dart';
import 'package:main_project/widgets/app_bar.dart';

import '../../../model/places&hotels_model.dart';
import '../../../widgets/help_snackbar.dart';
import '../../../widgets/section_title.dart';

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({super.key});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  DateTimeRange? selectedDateRange;
  TextEditingController destinationController = TextEditingController();

  String? _selectedPlace;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle('Add Trip'),
            const SizedBox(height: 16),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: 400,
              child: RangeDatePicker(
                enabledCellsTextStyle: TextStyle(fontSize: 16),
                currentDateTextStyle: TextStyle(fontSize: 16),
                disabledCellsTextStyle:
                    TextStyle(fontSize: 15, color: Colors.grey),
                centerLeadingDate: true,
                minDate: DateTime.now(),
                maxDate: DateTime.now().add(Duration(days: 365)),
                onRangeSelected: (value) {
                  setState(() {
                    selectedDateRange = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: destinationController,
                    onChanged: (value) {
                      setState(() {
                        _selectedPlace = value;
                      });
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Destination'),
                  ),
                  // BlocBuilder<HomeBloc, HomeState>(
                  //   builder: (context, state) {
                  //     if (state is HomeLoaded) {
                  //       List<GetPlace> places = state.places;
                  //
                  //       return DropdownButtonFormField<GetPlace>(
                  //         decoration: InputDecoration(
                  //           border: OutlineInputBorder(),
                  //         ),
                  //         value: _selectedPlace,
                  //         hint: Text('Select a Place'),
                  //         isExpanded: true,
                  //         items: places.map((place) {
                  //           return DropdownMenuItem<GetPlace>(
                  //             value: place,
                  //             child: Text(place.title),
                  //           );
                  //         }).toList(),
                  //         onChanged: (GetPlace? newValue) {
                  //           setState(() {
                  //             _selectedPlace = newValue;
                  //           });
                  //         },
                  //       );
                  //     } else if (state is HomeLoading) {
                  //       return CircularProgressIndicator();
                  //     } else {
                  //       return Text('Failed to load places');
                  //     }
                  //   },
                  // ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.blueAccent),
                            foregroundColor:
                                WidgetStatePropertyAll(Colors.white),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)))),
                        onPressed: () {
                          if (selectedDateRange == null ||
                              _selectedPlace == null ||
                              _selectedPlace!.isEmpty) {
                            showHelp(context, "Error",
                                "Please select a place and date range.");
                            return;
                          }
                          Get.to(() => TripDetailsScreen(
                              dateRange: selectedDateRange,
                              place: _selectedPlace));
                        },
                        label: Text("Next"),
                        icon: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
