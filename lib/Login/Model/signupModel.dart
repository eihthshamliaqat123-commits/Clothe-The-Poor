class UserModel {
  String name;
  String email;
  String password;
  String phoneNo;
  int roleId;
  double latitude;
  double longitude;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNo,
    required this.roleId,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      "Name": name,
      "Email": email,
      "Password": password,
      "PhoneNo": phoneNo,
      "RoleId": roleId,
      "Latitude": latitude,
      "Longitude": longitude,
    };
  }
}
