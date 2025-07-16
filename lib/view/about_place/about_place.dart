import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_project/model/places&hotels_model.dart';
import 'package:main_project/view/about_place/widgets_about.dart';
import 'package:main_project/view/hotels_list/hotels_list_screen.dart';
import 'package:main_project/widgets/app_bar.dart';
import 'package:main_project/widgets/background_container.dart';
import 'package:main_project/widgets/coming_soon_dialog.dart';

class AboutPlacesScreen extends StatefulWidget {
  final GetPlace place;
  final List<GetHotel> hotels;
  const AboutPlacesScreen(
      {super.key, required this.place, required this.hotels});

  @override
  State<AboutPlacesScreen> createState() => _AboutPlacesScreenState();
}

class _AboutPlacesScreenState extends State<AboutPlacesScreen> {
  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          actions: [
            IconButton(
                onPressed: () {
                  showComingSoonDialog();
                },
                icon: Icon(Icons.favorite_border)),
            IconButton(
              onPressed: () {
                showComingSoonDialog();
              },
              icon: const Icon(Icons.share_outlined, size: 25),
            ),
            const SizedBox(width: 15),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildHeader(place),
              buildDescription(place),
              buildImage(place),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                showComingSoonDialog();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.red[300]),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
              label: const Text(
                "Get direction",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              icon: Icon(
                Icons.map,
                color: Colors.blue,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
