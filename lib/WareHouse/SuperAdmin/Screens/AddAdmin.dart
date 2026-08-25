import 'package:charity/WareHouse/SuperAdmin/Controller/AdminService.dart';
import 'package:charity/WareHouse/SuperAdmin/Controller/WarehouseController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class AddAdminScreen extends StatefulWidget {
  @override
  State<AddAdminScreen> createState() => _AddAdminScreenState();
}

class _AddAdminScreenState extends State<AddAdminScreen> {
  final controller = Get.put(WarehouseController());
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();

  void submit() async {
    var res = await AdminService.createAdmin(
      name: name.text,
      email: email.text,
      password: password.text,
      phone: phone.text,
      warehouseId: controller.selectedWarehouseId.value,
    );

    if (res['statusCode'] == 200) {
      Get.snackbar("Success", "Admin Created");
      Get.back();
    } else {
      Get.snackbar("Error", res['body']['Message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Admin", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F8F7A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: email,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: password,
              decoration: InputDecoration(labelText: "Password"),
            ),
            TextField(
              controller: phone,
              decoration: InputDecoration(labelText: "Phone"),
            ),

            SizedBox(height: 20),

            // Obx(() {
            //   if (controller.isLoading.value) {
            //     return CircularProgressIndicator();
            //   }

            //   return DropdownButtonFormField<int>(
            //     value: controller.selectedWarehouseId == 0
            //         ? null
            //         : controller.selectedWarehouseId,
            //     hint: Text("Select Warehouse"),
            //     items: controller.warehouses.map((w) {
            //       return DropdownMenuItem<int>(
            //         value: w.id,
            //         child: Text(w.name),
            //       );
            //     }).toList(),
            //     onChanged: (value) {
            //       if (value != null) {
            //         controller.selectWarehouse(value);
            //       }
            //     },
            //   );
            // }),
            Obx(() {
              return DropdownButtonFormField<int>(
                value: controller.selectedWarehouseId.value == 0
                    ? null
                    : controller.selectedWarehouseId.value,

                hint: Text("Select Warehouse"),

                items: controller.warehouses.map((w) {
                  return DropdownMenuItem<int>(
                    value: w.id,
                    child: Text(w.name),
                  );
                }).toList(),

                onChanged: (value) {
                  if (value != null) {
                    controller.selectWarehouse(value);
                  }
                },
              );
            }),

            SizedBox(height: 30),

            ElevatedButton(onPressed: submit, child: Text("Create Admin")),
          ],
        ),
      ),
    );
  }
}
