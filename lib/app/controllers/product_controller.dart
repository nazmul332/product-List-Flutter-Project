import 'package:get/get.dart';
import '../data/models/product_model.dart';
import '../data/services/api_service.dart';
import '../routes/app_routes.dart';

class ProductController extends GetxController {
  final ApiService _api = ApiService();

  final products = <ProductModel>[].obs;
  final Rx<ProductModel?> selectedProduct = Rx<ProductModel?>(null);
  final isLoading = false.obs;
  final isDetailLoading = false.obs;
  final isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final data = await _api.getProducts();
      products.value = data.map((e) => ProductModel.fromJson(e)).toList();
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load products.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProductDetail(int id) async {
    try {
      isDetailLoading.value = true;
      final data = await _api.getProductDetail(id);
      selectedProduct.value = ProductModel.fromJson(data);
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch product detail.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isDetailLoading.value = false;
    }
  }

  Future<void> createProduct(Map<String, dynamic> data) async {
    try {
      isSubmitting.value = true;
      final result = await _api.createProduct(data);
      final newProduct = ProductModel.fromJson(result);
      products.insert(0, newProduct);
      Get.snackbar('Success 🎉', 'Product created!',
          snackPosition: SnackPosition.BOTTOM);
      Get.offNamed(AppRoutes.productList);
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to create product.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> updateProduct(int id, Map<String, dynamic> data) async {
    try {
      isSubmitting.value = true;
      final result = await _api.updateProduct(id, data);
      final updated = ProductModel.fromJson(result);
      final index = products.indexWhere((p) => p.id == id);
      if (index != -1) products[index] = updated;
      selectedProduct.value = updated;
      Get.snackbar('Success ✅', 'Product updated!',
          snackPosition: SnackPosition.BOTTOM);
      Get.offNamed(AppRoutes.productList);
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update product.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _api.deleteProduct(id);
      products.removeWhere((p) => p.id == id);
      Get.snackbar('Deleted 🗑️', 'Product removed successfully.',
          snackPosition: SnackPosition.BOTTOM);
      if (Get.currentRoute == AppRoutes.productDetail) {
        Get.offNamed(AppRoutes.productList);
      }
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
