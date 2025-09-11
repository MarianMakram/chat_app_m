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
    return ModalProgressHUD(inAsyncCall:isLoading,
      child: Scaffold(
        appBar: AppBar(title: const Text('Sign Up')),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                CustomTextField(labelText: 'Email', controller: emailController),
                CustomTextField(
                  labelText: 'Password',
                  isPassword: true,
                  controller: passwordController,
                ),
                CustomButton(
                  onPressed: () async {
                    //////////  Auth  ///////////////////////////////////////////
                    if (formKey.currentState!.validate()) {
                      isLoading=true;
                      setState(() {

                      });
                      try {
                        await registerUser();
                        showSnackBar(context, 'Success');
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
                  color: Colors.green,
                ),
              ],
            ),
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
