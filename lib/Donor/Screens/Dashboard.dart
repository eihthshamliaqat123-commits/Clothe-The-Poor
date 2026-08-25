import 'package:charity/Donor/Controller/DonationController.dart';
import 'package:charity/Donor/Screens/AddDonation.dart';
import 'package:charity/Donor/Screens/DonationHistory.dart';
import 'package:charity/Donor/Screens/DonorProfile.dart';
import 'package:charity/Donor/Screens/SupportConversationScreen.dart';
import 'package:charity/Login/Login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DonorDashboard extends StatelessWidget {
  DonorDashboard({super.key});

  final DDcontroller = Get.put(DonorRequestController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        title: const Text("Dashboard", style: TextStyle(color: Colors.white)),

        backgroundColor: const Color(0xFF0F8F7A),

        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),

            onPressed: () {
              Get.offAll(() => LoginScreen());
            },
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,

        type: BottomNavigationBarType.fixed,

        selectedItemColor: const Color(0xFF0F8F7A),

        unselectedItemColor: Colors.grey,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),

          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent),
            label: "Support",
          ),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],

        onTap: (index) {
          if (index == 1) {
            Get.to(() => DonorHistoryScreen());
          }

          if (index == 2) {
            Get.to(() => SupportConversationsScreen());
          }

          if (index == 3) {
            Get.to(() => Donorprofile());
          }
        },
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F8F7A),

                    foregroundColor: Colors.white,

                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),

                  onPressed: () async {
                    final result = await Navigator.push(
                      context,

                      MaterialPageRoute(builder: (_) => AddDonationScreen()),
                    );

                    if (result == true) {
                      DDcontroller.fetchMyPendingRequests();
                    }
                  },

                  icon: const Icon(Icons.add),

                  label: const Text(
                    "Add Donation",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Pending Requests",

                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Obx(() {
                if (DDcontroller.pendingRequests.isEmpty) {
                  return Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),

                      color: Colors.grey.shade200,
                    ),

                    child: const Center(
                      child: Text(
                        "No pending requests",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,

                  physics: const NeverScrollableScrollPhysics(),

                  itemCount: DDcontroller.pendingRequests.length,

                  itemBuilder: (context, index) {
                    var req = DDcontroller.pendingRequests[index];

                    DateTime time = req["time"];

                    return Card(
                      elevation: 3,

                      margin: const EdgeInsets.only(bottom: 12),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),

                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF0F8F7A),

                          child: const Icon(
                            Icons.volunteer_activism,
                            color: Colors.white,
                          ),
                        ),

                        title: Text(
                          req["comments"],

                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5),

                          child: Text(
                            "${time.day}-${time.month}-${time.year}   ${time.hour}:${time.minute}",
                          ),
                        ),

                        trailing: const Icon(
                          Icons.timer,
                          color: Color(0xFF0F8F7A),
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
