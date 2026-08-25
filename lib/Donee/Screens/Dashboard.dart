import 'package:charity/Donee/Screens/Behalf.dart';
import 'package:charity/Donee/Screens/History.dart';
import 'package:charity/Donee/Screens/NGO.dart';
import 'package:charity/Donee/Screens/Self.dart';
import 'package:charity/Login/Login.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class DoneeDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF4F6F6,
      ), // Soft grey background background color
      appBar: AppBar(
        title: const Text(
          "Donee Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: const Color(0xFF0F8F7A),
        elevation: 2,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            onPressed: () {
              Get.offAll(() => LoginScreen());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            const Text(
              "Welcome Back 👋",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Select an option below to manage requests.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 28),

            // Navigation Cards
            button(
              context,
              "NGO Request",
              2,
              Icons.corporate_fare_rounded,
              "Request donation on behalf of an organization",
            ),
            button(
              context,
              "Behalf Request",
              3,
              Icons.supervised_user_circle_rounded,
              "Create a request for someone else",
            ),
            button(
              context,
              "Self Request",
              1,
              Icons.person_rounded,
              "Submit a personal clothing request",
            ),
            button(
              context,
              "View History",
              4,
              Icons.history_rounded,
              "Check your past requests and status",
            ),
          ],
        ),
      ),
    );
  }

  Widget button(
    BuildContext context,
    String title,
    int type,
    IconData icon,
    String subtitle,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (type == 1) {
              Get.to(() => SelfRequestScreen());
            } else if (type == 2) {
              Get.to(() => NGORequestScreen());
            } else if (type == 3) {
              Get.to(() => BehalfRequestScreen());
            } else {
              Get.to(DoneeHistoryScreen());
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 16.0,
            ),
            child: Row(
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F8F7A).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: const Color(0xFF0F8F7A), size: 28),
                ),
                const SizedBox(width: 16),

                // Text Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Trailing Arrow
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
