import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:main_project/model/trips_model.dart';
import 'package:main_project/view/about_place/about_place.dart';
import 'package:main_project/view/ai_trip_plan/ai_trip_plan_screen.dart';
import 'package:main_project/view/chatbot_screen/chatbot_screen.dart';
import 'package:main_project/view/home/home_bloc.dart';
import 'package:main_project/view/hotels_list/hotels_list_screen.dart';
import 'package:main_project/view/trip_planner/add_trip/add_trip_screen.dart';
import 'package:main_project/widgets/app_bar.dart';
import 'package:main_project/widgets/drawer/drawer_view.dart';

import '../../constants/home_utilities.dart';
import '../../model/places&hotels_model.dart';
import '../../widgets/background_container.dart';
import '../../widgets/bottomnavbar.dart';
import '../../widgets/cachednetworkimg.dart';
import '../../widgets/coming_soon_dialog.dart';
import '../../widgets/section_title.dart';
import '../trip_planner/trip_main_screen/trip_plan_mainscreen.dart';

class HomeScreen extends StatefulWidget {
  final int index;

  const HomeScreen({super.key, required this.index});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late int currentIndex;
  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque, // Ensures taps register anywhere
        onTap: () {
          FocusScope.of(context)
              .unfocus(); // Dismiss keyboard when tapping outside
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            showDrawer: true,
            title: currentIndex == 2
                ? Text(
                    'Your Trips',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                : currentIndex == 3
                    ? Text(
                        'AI Trip Planner',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    : SizedBox.shrink(),
            actions: [
              IconButton.outlined(
                onPressed: () {
                  showComingSoonDialog();
                },
                icon: Icon(Icons.sos_rounded),
                color: Colors.red,
              ),
              IconButton.outlined(
                  onPressed: () {
                    Get.to(() => TravelChatBotScreen());
                  },
                  icon: Icon(Icons.support_agent))
            ],
          ),
          drawer: CustomDrawer(),
          floatingActionButton: currentIndex == 2
              ? FloatingActionButton(
                  backgroundColor: Colors.blue.shade400,
                  onPressed: () {
                    Get.to(() => AddTripScreen());
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                )
              : currentIndex == 3
                  ? FloatingActionButton(
                      backgroundColor: Colors.blueAccent.shade100,
                      onPressed: () {
                        showAITripBottomSheet(context);
                      },
                      child: Icon(Icons.add),
                    )
                  : SizedBox.shrink(),
          body: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
            List<GetPlace> places = [];
            List<GetHotel> hotels = [];
            List<GetTrips> trips = [];
            if (state is HomeLoaded) {
              places = state.places;
              hotels = state.hotels;
              trips = state.trips;
            }

            return IndexedStack(
              index: currentIndex,
              children: [
                _HomeContent(places: places, hotels: hotels),
                HotelsListScreen(hotels: hotels),
                TripPlannerScreen(trips: trips),
                AiTripPlanScreen(),
              ],
            );
          }),
          bottomNavigationBar: BottomNavBar(
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index; // Directly updating the index
              });
            },
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  final List<GetPlace> places;
  final List<GetHotel> hotels;

  const _HomeContent({required this.places, required this.hotels});

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();
  List<GetPlace> _searchResults = [];
  int _placesToShow = 6;

  void _performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _searchResults.clear();
      } else {
        _searchResults = widget.places
            .where((place) =>
                place.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose(); // Dispose the focus node
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<GetPlace> sortedPlaces = List.from(widget.places);
    sortedPlaces.sort((a, b) => b.rating.compareTo(a.rating));
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildSectionTitle('Explore'),
          const SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.9,
            height: 50,
            child: SearchBar(
              backgroundColor: WidgetStateProperty.all(Colors.blueGrey[50]),
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (query) {
                _performSearch(query);
              },
              padding: WidgetStateProperty.all(const EdgeInsets.only(left: 10)),
              hintText: "Search Destination",
              hintStyle: WidgetStateProperty.all(const TextStyle(fontSize: 20)),
              trailing: [
                IconButton.filled(
                  highlightColor: Colors.black38,
                  iconSize: 30,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.amber[600]),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                  color: Colors.black,
                ),
                const SizedBox(width: 3.5),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _searchResults.isNotEmpty
              ? ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 100, // Limit the height of the search results
                  ),
                  child: Scrollbar(
                    controller: _scrollController,
                    thickness: 5,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final result = _searchResults[index];
                        return ListTile(
                          title: Text(result.title),
                          onTap: () {
                            _searchFocusNode.unfocus();
                          },
                        );
                      },
                    ),
                  ),
                )
              : SizedBox.shrink(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              4,
              (index) => Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: HomeData.catColors[index],
                    ),
                    width: 70,
                    height: 65,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        HomeData.category[index],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(HomeData.catName[index]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          buildSectionTitle('Popular Places'),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5),
            child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: sortedPlaces.length > 3 ? 3 : sortedPlaces.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 180,
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  final place = sortedPlaces[index];
                  return GestureDetector(
                    onTap: () {
                      _searchFocusNode.unfocus();
                      Get.to(() => AboutPlacesScreen(
                          place: place, hotels: widget.hotels));
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
                                color: HomeData.gridItemColors[
                                    index % HomeData.gridItemColors.length],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              height: 35,
                              width: double.infinity,
                              child: Center(child: Text(place.title)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          SizedBox(height: 20),
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
                itemCount: _placesToShow > widget.places.length
                    ? widget.places.length
                    : _placesToShow,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 180,
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  final place = widget.places[index];

                  return GestureDetector(
                    onTap: () {
                      _searchFocusNode.unfocus();
                      Get.to(() => AboutPlacesScreen(
                          place: place, hotels: widget.hotels));
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
          if (_placesToShow < sortedPlaces.length)
            TextButton(
              onPressed: () {
                setState(() {
                  _placesToShow += 5; // Load the next 5 places
                });
              },
              child: Text("View More"),
            ),
        ],
      ),
    );
  }
}
