import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:testproject/ui/blocApiCalling/bloc/productBloc.dart';
import 'package:testproject/ui/blocApiCalling/bloc/productEvent.dart';
import 'package:testproject/ui/blocApiCalling/bloc/productState.dart';

import 'package:testproject/ui/blocApiCalling/repository/postsRepository.dart';
import 'package:testproject/ui/blocApiCalling/view/addProductScreen.dart';
import 'package:testproject/util/customDrower.dart';


class BlocProductScreen extends StatefulWidget {
    BlocProductScreen({super.key});

  @override
  State<BlocProductScreen> createState() => _BlocProductScreenState();
}

class _BlocProductScreenState extends State<BlocProductScreen> {


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductBloc(ProductRepository())..add(FetchProductsEvent()),
      child: Scaffold(
        key:  _scaffoldKey,
        drawer: CustomDrawer(),
        backgroundColor:  Color(0xFFF5F7F9),
        appBar: AppBar(
          title:   Text(
            "Premium Store",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.menu_open_rounded, color: Colors.white, size: 28),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          centerTitle: true,
          elevation: 0,
          flexibleSpace: Container(
            decoration:  BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.deepPurple],
              ),
            ),
          ),
          actions: [
            IconButton(onPressed: () {
             Get.to(() => AddProductScreeen());
            }, icon: Icon(Icons.add_shopping_cart_rounded, color: Colors.white))
          ],
        ),

        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return   Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              );
            }

            if (state is ProductLoaded) {
              return ListView.builder(
                padding:   EdgeInsets.all(12),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final item = state.products[index];
                  return _buildProductCard(item);
                },
              );
            }

            if (state is ProductError) {
              return _buildErrorWidget(state.message, context);
            }

            return   SizedBox();
          },
        ),
      ),
    );
  }

  // 🔹 Product Card UI
  Widget _buildProductCard(dynamic item) {
    return Container(
      margin:   EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset:   Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding:   EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Shadow
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.shade100,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  item.image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
              SizedBox(width: 15),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:   TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                    SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹ ${item.price}",
                        style:   TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.blueAccent,
                        ),
                      ),
                      // Add to Cart Button
                      Container(
                        padding:   EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child:   Icon(Icons.add, color: Colors.blueAccent, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Error Widget UI
  Widget _buildErrorWidget(String message, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 60),
            SizedBox(height: 15),
          Text(message, style:   TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.read<ProductBloc>().add(FetchProductsEvent());
            },
            child:   Text("Retry"),
          )
        ],
      ),
    );
  }
}