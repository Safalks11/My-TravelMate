import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget buildCachedNetworkImage(String url) {
  return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => ClipRRect(
            borderRadius:
                BorderRadius.circular(10), // Adjust the radius as needed
            child: Image(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            child: SizedBox(
              width: 30, // Adjust size as needed
              height: 30,
              child: CircularProgressIndicator(
                  value: downloadProgress.progress, strokeWidth: 2),
            ),
          ),
      errorWidget: (context, url, error) => ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Colors.grey[300],
              child: Icon(Icons.error, size: 50),
            ),
          ));
}
