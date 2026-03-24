import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:testproject/ui/cart/view/cartScreen.dart';
import 'package:testproject/util/customDrower.dart';

class ProductScreen extends StatefulWidget {
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final List<Map<String, dynamic>> products = [
    {"name": "iPhone 15", "price": 80000, "color": Colors.blue[100]},
    {"name": "Samsung S24", "price": 75000, "color": Colors.orange[100]},
    {"name": "MacBook", "price": 120000, "color": Colors.purple[100]},
    {"name": "iPad Pro", "price": 90000, "color": Colors.green[100]},
  ];



  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text("Premium Store",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu_open_rounded, color: Colors.black, size: 28),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.shopping_bag_outlined,
                    color: Colors.black, size: 28),
                onPressed: () => Get.to(() => CartScreen()),
              ),
            ],
          ),
          SizedBox(width: 10),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemBuilder: (_, index) {
          final product = products[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image Area
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: product['color'],
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Icon(Icons.devices, size: 50, color: Colors.black54),
                  ),
                ),
                // Product Details
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "₹${product['price']}",
                        style: TextStyle(
                          color: Colors.blueAccent[700],
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 10),
                      // Add Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => addToCart(product),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: Text("Add to Cart"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void addToCart(Map<String, dynamic> product) {
    final box = Hive.box('cart');

    int index = box.values.toList().indexWhere(
          (e) => e['name'] == product['name'],
    );

    if (index != -1) {
      var item = Map<String, dynamic>.from(box.getAt(index));
      item['quantity'] += 1;
      box.putAt(index, item);
    } else {
      box.add({
        "name": product['name'],
        "price": product['price'],
        "quantity": 1,
      });
    }

    Get.snackbar(
      "Added to Cart",
      "${product['name']} added successfully!",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: Duration(seconds: 1),
      margin: EdgeInsets.all(15),
      snackStyle: SnackStyle.FLOATING,
    );
  }
}
