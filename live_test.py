import tkinter as tk
from tkinter import filedialog
from PIL import Image, ImageTk
import cv2
import tensorflow as tf
import numpy as np
import threading

# =========================
# 1. Load Models
# =========================
# Freshness model
fresh_model_path = "models/rottenvsfresh.h5"
fresh_model = tf.keras.models.load_model(fresh_model_path)
print("Freshness model loaded!")

# Food name model
food_model_path = "models/food_name.h5"
food_model = tf.keras.models.load_model(food_model_path)
print("Food name model loaded!")

# =========================
# 2. Settings
# =========================
FRESH_IMG_SIZE = (100, 100)
FOOD_IMG_SIZE = (224, 224)

labels = {
    0: 'apple', 1: 'banana', 2: 'beetroot', 3: 'bell pepper', 4: 'cabbage', 5: 'capsicum', 6: 'carrot',
    7: 'cauliflower', 8: 'chilli pepper', 9: 'corn', 10: 'cucumber', 11: 'eggplant', 12: 'garlic', 13: 'ginger',
    14: 'grapes', 15: 'jalepeno', 16: 'kiwi', 17: 'lemon', 18: 'lettuce',
    19: 'mango', 20: 'onion', 21: 'orange', 22: 'paprika', 23: 'pear', 24: 'peas', 25: 'pineapple',
    26: 'pomegranate', 27: 'potato', 28: 'raddish', 29: 'soy beans', 30: 'spinach', 31: 'sweetcorn',
    32: 'sweetpotato', 33: 'tomato', 34: 'turnip', 35: 'watermelon'
}

# =========================
# 3. Prediction Functions
# =========================
def predict_freshness(img):
    """Predict freshness from a frame (cv2 image)."""
    img_resized = cv2.resize(img, FRESH_IMG_SIZE)
    img_array = np.expand_dims(img_resized, axis=0) / 255.0
    pred = fresh_model.predict(img_array)[0][0]
    if pred < 0.5:
        return "Fresh", (0, 255, 0)
    else:
        return "Rotten", (0, 0, 255)

def predict_food_name(img):
    """Predict food name from a frame (cv2 image)."""
    img_resized = cv2.resize(img, FOOD_IMG_SIZE)
    img_array = img_resized[..., ::-1]  # BGR to RGB
    img_array = np.expand_dims(img_array, axis=0) / 255.0
    pred = food_model.predict(img_array)
    class_index = pred.argmax(axis=-1)[0]
    food_name = labels[class_index].capitalize()
    confidence = pred[0][class_index]
    return food_name, confidence

def predict_image_file(img_path):
    """Predict both freshness and food name from a file path."""
    from tensorflow.keras.preprocessing import image
    img = image.load_img(img_path, target_size=FRESH_IMG_SIZE)
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0) / 255.0
    # Freshness
    pred_fresh = fresh_model.predict(img_array)[0][0]
    freshness = "Fresh" if pred_fresh < 0.5 else "Rotten"
    color = "green" if pred_fresh < 0.5 else "red"
    # Food name
    img_food = image.load_img(img_path, target_size=FOOD_IMG_SIZE)
    img_food_array = image.img_to_array(img_food)
    img_food_array = np.expand_dims(img_food_array, axis=0) / 255.0
    pred_food = food_model.predict(img_food_array)
    class_index = pred_food.argmax(axis=-1)[0]
    food_name = labels[class_index].capitalize()
    confidence = pred_food[0][class_index]
    return freshness, color, food_name, confidence

# =========================
# 4. GUI Functions
# =========================
def browse_image():
    file_path = filedialog.askopenfilename(filetypes=[("Image Files", "*.png *.jpg *.jpeg *.bmp")])
    if file_path:
        # Display image
        img = Image.open(file_path).resize((250, 250))
        img_tk = ImageTk.PhotoImage(img)
        image_label.config(image=img_tk)
        image_label.image = img_tk

        # Predict
        freshness, color, food_name, conf = predict_image_file(file_path)
        result_label.config(text=f"{food_name} ({conf*100:.2f}%)\n{freshness}", fg=color)

def start_camera():
    threading.Thread(target=run_camera, daemon=True).start()

def run_camera():
    cap = cv2.VideoCapture(0)
    while True:
        ret, frame = cap.read()
        if not ret:
            break

        # Predict freshness and food name
        freshness, color = predict_freshness(frame)
        food_name, conf = predict_food_name(frame)

        # Overlay on frame
        h, w, _ = frame.shape
        cv2.rectangle(frame, (5, 5), (w-5, h-5), color, 3)
        cv2.putText(frame, f"{food_name} ({conf*100:.1f}%)", (10, 50),
                    cv2.FONT_HERSHEY_SIMPLEX, 1, color, 2)
        cv2.putText(frame, freshness, (10, 100),
                    cv2.FONT_HERSHEY_SIMPLEX, 1, color, 2)

        cv2.imshow("Live Food & Freshness Detection - Press Q to Exit", frame)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()

