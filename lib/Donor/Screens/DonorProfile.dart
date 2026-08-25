import 'package:charity/Donor/Controller/DonationController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Donorprofile extends StatelessWidget {
  Donorprofile({super.key});

  final Pcontroller = Get.put(DonorRequestController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("My Profile", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF0F8F7A),
      ),

      body: Obx(() {
        if (Pcontroller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 👤 Profile Icon
              CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFF0F8F7A),
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),

              SizedBox(height: 20),

              // 📦 Card Box
              Container(
                width: double.infinity,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      "Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      Pcontroller.name.value,
                      style: TextStyle(fontSize: 18),
                    ),

                    SizedBox(height: 15),

                    // Email
                    Text(
                      "Email",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      Pcontroller.email.value,
                      style: TextStyle(fontSize: 18),
                    ),

                    SizedBox(height: 15),

                    // Phone
                    Text(
                      "Phone",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      Pcontroller.phone.value,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
