import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../helper/show_snack_bar.dart';
import '../widgets/CustomButton.dart';
import '../widgets/CustomTextFeild.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConController = TextEditingController();
  GlobalKey<FormState> formKey=GlobalKey();
  bool isLoading=false;
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
                padding: const EdgeInsets.only(top:179,bottom: 22),
                child: const Text(
                  'Create Account',
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
              CustomTextField(labelText: 'Confirm Password', isPassword: true, controller: passwordConController),
              CustomButton(
                onPressed: () async {
                  //////////  Auth  ///////////////////////////////////////////
                  if (formKey.currentState!.validate()) {
                    if(passwordController.text != passwordConController.text){
                      return showSnackBar(context, 'Password not match');
                    }
                    isLoading=true;
                    setState(() {

                    });
                    try {
                      await registerUser();
                      showSnackBar(context, 'Success');
                      Navigator.pushNamed(context, 'Home');
                    } on FirebaseAuthException catch (e) {
                      print('++++++++++++++++++++++');
                      if (e.code == 'weak-password') {
                        showSnackBar(context, 'The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        showSnackBar(
                          context,
                          'The account already exists for that email.',
                        );
                      }
                    }catch(e){
                      showSnackBar(context, 'Error');
                    }
                    isLoading=false;
                    setState(() {

                    });
                  }else{

                  }
                  /////////////////////////////////////////////////////
                  log(emailController.text);
                },

                text: 'Sign Up',
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'LoginScreen');
                },
                child: const Text(
                  'Already have an account? Login',
                  style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> registerUser() async {
    var auth = FirebaseAuth.instance;
    UserCredential user = await auth.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
  }
}
