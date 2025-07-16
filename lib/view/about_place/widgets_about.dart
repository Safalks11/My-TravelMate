import 'package:flutter/material.dart';
import 'package:main_project/model/places&hotels_model.dart';
import 'package:readmore/readmore.dart';

import '../../widgets/cachednetworkimg.dart';
import '../../widgets/rating_icons.dart';

Widget buildHeader(GetPlace place) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          SizedBox(
            width: 190,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${place.title} -"
                    " ${place.name}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: buildRatingIcons(place.rating),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 70,
            child: VerticalDivider(
              thickness: 2,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 110,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(place.profile),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildDescription(GetPlace place) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "About",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 15),
          ReadMoreText(
            place.description.replaceAll(r'\n', '\n'),
            textAlign: TextAlign.left,
            trimMode: TrimMode.Line,
            trimLines: 9,
            trimCollapsedText: "Read more",
            trimExpandedText: "Read less",
            moreStyle: TextStyle(color: Colors.red),
            lessStyle: TextStyle(color: Colors.blue),
          ),
        ],
      ),
    ),
  );
}

Widget buildImage(GetPlace place) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
    child: Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3,
            spreadRadius: 1,
          )
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: buildCachedNetworkImage(place.image),
    ),
  );
}
