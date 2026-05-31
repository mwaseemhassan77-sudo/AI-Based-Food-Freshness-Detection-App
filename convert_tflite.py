import tensorflow as tf

# Load your Keras model
model = tf.keras.models.load_model("models/food_name.h5")

# Convert to TFLite
converter = tf.lite.TFLiteConverter.from_keras_model(model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]  # optional: optimize for size and speed
tflite_model = converter.convert()

# Save the TFLite model
with open("food_name_detect.tflite", "wb") as f:
    f.write(tflite_model)

print("✅ TFLite model saved!")