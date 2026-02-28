class DeviceModel {
  String? uuid;
  String? name;
  String model;
  String version;
  String? token;
  String type;
  bool? used;

  DeviceModel({
    this.uuid,
    this.name,
    required this.model,
    required this.version,
    this.token,
    required this.type,
    this.used,
  });
  Map<String, dynamic> toJson() {
    return {
      "uuid": uuid,
      "name": name,
      "model": model,
      "version": version,
      "token": token,
      "type": type,
    };
  }
}
