import 'package:charity/WareHouse/AdminWarehouse/Controller/WarehouseAdminCont.dart';
import 'package:charity/WareHouse/AdminWarehouse/Models/RegisterWoker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterWorkerScreen extends StatelessWidget {
  final controller = Get.put(AdminWarehouseController());

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final salaryController = TextEditingController();

  RegisterWorkerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text(
          "Register Worker",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF0F8F7A),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),

            child: Column(
              children: [
                /// NAME
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                /// EMAIL
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                /// PHONE
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                /// PASSWORD
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                TextField(
                  controller: salaryController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Monthly Salary",
                    prefixText: "Rs ",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                /// ROLE DROPDOWN
                Obx(
                  () => DropdownButtonFormField<int>(
                    value: controller.selectedRoleId.value,
                    items: controller.roles.map((role) {
                      return DropdownMenuItem<int>(
                        value: role["id"] as int,
                        child: Text(role["name"].toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.selectedRoleId.value = value!;
                    },
                    decoration: InputDecoration(
                      labelText: "Select Role",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 25),

                /// BUTTON
                Obx(
                  () => controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0F8F7A),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            int adminId = await controller.getAdminId();

                            RegisterWorkerModel model = RegisterWorkerModel(
                              adminId: adminId,
                              name: nameController.text.trim(),
                              email: emailController.text.trim(),
                              phone: phoneController.text.trim(),
                              password: passwordController.text.trim(),
                              roleId: controller.selectedRoleId.value,
                              salary: double.parse(salaryController.text),
                              bonus: 0,
                            );

                            controller.registerWorker(model);
                          },
                          child: const Text(
                            "Register Worker",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
