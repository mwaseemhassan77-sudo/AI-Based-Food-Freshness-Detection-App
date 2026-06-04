import 'package:flutter/material.dart';
import 'package:safebite/core/theme/app_theme.dart';

class AboutApplicationScreen extends StatelessWidget {
  const AboutApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: AppColors.primary,
        title: const Text("About Application",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '''
AI-Based Food Freshness Detection System is an intelligent mobile application developed to help users determine the freshness of food items using Artificial Intelligence (AI) and image processing technology. The application allows users to capture a photo of a food item through the smartphone camera or upload an existing image from the gallery. The system then analyzes the visual characteristics of the food, such as color, texture, bruises, mold, and surface condition, using a trained Convolutional Neural Network (CNN) model deployed with TensorFlow Lite.

After processing the image, the application classifies the food into one of three categories: Fresh, Partially Spoiled, or Spoiled. It also provides a freshness percentage (for example, 85% Fresh) and displays a recommendation such as "Safe to Consume," "Consume Soon," or "Discard Immediately." The results are presented through a simple and user-friendly interface with color indicators (Green, Yellow, and Red) to help users quickly understand the food's condition.

The application performs all AI analysis directly on the mobile device, enabling fast results, enhanced privacy, and offline functionality without requiring an internet connection. Additionally, users can save and view previous scan records through a history feature, allowing them to track food freshness over time. The system aims to reduce food waste, improve food safety awareness, and assist households, grocery vendors, and small food businesses in making informed decisions about food consumption. By combining AI, computer vision, Flutter, TensorFlow Lite, and optional Firebase integration, the application provides an efficient, accessible, and practical solution for food freshness assessment.
              ''',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ),
    );
  }
}