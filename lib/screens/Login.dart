import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../helper/show_snack_bar.dart';
import '../widgets/CustomButton.dart';
import '../widgets/CustomTextFeild.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    //  this releases the memory used by controllers
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall:isLoading,
      child: Scaffold(
        body: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:199,bottom: 22),
                child: const Text(
                  'Welcome Back!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(labelText: 'Email', controller: emailController),
              CustomTextField(
                labelText: 'Password',
                isPassword: true,
                controller: passwordController,
              ),
              CustomButton(
                text: 'Login',
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    isLoading = true;
                    setState(() {});
                    try {
                      await loginUser();
                      showSnackBar(context, 'Success');
                      Navigator.pushNamed(context, 'Home',arguments: emailController.text,);
                    } on FirebaseAuthException catch (e) {
                      print('++++++++++++++++++++++');
                      if (e.code == 'user-not-found') {
                        showSnackBar(
                          context,
                          'No user found for that email.',
                        );
                      } else if (e.code == 'wrong-password') {
                        showSnackBar(
                          context,
                          'Wrong password provided.',
                        );
                      }
                      else {
                        showSnackBar(context, e.message ?? 'Login failed');
                      }
                    }
                    isLoading = false;
                    setState(() {});
                  }
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'SignUpScreen');
                },
                child: const Text(
                  'Don’t have an account? Sign Up',
                  style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    var auth = FirebaseAuth.instance;
    UserCredential user = await auth.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
  }
}
