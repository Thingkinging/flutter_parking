class Park {
  final String parking_name;
  final String parking_code;
  final double lat;
  final double lng;

  Park({
    required this.parking_name,
    required this.parking_code,
    required this.lat,
    required this.lng,
  });

  Park.fromJson(Map<String, dynamic> json)
    : parking_name = json['PARKING_NAME'],
    parking_code = json['PARKING_CODE'],
    lat = json['LAT'],
    lng = json['LNG'];

  Map<String, dynamic> toJson() => {
    'PARKING_NAME' : parking_name,
    'PARKING_CODE' : parking_code,
    'LAT' : lat,
    'LNG' : lng
  };
}
