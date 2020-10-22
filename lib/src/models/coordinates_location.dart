class CoordinatesLocation {
  double latitude;
  double longitude;

  CoordinatesLocation({this.latitude, this.longitude});

  factory CoordinatesLocation.fromJson(Map<String, dynamic> json) =>
      CoordinatesLocation(
        latitude: (json["latitude"] == null) ? true : json["latitude"],
        longitude: (json["longitude"] == null) ? "" : json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude
      };
}
