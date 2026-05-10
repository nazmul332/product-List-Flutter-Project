import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:product_list_app/app/views/auth/login_screen.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/product_controller.dart';
import '../../data/services/storage_service.dart';
import '../../routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  void _confirmDelete(BuildContext context, int id, String name) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Delete Product',
            style: TextStyle(color: AppColors.textPrimary)),
        content: Text(
          'Are you sure you want to delete "$name"?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Get.back();
              Get.find<ProductController>().deleteProduct(id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();
    final storage = StorageService.to;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Product List',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            Text(
              'Hi, ${storage.username ?? 'User'}',
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 11),
            )
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout_rounded, color: AppColors.error),
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  backgroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  title: const Text('Logout',
                      style: TextStyle(color: AppColors.textPrimary)),
                  content: const Text('Are you sure you want to sign out?',
                      style: TextStyle(color: AppColors.textSecondary)),
                  actions: [
                    TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel')),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error),
                      onPressed: () async {
                        await StorageService.to.clearAll();
                        Get.offAllNamed(AppRoutes.login);
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'create_product',
        onPressed: () => Get.toNamed(AppRoutes.productForm),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Product',
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (controller.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.inventory_2_outlined,
                    size: 72, color: AppColors.textHint.withOpacity(0.5)),
                const SizedBox(height: 16),
                const Text('No products yet',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 16)),
                const SizedBox(height: 8),
                const Text('Tap + to add your first product',
                    style: TextStyle(
                        color: AppColors.textHint, fontSize: 13)),
              ],
            ),
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.fetchProducts,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: AnimationLimiter(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.72,
                ),
                itemCount: controller.products.length,
                itemBuilder: (ctx, i) {
                  final product = controller.products[i];
                  return AnimationConfiguration.staggeredGrid(
                    position: i,
                    columnCount: 2,
                    duration: const Duration(milliseconds: 400),
                    child: SlideAnimation(
                      verticalOffset: 40,
                      child: FadeInAnimation(
                        child: ProductCard(
                          product: product,
                          onTap: () {
                            controller.selectedProduct.value = product;
                            Get.toNamed(AppRoutes.productDetail);
                          },
                          onDelete: () => _confirmDelete(
                              ctx, product.id, product.name),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}
