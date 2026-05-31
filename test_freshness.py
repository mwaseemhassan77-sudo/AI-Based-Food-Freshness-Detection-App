import numpy as np
from tensorflow.keras.preprocessing.image import load_img, img_to_array
from tensorflow.keras.models import load_model
import os

# =========================
# 1. Load Trained Model
# =========================
model_path = r"models/rottenvsfresh.h5"  # Path to your .h5 model
model = load_model(model_path)
print("Model loaded for inference!")

# =========================
# 2. Labels Dictionary
# =========================
labels = {
    0: 'apple', 1: 'banana', 2: 'beetroot', 3: 'bell pepper', 4: 'cabbage', 5: 'capsicum', 6: 'carrot',
    7: 'cauliflower', 8: 'chilli pepper', 9: 'corn', 10: 'cucumber', 11: 'eggplant', 12: 'garlic', 13: 'ginger',
    14: 'grapes', 15: 'jalepeno', 16: 'kiwi', 17: 'lemon', 18: 'lettuce',
    19: 'mango', 20: 'onion', 21: 'orange', 22: 'paprika', 23: 'pear', 24: 'peas', 25: 'pineapple',
    26: 'pomegranate', 27: 'potato', 28: 'raddish', 29: 'soy beans', 30: 'spinach', 31: 'sweetcorn',
    32: 'sweetpotato', 33: 'tomato', 34: 'turnip', 35: 'watermelon'
}

# =========================
# 3. Prediction Function
# =========================
def predict_food(img_path):
    """
    Predict food name and confidence from an image.
    img_path: full path or relative path to image
    returns: (food_name, confidence)
    """
    # Check if image exists
    if not os.path.exists(img_path):
        raise FileNotFoundError(f"Image not found: {img_path}")

    # Load image and preprocess
    img = load_img(img_path, target_size=(224, 224))
    img = img_to_array(img)
    img = img / 255.0  # normalize
    img = np.expand_dims(img, axis=0)

    # Predict
    prediction = model.predict(img)
    class_index = prediction.argmax(axis=-1)[0]
    food_name = labels[class_index].capitalize()
    confidence = prediction[0][class_index]

    return food_name, confidence

# =========================
# 4. Test Single Image
# =========================
image_path = r"test_images/f4.png"  # Your image path

food, conf = predict_food(image_path)
print(f"Food: {food}")
print(f"Confidence: {conf:.4f}")

















# import tensorflow as tf
# import numpy as np
# from tensorflow.keras.preprocessing import image
#
# # =========================
# # 1. Load Model
# # =========================
# model_path = "models/rottenvsfresh98pval.h5"   # <-- change to your file
# model = tf.keras.models.load_model(model_path)
#
# print("Model loaded successfully!")
# print("Output shape:", model.output_shape)
#
# # =========================
# # 2. Load Image
# # =========================
# img_path = "test_images/r1.jpg"   # <-- change your image path
# img = image.load_img(img_path, target_size=(100, 100))
#
# img_array = image.img_to_array(img)
# img_array = np.expand_dims(img_array, axis=0)
#
# # =========================
# # 3. TRY BOTH PREPROCESSING
# # =========================
#
# # Option 1: /255
# img_norm = img_array / 255.0
#
# # Option 2: MobileNet preprocessing
# from tensorflow.keras.applications.mobilenet_v2 import preprocess_input
# img_mobilenet = preprocess_input(img_array.copy())
#
# # =========================
# # 4. Prediction
# # =========================
# print("\n--- Using /255 normalization ---")
# pred1 = model.predict(img_norm)
# print("Raw prediction:", pred1)
#
# print("\n--- Using preprocess_input ---")
# pred2 = model.predict(img_mobilenet)
# print("Raw prediction:", pred2)
#
# # =========================
# # 5. INTERPRET RESULTS
# # =========================
#
# def interpret(pred):
#     if model.output_shape[-1] == 1:
#         value = pred[0][0]
#         print("Value:", value)
#
#         if value > 0.7:
#             print("🔴 Likely Rotten")
#         elif value > 0.4:
#             print("🟡 Medium Fresh")
#         else:
#             print("🟢 Fresh")
#
#     else:
#         class_id = np.argmax(pred)
#         print("Class index:", class_id)
#
#         if class_id == 0:
#             print("🟢 Fresh")
#         elif class_id == 1:
#             print("🟡 Medium")
#         else:
#             print("🔴 Rotten")
#
# print("\n--- Interpretation (/255) ---")
# interpret(pred1)
#
# print("\n--- Interpretation (preprocess_input) ---")
# interpret(pred2)



