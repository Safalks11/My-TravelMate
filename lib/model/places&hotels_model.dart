class GetHotel {
  String description;
  int id;
  String image;
  String location;
  String price;
  String profile;
  double rating;
  String subtitle;
  String title;

  GetHotel({
    required this.description,
    required this.id,
    required this.image,
    required this.location,
    required this.price,
    required this.profile,
    required this.rating,
    required this.subtitle,
    required this.title,
  });

  factory GetHotel.fromJson(Map<String, dynamic> json) => GetHotel(
        description: json["description"],
        id: json["id"],
        image: json["image"],
        location: json["location"],
        price: json["price"],
        profile: json["profile"],
        rating: json["rating"]?.toDouble(),
        subtitle: json["subtitle"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "id": id,
        "image": image,
        "location": location,
        "price": price,
        "profile": profile,
        "rating": rating,
        "subtitle": subtitle,
        "title": title,
      };
}

class GetPlace {
  String description;
  int id;
  String image;
  String name;
  String profile;
  double rating;
  String title;

  GetPlace({
    required this.description,
    required this.id,
    required this.image,
    required this.name,
    required this.profile,
    required this.rating,
    required this.title,
  });

  factory GetPlace.fromJson(Map<String, dynamic> json) => GetPlace(
        description: json["description"],
        id: json["id"],
        image: json["image"],
        name: json["name"],
        profile: json["profile"],
        rating: json["rating"]?.toDouble(),
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "id": id,
        "image": image,
        "name": name,
        "profile": profile,
        "rating": rating,
        "title": title,
      };
}
