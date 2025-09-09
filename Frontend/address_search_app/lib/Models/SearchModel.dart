class Searchmodel {
  final String displayName;
  final String lat;
  final String lon;

  Searchmodel({
    required this.displayName,
    required this.lat,
    required this.lon,
  });

  factory Searchmodel.fromJson(Map<String, dynamic> json) {
    return Searchmodel(
      displayName: json['display_name'] ?? '',
      lat: json['lat'].toString(),
      lon: json['lon'].toString(),
    );
  }
}
