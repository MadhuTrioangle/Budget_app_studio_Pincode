import 'package:flutter/material.dart';

import '../../Core/Service/service.dart';


class LoginViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final inputController = TextEditingController();

  bool _isEmailMode = true; // true = Email, false = Phone
  bool _isLoading = false;

  bool get isEmailMode => _isEmailMode;
  bool get isLoading => _isLoading;

  void toggleLoginMode(bool isEmail) {
    _isEmailMode = isEmail;
    inputController.clear();
    notifyListeners();
  }

  // Form Validations (Only for Email or Phone)
  String? validateInput(String? value) {
    if (value == null || value.trim().isEmpty) {
      return _isEmailMode ? 'Please enter your email' : 'Please enter your phone number';
    }
    if (_isEmailMode) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value.trim())) {
        return 'Enter a valid email address';
      }
    } else {
      final phoneRegex = RegExp(r'^\d{10}$');
      if (!phoneRegex.hasMatch(value.trim())) {
        return 'Enter a valid 10-digit phone number';
      }
    }
    return null;
  }

  // Login Logic checking only Email or Phone against LocalStorageService
  Future<void> loginUser({
    required Function(String userName) onSuccess,
    required Function(String errorMessage) onError,
  }) async {
    if (!formKey.currentState!.validate()) return;

    _isLoading = true;
    notifyListeners();

    try {
      final userInput = inputController.text.trim();

      // Fetch saved user data map from LocalStorageService
      final Map<String, dynamic>? storedUser = await LocalStorageService.getUser();

      if (storedUser == null) {
        onError("No account found. Please sign up first.");
        return;
      }

      final String? savedEmail = storedUser['email'];
      final String? savedPhone = storedUser['number'];
      final String userName = storedUser['name'] ?? 'User';

      if (_isEmailMode) {
        if (userInput == savedEmail) {
          onSuccess(userName);
        } else {
          onError("Email not found in stored data");
        }
      } else {
        if (userInput == savedPhone) {
          onSuccess(userName);
        } else {
          onError("Phone number not found in stored data");
        }
      }
    } catch (e) {
      onError("An error occurred during login.");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }
}