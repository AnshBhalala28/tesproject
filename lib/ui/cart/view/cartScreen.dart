import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cartBox = Hive.box('cart');
  final orderBox = Hive.box('orders');



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("My Shopping Cart",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ValueListenableBuilder(
        valueListenable: cartBox.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return Center(
              child: Text("Your cart is empty!",
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: box.length,
                  itemBuilder: (_, index) {
                    final item = box.getAt(index);
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),
                        leading: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.shopping_bag_outlined,
                              color: Colors.blueAccent),
                        ),
                        title: Text(item['name'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Text("Quantity: ${item['quantity']}",
                            style: TextStyle(color: Colors.grey[600])),
                        trailing: Text("₹${item['price']}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.green)),
                      ),
                    );
                  },
                ),
              ),

              // Bottom Checkout Section
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Amount",
                            style: TextStyle(fontSize: 16, color: Colors.grey)),
                        Text("₹${calculateTotal()}",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent)),
                      ],
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 0,
                        ),
                        onPressed: buyNow,
                        child: Text("Place Order",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  double calculateTotal() {
    double total = 0;
    for (var item in cartBox.values) {
      total += (item['price'] ?? 0) * (item['quantity'] ?? 1);
    }
    return total;
  }

  // 🔄 FIREBASE SYNC (With Online Success Snackbar)
  Future<void> syncOrders() async {
    bool hasSyncedAny = false; // ચેક કરવા માટે કે કોઈ ઓર્ડર સિંક થયો કે નહીં

    for (int i = 0; i < orderBox.length; i++) {
      var order = orderBox.getAt(i);

      if (order['isSynced'] == false) {
        try {
          await FirebaseFirestore.instance.collection('orders').add({
            "name": order['name'],
            "price": order['price'],
            "qty": order['qty'],
            "time": order['time'],
          });

          // Hive માં સ્ટેટસ અપડેટ કરો
          order['isSynced'] = true;
          orderBox.putAt(i, order);
          hasSyncedAny = true;
        } catch (e) {
          debugPrint("Sync failed: $e");
        }
      }
    }

    if (hasSyncedAny) {
      Get.snackbar(
        "Sync Success",
        "Orders successfully synced to Firebase!",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: Icon(Icons.cloud_done, color: Colors.white),
        margin: EdgeInsets.all(15),
        duration: Duration(seconds: 3),
      );
    }
  }

  // 🔥 BUY NOW (With Offline Snackbar)
  void buyNow() async {
    if (cartBox.isEmpty) return;

    for (var item in cartBox.values) {
      await orderBox.add({
        "name": item['name'],
        "price": item['price'],
        "qty": item['quantity'],
        "isSynced": false,
        "time": DateTime.now().toIso8601String(),
      });
    }

    await cartBox.clear();

    Get.snackbar(
      "Offline Saved",
      "Order stored in Hive database!",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orangeAccent,
      colorText: Colors.white,
      icon: Icon(Icons.sd_storage, color: Colors.white),
      margin: EdgeInsets.all(15),
    );

    syncOrders();
  }
  
}
