import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Core/Service/service.dart';

import '../Model/signupmodelclass.dart';


class SignupViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();


  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final emailController = TextEditingController();
  final buildingNoController = TextEditingController();
  final street1Controller = TextEditingController();
  final street2Controller = TextEditingController();
  final districtController = TextEditingController();
  final pincodeController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    emailController.dispose();
    buildingNoController.dispose();
    street1Controller.dispose();
    street2Controller.dispose();
    districtController.dispose();
    pincodeController.dispose();
    super.dispose();
  }


  Future<void> fetchAddressByPincode(String pincode) async {
    if (pincode.length != 6) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = Uri.parse('https://api.postalpincode.in/pincode/$pincode');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final pincodeResponse = PincodeResponse.fromJson(data[0]);

        if (pincodeResponse.status == 'Success' && pincodeResponse.postOffices.isNotEmpty) {
          final firstOffice = pincodeResponse.postOffices[0];


          street1Controller.text = firstOffice.name;
          street2Controller.text = pincodeResponse.postOffices.length > 1
              ? pincodeResponse.postOffices[1].name
              : firstOffice.name;
          districtController.text = firstOffice.district;
          _errorMessage = null;
        } else {
          _errorMessage = 'Invalid Pincode. No data found.';
          clearAddressFields();
        }
      } else {
        _errorMessage = 'Failed to fetch data. Please try again.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred. Check your internet connection.';
      clearAddressFields();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearAddressFields() {
    street1Controller.clear();
    street2Controller.clear();
    districtController.clear();
  }

  // void submitForm() {
  //   if (formKey.currentState?.validate() ?? false) {
  //
  //     debugPrint('Form validated successfully!');
  //   }
  // }

  Future<bool> submitForm() async {
    if (formKey.currentState?.validate() ?? false) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
        final userData = {
          'name': nameController.text,
          'number': numberController.text,
          'email': emailController.text,
          'buildingNo': buildingNoController.text,
          'street1': street1Controller.text,
          'street2': street2Controller.text,
          'district': districtController.text,
          'pincode': pincodeController.text,
        };


        await LocalStorageService.saveUser(userData);
        return true;
      } catch (e) {
        _errorMessage = 'Failed to save data locally.';
        return false;
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
    return false;
  }

  void clearForm() {
    nameController.clear();
    numberController.clear();
    emailController.clear();
    buildingNoController.clear();
    street1Controller.clear();
    street2Controller.clear();
    districtController.clear();
    pincodeController.clear();
    _errorMessage = null;
    notifyListeners();
  }
}