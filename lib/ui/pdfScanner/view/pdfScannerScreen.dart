import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:testproject/util/CustomDropdown.dart';
import 'package:testproject/util/customDrower.dart';
import 'package:testproject/util/customTextField.dart';

class PdfScannerScreen extends StatefulWidget {
  PdfScannerScreen({super.key});

  @override
  State<PdfScannerScreen> createState() => _PdfScannerScreenState();
}

class _PdfScannerScreenState extends State<PdfScannerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final policyNumberController = TextEditingController();
  final dobController = TextEditingController();
  final cityController = TextEditingController();
  final pincodeController = TextEditingController();
  final companyController = TextEditingController();

  String? selectedGender;
  String? selectedDocumentType;
  File? selectedPdfFile;

  // 🔥 ALIASES
  Map<String, List<String>> pdfKeyAliases = {
    "policy_number": ["Policy No", "Policy Number", "Policy #"],
    "policy_holder": [
      "Policyholder name",
      "Policy Holder",
      "Insured Name",
      "Customer Name",
      "Name"
    ],
    "insurance_company": ["Insurance Company", "Company", "Insurer"],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFF8F9FA),
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text("PDF Scanner"),
      ),

      // ❌ UI SAME રાખ્યું છે
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [

            /// 🔥 PDF BUTTON
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: pickPDF,
                    child: Container(
                      height: 50,
                      color: Colors.blue,
                      child: Center(
                        child: Text(
                          selectedPdfFile == null
                              ? "Upload PDF"
                              : "PDF Selected",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 10),

                InkWell(
                  onTap: processPDF,
                  child: Container(
                    height: 50,
                    width: 50,
                    color: Colors.blueAccent,
                    child: Icon(Icons.arrow_upward, color: Colors.white),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            /// 🔥 FIELDS
            CustomTextField(
              hintText: "Enter Name",
              prefixIcon: Icons.person_outline,
              controller: nameController,
            ),

            CustomTextField(
              hintText: "Enter Email",
              prefixIcon: Icons.email_outlined,
              controller: emailController,
            ),

            CustomTextField(
              hintText: "Enter Phone",
              prefixIcon: Icons.phone_outlined,
              controller: phoneController,
            ),

            CustomTextField(
              hintText: "Enter Address",
              prefixIcon: Icons.location_on_outlined,
              controller: addressController,
            ),

            CustomTextField(
              hintText: "Policy Number",
              prefixIcon: Icons.confirmation_number_outlined,
              controller: policyNumberController,
            ),

            CustomTextField(
              hintText: "DOB",
              prefixIcon: Icons.calendar_today_outlined,
              controller: dobController,
            ),

            CustomTextField(
              hintText: "City",
              prefixIcon: Icons.location_city_outlined,
              controller: cityController,
            ),

            CustomTextField(
              hintText: "Pincode",
              prefixIcon: Icons.pin_drop_outlined,
              controller: pincodeController,
            ),

            CustomTextField(
              hintText: "Company",
              prefixIcon: Icons.business_outlined,
              controller: companyController,
            ),

            CustomDropdown(
              hint: "Gender",
              prefixIcon: Icons.person,
              value: selectedGender,
              items: ["Male", "Female"],
              onChanged: (val) {
                setState(() => selectedGender = val);
              },
            ),

            CustomDropdown(
              hint: "Document Type",
              prefixIcon: Icons.description,
              value: selectedDocumentType,
              items: ["A4 Page", "Receipt"],
              onChanged: (val) {
                setState(() => selectedDocumentType = val);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 PICK PDF
  Future<void> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedPdfFile = File(result.files.single.path!);
      });
    }
  }

  /// 🔥 EXTRACT VALUE
  String extractValue(String text, String key) {
    final regex = RegExp(
      '${RegExp.escape(key)}\\s*[:\\-]?\\s*([^\\n\\r]+)',
      caseSensitive: false,
    );
    return regex.firstMatch(text)?.group(1)?.trim() ?? '';
  }

  /// 🔥 ALIAS MATCH
  String getValueFromAliases(String text, List<String> keys) {
    for (String key in keys) {
      final value = extractValue(text, key);
      if (value.isNotEmpty) return value;
    }
    return '';
  }

  /// 🔥 MAIN PROCESS
  Future<void> processPDF() async {
    if (selectedPdfFile == null) return;

    final bytes = selectedPdfFile!.readAsBytesSync();
    final document = PdfDocument(inputBytes: bytes);

    String text = '';

    for (int i = 0; i < document.pages.count; i++) {
      text += PdfTextExtractor(document).extractText(
        startPageIndex: i,
        endPageIndex: i,
      );
    }

    document.dispose();

    /// 🔥 AUTO FILL
    nameController.text =
        getValueFromAliases(text, pdfKeyAliases["policy_holder"]!);

    policyNumberController.text =
        getValueFromAliases(text, pdfKeyAliases["policy_number"]!);

    companyController.text =
        getValueFromAliases(text, pdfKeyAliases["insurance_company"]!);

    emailController.text =
        RegExp(r'\S+@\S+\.\S+').firstMatch(text)?.group(0) ?? '';

    phoneController.text =
        RegExp(r'\d{10}').firstMatch(text)?.group(0) ?? '';

    addressController.text = extractValue(text, "Address");

    dobController.text =
        RegExp(r'\d{2}/\d{2}/\d{4}').firstMatch(text)?.group(0) ?? '';

    pincodeController.text =
        RegExp(r'\d{6}').firstMatch(text)?.group(0) ?? '';

    if (text.toLowerCase().contains("male")) {
      selectedGender = "Male";
    } else if (text.toLowerCase().contains("female")) {
      selectedGender = "Female";
    }

    if (text.toLowerCase().contains("policy")) {
      selectedDocumentType = "Receipt";
    }

    setState(() {});

    Get.snackbar("Done", "Auto Fill Completed ✅");
  }
}