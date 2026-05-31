import tkinter as tk
from tkinter import filedialog, Label, Button
from PIL import Image, ImageTk
import numpy as np
from tensorflow.keras.preprocessing.image import load_img, img_to_array
from tensorflow.keras.models import load_model
import cv2
import os

# =========================
# 1. Load Trained Model
# =========================
model_path = r"models/food_name.h5"  # Path to your .h5 model
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
def predict_food(img):
    """Predict food name and confidence from an image array."""
    img = cv2.resize(img, (224, 224))
    img = img[..., ::-1]  # BGR to RGB
    img = img / 255.0
    img = np.expand_dims(img, axis=0)
    prediction = model.predict(img)
    class_index = prediction.argmax(axis=-1)[0]
    food_name = labels[class_index].capitalize()
    confidence = prediction[0][class_index]
    return food_name, confidence

# =========================
# 4. Upload Image Function
# =========================
def upload_and_predict():
    file_path = filedialog.askopenfilename(filetypes=[("Image files", "*.jpg *.jpeg *.png")])
    if file_path:
        img = cv2.imread(file_path)
        food, conf = predict_food(img)
        result_label.config(text=f"Food: {food}\nConfidence: {conf:.4f}")

        img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        img_pil = Image.fromarray(img_rgb).resize((250, 250))
        img_tk = ImageTk.PhotoImage(img_pil)
        image_label.config(image=img_tk)
        image_label.image = img_tk

# =========================
# 5. Live Camera Function
# =========================
def open_camera():
    cap = cv2.VideoCapture(0)
    if not cap.isOpened():
        print("Cannot open camera")
        return

    while True:
        ret, frame = cap.read()
        if not ret:
            break

        food, conf = predict_food(frame)
        cv2.putText(frame, f"{food} ({conf*100:.2f}%)", (10, 40),
                    cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)

        cv2.imshow("Live Food Detection - Press 'q' to Exit", frame)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()

# =========================
# 6. Tkinter GUI
# =========================
root = tk.Tk()
root.title("Food Detection AI")
root.geometry("400x550")

upload_btn = Button(root, text="Upload Image", command=upload_and_predict, bg="green", fg="white", font=("Arial", 14))
upload_btn.pack(pady=10)

camera_btn = Button(root, text="Open Camera", command=open_camera, bg="blue", fg="white", font=("Arial", 14))
camera_btn.pack(pady=10)

image_label = Label(root)
image_label.pack(pady=10)

result_label = Label(root, text="", font=("Arial", 14))
result_label.pack(pady=10)

root.mainloop()