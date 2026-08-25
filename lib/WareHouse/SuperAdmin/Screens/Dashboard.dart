import 'package:charity/Login/Login.dart';
import 'package:charity/WareHouse/SuperAdmin/Controller/DonorRequestController.dart';
import 'package:charity/WareHouse/SuperAdmin/Screens/AddAdmin.dart';
import 'package:charity/WareHouse/SuperAdmin/Screens/AddStock.dart';
import 'package:charity/WareHouse/SuperAdmin/Screens/AddWarehouse.dart';
import 'package:charity/WareHouse/SuperAdmin/Screens/AddZone.dart';
import 'package:charity/WareHouse/SuperAdmin/Screens/DoneeRequest.dart';
import 'package:charity/WareHouse/SuperAdmin/Screens/DonorDonation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuperAdminDashboard extends StatelessWidget {
  SuperAdminDashboard({super.key});

  final controller = Get.put(WareHouseDonorRequestController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Super Admin Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF0F8F7A),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
            onPressed: () {
              Get.offAll(() => LoginScreen());
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                // stockCard("Male Child", 1240),
                // stockCard("Female Child", 980),
                stockCard("Men", 2150),
                stockCard("Women", 1890),
              ],
            ),

            const SizedBox(height: 20),

            /// QUICK ACTIONS
            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            quickActionTile(
              icon: Icons.inventory_2,
              title: "Manage Donee Requests",
              onTap: () {
                Get.to(ManageDoneeRequests());
              },
            ),

            quickActionTile(
              icon: Icons.volunteer_activism,
              title: "Manage Donor Donations",
              onTap: () {
                Get.to(DonorDonationsScreen());
              },
            ),

            quickActionTile(
              icon: Icons.location_on,
              title: "Add Zone",
              onTap: () {
                Get.to(AddZoneScreen());
              },
            ),

            quickActionTile(
              icon: Icons.warehouse,
              title: "Add Warehouse",
              onTap: () {
                Get.to(AddWarehouseScreen());
              },
            ),

            quickActionTile(
              icon: Icons.warehouse,
              title: "Register New Admin",
              onTap: () {
                Get.to(AddAdminScreen());
              },
            ),

            const SizedBox(height: 20),

            /// ADD STOCK BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Color(0xFF0F8F7A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Get.to(AddStockScreen());
              },
              child: const Text(
                "Add Stock",
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 10),

            /// VIEW STOCK BUTTON
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: const Text("See Available Stock"),
            ),
          ],
        ),
      ),

      /// BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.redAccent,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Stock"),

          BottomNavigationBarItem(
            icon: Icon(Icons.sync_alt),
            label: "Coordination",
          ),

          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        ],
        onTap: (index) {},
      ),
    );
  }

  /// STOCK CARD
  Widget stockCard(String title, int count) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$count",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(title),
          ],
        ),
      ),
    );
  }

  /// QUICK ACTION TILE
  Widget quickActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red.shade50,
          child: Icon(icon, color: Colors.redAccent),
        ),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
