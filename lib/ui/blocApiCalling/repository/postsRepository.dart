import 'package:testproject/apiCalling/DioClient.dart';
import 'package:testproject/apiCalling/apiEndpoints.dart';
import 'package:testproject/ui/blocApiCalling/model/productModel.dart';

class ProductRepository {

  Future<List<ProductModel>> getProducts() async {
    final response = await DioClient.get(ApiEndpoints.products);

    List data = response.data;

    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<List<ProductModel>> addProducts(Map<String, dynamic> body) async {
    final response = await DioClient.post(ApiEndpoints.addproducts);

    List data = response.data;

    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

}