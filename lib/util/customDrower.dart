import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testproject/ui/blocApiCalling/view/prodcutScreen.dart';
import 'package:testproject/ui/homeScreen/view/homePage.dart';
import 'package:testproject/ui/pdfScanner/view/pdfScannerScreen.dart';
import 'package:testproject/ui/product/view/productList.dart';
// તમારા ઈમ્પોર્ટસ અહિયાં ચાલુ રાખજો...

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.80,
      backgroundColor: Colors.transparent,
      child: Container(
        // આ કલર કાળો નથી, પણ ખૂબ જ ઘેરો બ્લુ (Midnight Blue) છે
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F2027), // Dark Navy
              Color(0xFF203A43), // Slate Blue
              Color(0xFF2C5364), // Deep Sea
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 5,
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: Stack(
            children: [
              // હળવો ગ્લાસ ઇફેક્ટ
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.white.withOpacity(0.02)),
              ),

              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(), // Profile Header
                      SizedBox(height: 40),

                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "EXPLORE",
                          style: TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2),
                        ),
                      ),
                      SizedBox(height: 15),

                      _menuItem(
                        icon: Icons.grid_view_rounded,
                        title: "Dashboard",
                        onTap: () => Get.to(() => HomeScreen()),
                      ),
                      _menuItem(
                        icon: Icons.shopping_bag_outlined,
                        title: "Products",
                        onTap: () => Get.to(() => ProductScreen()),
                      ),
                      _menuItem(
                        icon: Icons.document_scanner_outlined,
                        title: "Scan Documents",
                        onTap: () => Get.to(() => PdfScannerScreen()),
                      ),
                      _menuItem(
                        icon: Icons.document_scanner_outlined,
                        title: "Bloc ApiCalling",
                        onTap: () => Get.to(() => BlocProductScreen()),
                      ),

                      Spacer(),

                      // Logout with a soft glow background
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: _menuItem(
                          icon: Icons.power_settings_new_rounded,
                          title: "Sign Out",
                          iconColor: Colors.redAccent,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: Colors.cyanAccent.withOpacity(0.5), width: 1.5),
          ),
          child: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
                'https://via.placeholder.com/150'), // તમારી ઈમેજ અહિયાં
          ),
        ),
        SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ansh Bhalala",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 0.5),
            ),
            Text(
              "Pro Developer",
              style: TextStyle(color: Colors.cyanAccent, fontSize: 13),
            ),
          ],
        )
      ],
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = Colors.white70,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.white24, size: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    );
  }
}
