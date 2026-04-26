import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteService {
  Interpreter? _interpreter;
  List<String>? _labels;

  // You will need to define your model's exact input shape.
  // Assuming a standard shape like 224x224 RGB from typical EffNet/Swin models.
  static const int inputSize = 224;

  Future<void> init() async {
    try {
      // Load the model
      _interpreter = await Interpreter.fromAsset('assets/models/model.tflite');
      print('Interpreter loaded successfully');
      
      // Initialize labels
      _labels = [
        'No Diabetic Retinopathy',
        'Mild Diabetic Retinopathy',
        'Moderate Diabetic Retinopathy',
        'Severe Diabetic Retinopathy',
        'Proliferative Diabetic Retinopathy'
      ];
      
    } catch (e) {
      print('Failed to load model.');
      print(e);
    }
  }

  Future<Map<String, dynamic>?> predict(File imageFile) async {
    if (_interpreter == null) return null;

    var imageBytes = await imageFile.readAsBytes();
    var image = img.decodeImage(imageBytes);
    
    if (image == null) return null;

    // Resize image to expected input shape
    var resizedImage = img.copyResize(image, width: inputSize, height: inputSize);

    // Convert image to Float32 tensor representation
    // Assuming model expects input scaled to [0, 1] or [-1, 1]
    // Here we normalize to [0, 1]
    var input = List.generate(1, (i) => List.generate(inputSize, (y) => List.generate(inputSize, (x) => List.generate(3, (c) => 0.0))));
    
    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        var pixel = resizedImage.getPixel(x, y);
        input[0][y][x][0] = pixel.r / 255.0;
        input[0][y][x][1] = pixel.g / 255.0;
        input[0][y][x][2] = pixel.b / 255.0;
      }
    }

    // Output tensor
    var output = List.generate(1, (i) => List.filled(5, 0.0));

    // Run inference
    _interpreter!.run(input, output);
    
    List<double> probabilities = output[0];
    int highestProbIndex = 0;
    double maxProb = probabilities[0];
    
    for(int i = 1; i < probabilities.length; i++) {
        if(probabilities[i] > maxProb) {
            maxProb = probabilities[i];
            highestProbIndex = i;
        }
    }

    return {
      'label': _labels![highestProbIndex],
      'confidence': maxProb,
    };
  }

  void dispose() {
    _interpreter?.close();
  }
}
