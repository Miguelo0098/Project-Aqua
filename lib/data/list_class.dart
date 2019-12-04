class ListClass {
  int _id;
  String _title;
  int _active;
  String _description;


  ListClass(this._title, this._active ,[this._description]);

  ListClass.withId(this._id, this._title, this._active, [this._description]);

  int get id => _id;

  String get title => _title;
  
  int get active => _active;

  String get description => _description;

  set title(String newTitle){
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set active(int newActive){
    this._active = newActive;
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
    map['active'] = _active;
    map['description'] = _description;

    return map;
  }

  ListClass.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._title = map['title'];
    this._active = map['active'];
    this._description = map['description'];
  }
}