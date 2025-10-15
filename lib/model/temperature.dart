class Temperature {
  final int? id;
  final DateTime time;
  final String sensorID;
  double temperature;

  Temperature({this.id, required this.sensorID, required this.time, required this.temperature});

  factory Temperature.fromJson(Map<String, dynamic> json) {
    return Temperature(id: json['id'], sensorID: json['sensorID'], time: DateTime.fromMillisecondsSinceEpoch(json['time']), temperature: json['temperature']);
  }
}