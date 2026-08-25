class RegisterWorkerModel {
  int adminId;
  String name;
  String email;
  String phone;
  String password;
  int roleId;
  double salary;

  double bonus;

  RegisterWorkerModel({
    required this.adminId,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.roleId,
    required this.salary,
    required this.bonus,
  });

  Map<String, dynamic> toJson() {
    return {
      "adminId": adminId,
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
      "roleId": roleId,
      "Salary": salary,
      "Bonus": bonus,
    };
  }
}
