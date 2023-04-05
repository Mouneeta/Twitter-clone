import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content){
 ScaffoldMessenger.of(context).showSnackBar(
   SnackBar(
       content: Text(content),
   ),
 );
}

String getNameFromeEmail(String email){
  return email.split('@')[0];
}