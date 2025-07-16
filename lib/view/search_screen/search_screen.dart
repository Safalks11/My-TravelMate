import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/home_utilities.dart';
import '../../data/dummy_data/dummy_data.dart';
import '../../model/places&hotels_model.dart';
import '../../widgets/cachednetworkimg.dart';
import '../../widgets/section_title.dart';

class SearchScreen extends StatefulWidget {
  final List<GetPlace> places;
  const SearchScreen({super.key, required this.places});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    List<GetPlace> places = widget.places;
    List<GetPlace> sortedPlaces = List.from(places);
    sortedPlaces.sort((a, b) => b.rating.compareTo(a.rating));
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.9,
          child: SearchBar(
            backgroundColor: WidgetStateProperty.all(Colors.blueGrey[50]),
            controller: _searchController,
            onChanged: (query) {
              _performSearch(query);
            },
            padding: WidgetStateProperty.all(const EdgeInsets.only(left: 10)),
            hintText: "Search Destination",
            hintStyle: WidgetStateProperty.all(const TextStyle(fontSize: 20)),
            trailing: [
              IconButton.filled(
                highlightColor: Colors.black38,
                iconSize: 32,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.amber[600]),
                ),
                onPressed: () {
                  _performSearch(_searchController.text);
                },
                icon: const Icon(Icons.search),
                color: Colors.black,
              ),
              const SizedBox(width: 3.5),
            ],
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSearchResults(),
                SizedBox(height: 20),
                buildSectionTitle("Popular"),
                SizedBox(height: 10),
                _buildTopRatedPlaces(sortedPlaces),
                SizedBox(height: 5),
                buildSectionTitle("All"),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 12,
                  ),
                  child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: places.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 180,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        final place = places[index];

                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              'details',
                              arguments: {
                                'id': place.id,
                                'color': HomeData.gridItemColors[
                                    index % HomeData.gridItemColors.length],
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Container(
                                  height: 175,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: buildCachedNetworkImage(place.image),
                                ),
                                Positioned(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: HomeData.gridItemColors[index %
                                          HomeData.gridItemColors.length],
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    height: 35,
                                    width: double.infinity,
                                    child: Center(
                                      child: Text(
                                        place.title,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return _searchResults.isNotEmpty
        ? Column(
            children: _searchResults
                .map((result) => ListTile(
                      title: Text(result['title']),
                      onTap: () {
                        Get.toNamed(
                          'details',
                          arguments: {
                            'id': result['id'],
                            'color': HomeData.gridItemColors[
                                result['id'] % HomeData.gridItemColors.length],
                          },
                        );
                      },
                    ))
                .toList(),
          )
        : SizedBox.shrink();
  }

  Widget _buildTopRatedPlaces(List<GetPlace> sortedPlaces) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
      child: SizedBox(
        height: 365,
        child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: sortedPlaces.length > 3 ? 3 : sortedPlaces.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 180,
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              final place = sortedPlaces[index];
              return GestureDetector(
                onTap: () {
                  Get.toNamed(
                    'details',
                    arguments: {
                      'id': place.id,
                      'color': HomeData.gridItemColors[
                          index % HomeData.gridItemColors.length],
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(place.profile),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          decoration: BoxDecoration(
                            color: HomeData.gridItemColors[
                                index % HomeData.gridItemColors.length],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          height: 35,
                          width: double.infinity,
                          child: Center(
                            child: Text(place.title),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  void _performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _searchResults.clear();
      } else {
        _searchResults = details
            .where((detail) =>
                detail['title'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
}
