import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Core/widgets/customtext_field.dart';
import '../../Core/widgets/loading_overlay.dart';
import '../../Login/View/login_view.dart';
import '../ViewModel/signup_viewmodel.dart';


class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  late final SignupViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<SignupViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
     final viewModel = context.watch<SignupViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),
      body: LoadingOverlay(
        isLoading: viewModel.isLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  controller: viewModel.nameController,
                  labelText: 'Name *',
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your name'
                      : null,
                ),
                CustomTextField(
                  controller: viewModel.numberController,
                  labelText: 'Phone Number *',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    if (value.length < 10) {
                      return 'Enter a valid 10-digit number';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: viewModel.emailController,
                  labelText: 'Email *',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    if (!value.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: viewModel.buildingNoController,
                  labelText: 'Building No *',
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter building number'
                      : null,
                ),

                CustomTextField(
                  controller: viewModel.street1Controller,
                  labelText: 'Street Name 1 *',
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Required' : null,
                ),
                CustomTextField(
                  controller: viewModel.street2Controller,
                  labelText: 'Street Name 2',
                ),
                CustomTextField(
                  controller: viewModel.districtController,
                  labelText: 'District *',
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Required' : null,
                ),
                CustomTextField(
                  controller: viewModel.pincodeController,
                  labelText: 'Pincode *',
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  onChanged: (value) {
                    if (value.length == 6) {
                      viewModel.fetchAddressByPincode(value);
                    } else {
                      viewModel.clearAddressFields();
                    }
                  },
                  validator: (value) {
                    if (value == null || value.length != 6) {
                      return 'Enter a valid 6-digit pincode';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                if (viewModel.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      viewModel.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ElevatedButton(
                  onPressed: () async {
       bool success = await viewModel.submitForm();

       if (success && context.mounted) {

         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Signup Successful! Data saved locally.')),
         );

         Navigator.push(
           context,
           MaterialPageRoute(builder: (context) => const LoginScreen()),
         );
         viewModel.clearForm();
                  }},
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}