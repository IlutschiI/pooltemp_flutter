class Sensor {
  String id;
  String name;


  Sensor({this.id, this.name});

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(id: json['id'], name: json['name']);
  }
}