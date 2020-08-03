class Speciality {

  int _id;
  String _name;
  String _description;
  bool _priv;


  Speciality(this._id, this._name, this._description, this._priv);


  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  bool get priv => _priv;

  set priv(bool value) {
    _priv = value;
  }

  static List<Speciality> convertList(dynamic data) {
    List<Speciality> medicProfileList = List();

    for (Map<String, dynamic> hash in data) {
      Speciality speciality = Speciality(
          hash["id"],
          hash["name"],
          hash["description"],
          hash["priv"]);
      medicProfileList.add(speciality);
    }

    return medicProfileList;
  }

  static Speciality convert(dynamic hash) {
    Speciality speciality;

    speciality = Speciality(
        hash["id"],
        hash["name"],
        hash["description"],
        hash["priv"]);

    return speciality;
  }

}