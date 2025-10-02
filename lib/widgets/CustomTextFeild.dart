import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool isPassword;
  final TextEditingController controller;
  const CustomTextField({
    super.key,
    required this.labelText,
    this.isPassword = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(0,5),
                blurRadius: 10.0,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
          child: TextFormField(
            validator: (data){
              if(data!.isEmpty){
                return 'Please enter $labelText';
              }
              return null;
            },
            obscureText: isPassword,
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: const TextStyle(color: Colors.blueGrey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
              enabledBorder:OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
        ),
    );
  }
}
