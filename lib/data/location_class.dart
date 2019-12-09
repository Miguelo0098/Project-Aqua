import 'dart:convert';

class LocationClass{
  int _id;
  String _title;
  double _latitude;
  double _longitude;
  String _description;

  LocationClass(this._title, this._latitude, this._longitude, [this._description]);

  LocationClass.withId(this._id, this._title, this._latitude, this._longitude, [this._description]);

  int get id => _id;

  String get title => _title;

  double get latitude => _latitude;

  double get longitude => _longitude;
  
  String get description => _description;

  set title(String newTitle){
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set latitude(double newLat){
    if (newLat <= 90 && newLat >= -90) {
      this._latitude = newLat;
    }
  }

  set longitude(double newLong){
    if (newLong <= 180 && newLong >= -180) {
      this._longitude = newLong;
    }
  }

  set description(String newDesc){
    if (newDesc.length <= 255) {
      this._description = newDesc;
    }
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['description'] = _description;

    return map;
  }

  LocationClass.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._title = map['title'];
    this._latitude = map['latitude'];
    this._longitude = map['longitude'];
    this._description = map['description'];
  }

  LocationClass.fromJson(String jsonString){
    Map<String, dynamic> map = jsonDecode(jsonString);
    this._id = map['id'];
    this._title = map['title'];
    this._latitude = map['latitude'];
    this._longitude = map['longitude'];
    this._description = map['description'];
  }

  String toJson(){
    Map<String, dynamic> map = this.toMap();
    return jsonEncode(map);
  }

}