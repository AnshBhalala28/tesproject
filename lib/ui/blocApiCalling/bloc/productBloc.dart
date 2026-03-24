import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testproject/ui/blocApiCalling/bloc/productEvent.dart';
import 'package:testproject/ui/blocApiCalling/bloc/productState.dart';

import 'package:testproject/ui/blocApiCalling/repository/postsRepository.dart';


class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc(this.repository) : super(ProductInitial()) {

    on<FetchProductsEvent>((event, emit) async {
      emit(ProductLoading());

      try {
        final data = await repository.getProducts();
        emit(ProductLoaded(data));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });


    on<AddProductEvent>((event, emit) async {
      emit(ProductAdding()); // 🔥 start loading

      try {
        await repository.addProducts(event.body);

        emit(ProductAdded()); // ✅ success

        add(FetchProductsEvent()); // 🔄 refresh list

      } catch (e) {
        emit(ProductAddError(e.toString())); // ❌ error
      }
    });

  }
}