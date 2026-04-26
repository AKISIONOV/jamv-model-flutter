import tensorflow as tf

try:
    print("Loading model...")
    model = tf.keras.models.load_model('best_model.keras')
    print("\nModel Input Shape:", model.input_shape)
    print("Model Output Shape:", model.output_shape)
    print("\nModel Summary:")
    model.summary()
except Exception as e:
    print(f"Error loading model: {e}")
