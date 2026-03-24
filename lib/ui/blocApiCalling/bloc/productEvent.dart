abstract class ProductEvent {}

class FetchProductsEvent extends ProductEvent {}

class AddProductEvent extends ProductEvent {
  final Map<String, dynamic> body;

  AddProductEvent(this.body);
}