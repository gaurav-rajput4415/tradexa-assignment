class Movie {
  final String id;
  final String image;
  final String imDbRating;
  final String title;

  Movie({this.id, this.title, this.image, this.imDbRating});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json["id"],
        image: json["image"],
      title: json["title"],
      imDbRating: json["imDbRating"]
    );
  }
}