class ClinicProfile {
  int _id;
  String _name;
  String _description;

  ClinicProfile(this._id, this._name, this._description);

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  static ClinicProfile convert(dynamic data) {
    ClinicProfile clinicProfile;
    Map<String, dynamic> hash = data;

    clinicProfile = ClinicProfile(
      hash["id"],
      hash["description"],
      hash["description"],
    );

    return clinicProfile;
  }

}