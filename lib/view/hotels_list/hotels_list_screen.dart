import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_project/data/hotels_data/hotel_dummy_data.dart';

import '../../model/places&hotels_model.dart';
import '../../widgets/cachednetworkimg.dart';
import '../about_hotel/hotel_home_screen.dart';

class HotelsListScreen extends StatefulWidget {
  final List<GetHotel> hotels;
  const HotelsListScreen({super.key, required this.hotels});

  @override
  State<HotelsListScreen> createState() => _HotelsListScreenState();
}

class _HotelsListScreenState extends State<HotelsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    List<GetHotel> hotels = widget.hotels;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "Hotels",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.65,
                height: MediaQuery.sizeOf(context).height * 0.05,
                child: SearchBar(
                  backgroundColor:
                      WidgetStateProperty.all(Colors.lightBlue[50]),
                  controller: _searchController,
                  onChanged: (query) {
                    _performSearch(query);
                  },
                  padding:
                      WidgetStateProperty.all(const EdgeInsets.only(left: 10)),
                  hintText: "Search Hotels",
                  hintStyle:
                      WidgetStateProperty.all(const TextStyle(fontSize: 14)),
                  trailing: [
                    IconButton.filled(
                      highlightColor: Colors.black38,
                      iconSize: 22,
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.amber[600]),
                      ),
                      onPressed: () {
                        _performSearch(_searchController.text);
                      },
                      icon: const Icon(Icons.search),
                      color: Colors.black,
                    ),
                    // const SizedBox(width: 3.5),
                  ],
                ),
              ),
            ),
          ],
        ),
        // _buildSearchResults(),
        SizedBox(height: 20),
        Expanded(
          child: ListView.separated(
            itemCount: _searchResults.isNotEmpty
                ? _searchResults.length
                : hotels.length,
            itemBuilder: (context, index) {
              final hotel = hotels[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => HotelHomeScreen(hotel: hotel));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 150,
                          width: 150,
                          child: buildCachedNetworkImage(
                              _searchResults.isNotEmpty
                                  ? _searchResults[index]['image']
                                  : hotel.image)),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _searchResults.isNotEmpty
                                  ? _searchResults[index]['title']
                                  : hotel.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(hotel.subtitle),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on, size: 16),
                                  Text(_searchResults.isNotEmpty
                                      ? _searchResults[index]['location']
                                      : hotel.location)
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      hotel.rating.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Icon(Icons.star,
                                        size: 15, color: Colors.amber)
                                  ],
                                ),
                                Container(
                                    padding: EdgeInsets.all(8),
                                    color: Colors.red[200],
                                    child: Text(hotel.price))
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => Divider(),
          ),
        )
      ],
    );
  }

  void _performSearch(String query) {
    // Implement your search logic here
    // For example, filter details based on the query
    setState(() {
      if (query.isEmpty) {
        _searchResults.clear(); // Clear the suggestions if the query is empty
      } else {
        _searchResults = hotels
            .where((hotel) =>
                hotel['location'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
}
