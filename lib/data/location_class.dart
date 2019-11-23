import 'dart:ffi';

class LocationClass{
  int _id;
  int _idList;
  String _title;
  double _latitude;
  double _longitude;
  String _description;

  LocationClass(this._title, this._latitude, this._longitude, [this._description]);

  LocationClass.withId(this._id, this._title, this._latitude, this._longitude, [this._description]);

  int get id => _id;

  int get idList => _idList;

  String get title => _title;

  double get latitude => _latitude;

  double get longitude => _longitude;
  
  String get description => _description;

  set idList(int newList){

    this._idList = newList;
  }

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
      map['id_location'] = _id;
    }
    map['id_list'] = _idList;
    map['title'] = _title;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['description'] = _description;

    return map;
  }

  LocationClass.fromMapObject(Map<String, dynamic> map){
    this._id = map['id_location'];
    this._idList = map['id_list'];
    this._title = map['title'];
    this._latitude = map['latitude'];
    this._longitude = map['longitude'];
    this._description = map['description'];
  }

}