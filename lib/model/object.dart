class ObjectLocation {
  final String name;
  final int id;

  // TO-DO
  // add item count

  ObjectLocation(this.name, this.id);
  factory ObjectLocation.fromJson(dynamic json) {
    return ObjectLocation(json['name'] as String, json['id'] as int);
  }

  @override
  String toString() {
    return '{ ${this.name}, ${this.id} }';
  }
}

class Object {
  final String name;
  final int id;
  final int locationId;

  Object(this.name, this.id, this.locationId);
}