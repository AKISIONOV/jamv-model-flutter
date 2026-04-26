import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteService {
  Interpreter? _interpreter;
  List<String>? _labels;

  int _inputSize = 224;
  int _outputSize = 5;

  Future<void> init() async {
    try {
      // Load the model
      _interpreter = await Interpreter.fromAsset('assets/models/model.tflite');
      
      // DYNAMICALLY FETCH SHAPE! (Prevents crashing if your model expects 256x256 instead of 224x224)
      var inputShape = _interpreter!.getInputTensor(0).shape;
      if (inputShape.length >= 3) {
        _inputSize = inputShape[1]; // Height/Width
      }
      
      var outputShape = _interpreter!.getOutputTensor(0).shape;
      if (outputShape.isNotEmpty) {
        _outputSize = outputShape.last; // Number of classes
      }
      print('Model loaded! Input size: $_inputSize, Output size: $_outputSize');
      
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

    // Resize image to exact expected shape
    var resizedImage = img.copyResize(image, width: _inputSize, height: _inputSize);

    // Highly optimized nested list generation to prevent phone freezing
    var input = List.generate(1, (i) => 
      List.generate(_inputSize, (y) => 
        List.generate(_inputSize, (x) {
          var pixel = resizedImage.getPixel(x, y);
          // Normalize pixel values to [0, 1]
          return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
        }, growable: false), growable: false
      ), growable: false
    );

    // Output tensor matches the dynamically discovered output size
    var output = List.generate(1, (i) => List.filled(_outputSize, 0.0));

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
