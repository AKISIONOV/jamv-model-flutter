import 'package:flutter/material.dart';

class ModelMetricsScreen extends StatelessWidget {
  const ModelMetricsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Model Performance')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Scientific Validation',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'This application is powered by a rigorously tested Edge AI model. Below are the official performance metrics and charts from the model training phase.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          _buildMetricCard(context, 'Classification Report', 'assets/images/CLASSIFICATION REPORT.png'),
          _buildMetricCard(context, 'Confusion Matrix', 'assets/images/CONFUSION MATRIX.png'),
          _buildMetricCard(context, 'Data Class Distribution', 'assets/images/DATA CLASS DISTRIBUTION.png'),
          _buildMetricCard(context, 'Model Accuracy & Loss', 'assets/images/MODEL ACCURACY AND LOSS.png'),
          _buildMetricCard(context, 'Report Summary', 'assets/images/REPORT IMAGE.png'),
        ],
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String imagePath) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const Divider(),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Text('Image not found', style: TextStyle(color: Colors.grey)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
