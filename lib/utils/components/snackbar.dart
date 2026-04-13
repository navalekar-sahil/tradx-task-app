
import 'package:flutter/material.dart';

class Util{

  static snackBar({required String message, required BuildContext context}){
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          content: Text(message,style: TextStyle(color: Colors.white),),
        )
    );
  }

}