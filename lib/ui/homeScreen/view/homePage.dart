import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testproject/service/notificationService.dart';
import 'package:testproject/ui/homeScreen/modal/productModel.dart';
import 'package:testproject/ui/homeScreen/provider/productProvider.dart';
import 'package:testproject/util/const.dart';
import 'package:testproject/util/customButton.dart';
import 'package:testproject/util/customDrower.dart';
import 'package:testproject/util/snackBars.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    DiogetData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          Column(
            children: [
              CustomButton(
                  text: "NOTIFICATIN",
                  onTap: () {
                    NotificationService.showNotification(
                        "Hello from Flutter!", "This is a test notification.");
                  })
            ],
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF8F9FD), // Very light blue-grey
                  Color(0xFFE0EAFC), // Soft silver-blue
                ],
              ),
            ),
          ),
          Positioned(
            top: -100,
            right: -50,
            child: _buildBlob(300, Colors.purpleAccent.withOpacity(0.2)),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: _buildBlob(250, Colors.blueAccent.withOpacity(0.2)),
          ),
          Positioned(
            top: 250,
            left: 20,
            child: _buildBlob(150, Colors.orangeAccent.withOpacity(0.15)),
          ),
          Container(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Bar Area
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.menu, color: Colors.black),
                        onPressed: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome back 👋",
                              style: TextStyle(
                                fontSize: 22,
                                // 👈 28 thi ochu karo (overflow avoid)
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1C1E),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Multi-Color 3D Dashboard",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 👤 Profile
                      InkWell(
                        onTap: () {
                          NotificationService.showNotification("title", "body");
                        },
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white.withOpacity(0.5),
                            child:
                                Icon(Icons.person_outline, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 35),

                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                            color: Colors.blueAccent,
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0; i < productList.length; i++) ...[
                              _buildGlassCard(
                                title: productList[i].title ?? "",
                                subtitle: productList[i].body ?? "",
                                icon: Icons.shopping_bag,
                                accentColor: Colors.blueAccent,
                                cardBg: Color(0xFFE3F2FD),
                              ),

                              // 👇 spacing between items
                              SizedBox(height: 15),
                            ],
                          ],
                        ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper for Background Blobs
  Widget _buildBlob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  // 💎 The Glass 3D Card Widget (No Shadows)
  Widget _buildGlassCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required Color cardBg,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: cardBg.withOpacity(0.6), // Translucent tint
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: accentColor.withOpacity(0.3), // Colored border for 3D look
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(22),
            child: Row(
              children: [
                // Icon Pop
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: accentColor, size: 28),
                ),
                SizedBox(width: 20),
                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: accentColor.withOpacity(0.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isLoading = false;
  List<GetDioModel> productList = [];

  DiogetData() async {
    bool internet = await checkInternet();

    if (internet) {
      try {
        setState(() {
          isLoading = true;
        });

        final response = await ProductProvider().DioGetProduct();

        log("API RESPONSE: ${response.data}");
        log("STATUS CODE: ${response.statusCode}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          productList = (response.data as List)
              .map((e) => GetDioModel.fromJson(e))
              .toList();

          log("LIST LENGTH: ${productList.length}");

          setState(() {
            isLoading = false;
          });
        } else {
          log("ERROR STATUS CODE: ${response.statusCode}");

          setState(() {
            isLoading = false;
          });

          showCustomErrorSnackbar(
            context,
            title: "Error",
            message: "Something went wrong",
          );
        }
      } catch (e, stackTrace) {
        log("ERROR OCCURRED: $e");
        log("STACK TRACE: $stackTrace");

        setState(() {
          isLoading = false;
        });

        showCustomErrorSnackbar(
          context,
          title: "Error",
          message: e.toString(),
        );
      }
    } else {
      log("NO INTERNET CONNECTION");

      showCustomErrorSnackbar(
        context,
        title: "No Internet",
        message: "Please check your connection",
      );
    }
  }
}
