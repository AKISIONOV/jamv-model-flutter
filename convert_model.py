import tensorflow as tf
import os

def convert_model():
    keras_model_path = 'best_model.keras'
    tflite_model_path = 'best_model.tflite'
    
    print(f"Loading Keras model from {keras_model_path}...")
    try:
        model = tf.keras.models.load_model(keras_model_path)
    except Exception as e:
        print(f"Failed to load model: {e}")
        return

    print("Converting model to TensorFlow Lite format...")
    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    
    # Optional: Add optimizations for Edge AI (quantization) to reduce size and improve speed offline
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    
    tflite_model = converter.convert()
    
    print(f"Saving TFLite model to {tflite_model_path}...")
    with open(tflite_model_path, 'wb') as f:
        f.write(tflite_model)
        
    print(f"Successfully converted model! TFLite model size: {os.path.getsize(tflite_model_path) / (1024*1024):.2f} MB")

if __name__ == "__main__":
    convert_model()