# =========================
# 5. Tkinter GUI
# =========================
root = tk.Tk()
root.title("Food Name & Freshness Detector")
root.geometry("400x700")

upload_btn = tk.Button(root, text="Upload Image", command=browse_image, bg="green", fg="white", font=("Arial", 14))
upload_btn.pack(pady=10)

camera_btn = tk.Button(root, text="Open Camera", command=start_camera, bg="blue", fg="white", font=("Arial", 14))
camera_btn.pack(pady=10)

image_label = tk.Label(root)
image_label.pack(pady=10)

result_label = tk.Label(root, text="", font=("Arial", 18, "bold"))
result_label.pack(pady=10)

root.mainloop()



















# import tkinter as tk
# from tkinter import filedialog
# from PIL import Image, ImageTk
# import cv2
# import tensorflow as tf
# import numpy as np
# import threading
#
# # =========================
# # Load model
# # =========================
# model_path = "models/rottenvsfresh98pval.h5"
# model = tf.keras.models.load_model(model_path)
# print("Model loaded!")
#
# IMG_SIZE = (100, 100)  # Model input size
#
# # =========================
# # Prediction function
# # =========================
# def predict_image_cv(frame):
#     img = cv2.resize(frame, IMG_SIZE)
#     img_array = np.expand_dims(img, axis=0)
#     img_array = img_array / 255.0
#     pred = model.predict(img_array)[0][0]
#     if pred < 0.5:
#         return "Fresh", (0, 255, 0)  # green
#     else:
#         return "Rotten", (0, 0, 255)  # red
#
# def predict_image_file(img_path):
#     from tensorflow.keras.preprocessing import image
#     img = image.load_img(img_path, target_size=IMG_SIZE)
#     img_array = image.img_to_array(img)
#     img_array = np.expand_dims(img_array, axis=0)
#     img_array = img_array / 255.0
#     pred = model.predict(img_array)[0][0]
#     if pred < 0.5:
#         return "Fresh", "green"
#     else:
#         return "Rotten", "red"
#
# # =========================
# # GUI Functions
# # =========================
# def browse_image():
#     file_path = filedialog.askopenfilename(
#         filetypes=[("Image Files", "*.png *.jpg *.jpeg *.bmp")]
#     )
#     if file_path:
#         # Display image in GUI
#         img = Image.open(file_path)
#         img = img.resize((250, 250))
#         img_tk = ImageTk.PhotoImage(img)
#         image_label.config(image=img_tk)
#         image_label.image = img_tk
#
#         # Predict
#         result_text, color = predict_image_file(file_path)
#         result_label.config(text=result_text, fg=color)
#
# def start_camera():
#     threading.Thread(target=run_camera, daemon=True).start()
#
# def run_camera():
#     cap = cv2.VideoCapture(0)
#     while True:
#         ret, frame = cap.read()
#         if not ret:
#             break
#
#         # Predict freshness
#         label, color = predict_image_cv(frame)
#
#         # Draw bounding box around the whole frame
#         h, w, _ = frame.shape
#         cv2.rectangle(frame, (5, 5), (w-5, h-5), color, 3)
#         cv2.putText(frame, label, (10, 50), cv2.FONT_HERSHEY_SIMPLEX, 1.5, color, 3)
#
#         # Show frame
#         cv2.imshow("Live Freshness Detection - Press Q to Exit", frame)
#
#         if cv2.waitKey(1) & 0xFF == ord('q'):
#             break
#
#     cap.release()
#     cv2.destroyAllWindows()
#
# # =========================
# # Tkinter GUI Setup
# # =========================
# root = tk.Tk()
# root.title("Food Freshness Detector")
# root.geometry("400x650")
#
# # Buttons
# browse_btn = tk.Button(root, text="Select Image", command=browse_image, font=("Arial", 14))
# browse_btn.pack(pady=10)
#
# camera_btn = tk.Button(root, text="Open Camera", command=start_camera, font=("Arial", 14))
# camera_btn.pack(pady=10)
#
# # Image display
# image_label = tk.Label(root)
# image_label.pack(pady=10)
#
# # Result display
# result_label = tk.Label(root, text="", font=("Arial", 24, "bold"))
# result_label.pack(pady=10)
#
# root.mainloop()