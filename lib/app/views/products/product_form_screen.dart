import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../../data/models/product_model.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/gradient_button.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();

  ProductModel? _editProduct;
  bool get _isEditing => _editProduct != null;

  final List<String> _categories = [
    'Electronics',
    'Home Appliances',
    'Clothing',
    'Food',
    'Sports',
    'Books',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _editProduct = Get.arguments as ProductModel?;
    if (_isEditing) {
      _nameCtrl.text = _editProduct!.name;
      _descCtrl.text = _editProduct!.description;
      _priceCtrl.text = _editProduct!.price.toString();
      _categoryCtrl.text = _editProduct!.category;
      _stockCtrl.text = _editProduct!.stock.toString();
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _categoryCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final controller = Get.find<ProductController>();
    final data = {
      'name': _nameCtrl.text.trim(),
      'description': _descCtrl.text.trim(),
      'price': double.parse(_priceCtrl.text.trim()),
      'category': _categoryCtrl.text.trim(),
      'stock': int.parse(_stockCtrl.text.trim()),
    };
    if (_isEditing) {
      controller.updateProduct(_editProduct!.id, data);
    } else {
      controller.createProduct(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Product' : 'New Product'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header illustration
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Icon(
                    _isEditing
                        ? Icons.edit_rounded
                        : Icons.add_shopping_cart_rounded,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  _isEditing ? 'Update Product Info' : 'Add New Product',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              _sectionLabel('PRODUCT INFO'),
              const SizedBox(height: 10),

              TextFormField(
                controller: _nameCtrl,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  hintText: 'e.g. iPhone 15 Pro',
                  prefixIcon: Icon(Icons.label_outline_rounded),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _descCtrl,
                style: const TextStyle(color: AppColors.textPrimary),
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Brief product description...',
                  prefixIcon: Icon(Icons.description_outlined),
                  alignLabelWithHint: true,
                ),
                validator: (v) => (v == null || v.isEmpty)
                    ? 'Description is required'
                    : null,
              ),
              const SizedBox(height: 20),

              _sectionLabel('PRICING & INVENTORY'),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      style:
                          const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        labelText: 'Price (\$)',
                        hintText: '0.00',
                        prefixIcon: Icon(Icons.attach_money_rounded),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        if (double.tryParse(v) == null) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _stockCtrl,
                      keyboardType: TextInputType.number,
                      style:
                          const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        labelText: 'Stock',
                        hintText: '0',
                        prefixIcon: Icon(Icons.inventory_rounded),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        if (int.tryParse(v) == null) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Category dropdown
              DropdownButtonFormField<String>(
                value: _categoryCtrl.text.isNotEmpty
                    ? (_categories.contains(_categoryCtrl.text)
                        ? _categoryCtrl.text
                        : null)
                    : null,
                dropdownColor: AppColors.surface,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: _categories
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c,
                              style: const TextStyle(
                                  color: AppColors.textPrimary)),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) _categoryCtrl.text = v;
                },
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Select a category' : null,
              ),
              const SizedBox(height: 32),

              Obx(() => GradientButton(
                    label: _isEditing ? 'Update Product' : 'Create Product',
                    icon: _isEditing
                        ? Icons.check_rounded
                        : Icons.add_rounded,
                    isLoading: controller.isSubmitting.value,
                    onPressed: _submit,
                  )),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textHint,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }
}
