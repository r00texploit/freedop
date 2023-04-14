import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:today/controller/auth_controller.dart';
import 'package:today/screens/comfirm_email.dart';
import 'package:today/widgets/snackbar.dart';

class ForgotPassword extends StatefulWidget {
  static String id = 'forgot-password';
  final String message =
      "An email has just been sent to you, Click the link provided to complete password reset";

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  String? _email;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: ((controller) {
      return Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        body: Form(
          key: controller.formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Email Your Email',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                TextFormField(
                  controller: controller.email,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    icon: Icon(
                      Icons.mail,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  child: const Text('Send Email'),
                  onPressed: () {
                    controller.passwordReset();
                    print(_email);
                  },
                ),
                TextButton(
                  child: const Text('Sign In'),
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
      );
    }));
  }
}
