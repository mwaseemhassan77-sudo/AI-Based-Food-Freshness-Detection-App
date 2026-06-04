// lib/modules/result/widgets/result_not_found.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotFoundView extends StatelessWidget {
  final String? imagePath;

  const NotFoundView({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imagePath != null)
            Image.file(File(imagePath!), height: 200),

          const SizedBox(height: 20),

          const Text(
            "This item is not a fruit.",
            style: TextStyle(fontSize: 18),
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text("Try Again"),
          ),
        ],
      ),
    );
  }
}