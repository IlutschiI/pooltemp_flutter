class Sensor {
  String id;
  String name;


  Sensor({required this.id, required this.name});

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(id: json['id'], name: json['name']);
  }
}