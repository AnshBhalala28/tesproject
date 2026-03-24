import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:testproject/ui/blocApiCalling/view/prodcutScreen.dart';
import 'package:testproject/util/customButton.dart';
import 'package:testproject/util/customDrower.dart';
import 'package:testproject/util/customTextField.dart';

class AddProductScreeen extends StatefulWidget {
  AddProductScreeen({super.key});

  @override
  State<AddProductScreeen> createState() => _AddProductScreeenState();
}

class _AddProductScreeenState extends State<AddProductScreeen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController productDescriptionController =
      TextEditingController();
  final TextEditingController productCategoryController =
      TextEditingController();

  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      backgroundColor: Color(0xFFF5F7F9),
      appBar: AppBar(
        title: Text(
          "Add Product",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu_open_rounded, color: Colors.white, size: 28),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.deepPurple],
            ),
          ),
        ),
      ),
      body:
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  children: [
                    CustomTextField(
                      hintText: "Enter Product Name",
                      prefixIcon: Icons.post_add_rounded,
                      keyboardType: TextInputType.text,
                      controller: productNameController,
                    ),
                    CustomTextField(
                      hintText: "Enter Product Price",
                      prefixIcon: Icons.attach_money_rounded,
                      keyboardType: TextInputType.number,
                      controller: productPriceController,
                    ),
                    CustomTextField(
                      hintText: "Enter Product Description",
                      prefixIcon: Icons.description_rounded,
                      keyboardType: TextInputType.text,
                      controller: productDescriptionController,
                    ),
                    CustomTextField(
                      hintText: "Enter Product Category",
                      prefixIcon: Icons.category_rounded,
                      keyboardType: TextInputType.text,
                      controller: productCategoryController,
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        height: 180, // થોડી હાઈટ વધારી છે જેથી લુક સારો આવે
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.03),
                          // હળવો બેકગ્રાઉન્ડ કલર
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.blueAccent.withOpacity(0.2),
                            // આછી બ્લુ બોર્ડર
                            width: 2,
                          ),
                        ),
                        child: selectedImage != null
                            ? Stack(
                                children: [
                                  // 🖼️ સિલેક્ટ કરેલી ઈમેજ
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(
                                      selectedImage!,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // ❌ ઈમેજ બદલવા માટેનો ઓવરલે (Optional)
                                  Positioned(
                                    right: 10,
                                    top: 10,
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.white70,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.edit,
                                          size: 18, color: Colors.blueAccent),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // 🎨 આઈકોન વિથ બેકગ્રાઉન્ડ સર્કલ
                                  Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.add_a_photo_rounded,
                                        size: 35, color: Colors.blueAccent),
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    "Upload Product Photo",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Supports: JPG, PNG",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: "SAVE PRODUCT",
                            onTap: () {},
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Expanded(
                          child: CustomButton(
                            text: "CANCEL",
                            onTap: () {
                              Get.to(() => BlocProductScreen());
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

    );
  }
}
