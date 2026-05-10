import 'package:get/get.dart';
import '../data/models/user_model.dart';
import '../data/services/api_service.dart';
import '../data/services/storage_service.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final ApiService _api = ApiService();

  final isLoading = false.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadStoredUser();
  }

  void _loadStoredUser() {
    final storage = StorageService.to;
    if (storage.isLoggedIn && storage.userId != null) {
      currentUser.value = UserModel(
        id: storage.userId!,
        username: storage.username ?? '',
        email: storage.email ?? '',
      );
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      await _api.register(username: username, email: email, password: password);
      Get.snackbar(
        'Success 🎉',
        'Registration successful! Please log in.',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offNamed(AppRoutes.login);
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      final data = await _api.login(email: email, password: password);
      final authResponse = AuthResponse.fromJson(data);

      await StorageService.to.saveToken(authResponse.token);
      await StorageService.to.saveUser(
        id: authResponse.user.id,
        username: authResponse.user.username,
        email: authResponse.user.email,
      );
      currentUser.value = authResponse.user;

      Get.offAllNamed(AppRoutes.productList);
    } on ApiException catch (e) {
      Get.snackbar('Login failed', e.message,
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await StorageService.to.clearAll();
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.login);
  }
}
