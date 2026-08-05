import 'package:flutter/material.dart';

import '../../Core/widgets/customtext_field.dart';
import '../../Core/widgets/loading_overlay.dart';
import '../Viewmodel/login_viewmodel.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginViewModel _viewModel = LoginViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, child) {
        return LoadingOverlay(
          isLoading: _viewModel.isLoading,
          child: Scaffold(
            appBar: AppBar(title: const Text('Login'),
            // leading:GestureDetector(child: Icon(Icons.arrow_back_ios),
            // onTap:(){
            //   Navigator.pop(context);
            // })
            ),
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _viewModel.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(Icons.lock_outline_rounded, size: 80, color: Colors.deepPurple),
                        const SizedBox(height: 16),
                        const Text(
                          'Welcome Back',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Log in using your registered email or phone number',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 32),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () => _viewModel.toggleLoginMode(true),
                              child: Text(
                                'Email Login',
                                style: TextStyle(
                                  fontWeight: _viewModel.isEmailMode ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const Text('|', style: TextStyle(color: Colors.grey)),
                            TextButton(
                              onPressed: () => _viewModel.toggleLoginMode(false),
                              child: Text(
                                'Phone Login',
                                style: TextStyle(
                                  fontWeight: !_viewModel.isEmailMode ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),


                        CustomTextField(
                          controller: _viewModel.inputController,
                          labelText: _viewModel.isEmailMode ? 'Enter Email' : 'Enter Phone Number',
                          keyboardType: _viewModel.isEmailMode ? TextInputType.emailAddress : TextInputType.phone,
                          maxLength: _viewModel.isEmailMode ? null : 10,
                          validator: _viewModel.validateInput,
                        ),



                        const SizedBox(height: 24),


                        ElevatedButton(
                          onPressed: () {
                            _viewModel.loginUser(
                              onSuccess: (userName) {
                                _showSnackBar("Welcome back, $userName!", Colors.green);

                               //   Navigator.pop(context);


                              },
                              onError: (errorMessage) {
                                _showSnackBar(errorMessage, Colors.red);
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Login', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}