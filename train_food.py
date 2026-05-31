import tensorflow as tf
from tensorflow.keras import layers, models
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.applications.mobilenet_v2 import preprocess_input
import os

# =========================
# 1. Settings
# =========================
dataset_path = "dataset_food"
img_size = (224, 224)
batch_size = 32
epochs = 5

# =========================
# 2. Load Dataset
# =========================
train_ds = tf.keras.preprocessing.image_dataset_from_directory(
    dataset_path,
    validation_split=0.2,
    subset="training",
    seed=123,
    image_size=img_size,
    batch_size=batch_size
)

val_ds = tf.keras.preprocessing.image_dataset_from_directory(
    dataset_path,
    validation_split=0.2,
    subset="validation",
    seed=123,
    image_size=img_size,
    batch_size=batch_size
)

class_names = train_ds.class_names
print("Classes:", class_names)

# =========================
# 3. Optimize Dataset
# =========================
AUTOTUNE = tf.data.AUTOTUNE

train_ds = train_ds.cache().shuffle(1000).prefetch(buffer_size=AUTOTUNE)
val_ds = val_ds.cache().prefetch(buffer_size=AUTOTUNE)

# =========================
# 4. Data Augmentation 🔥
# =========================
data_augmentation = tf.keras.Sequential([
    layers.RandomFlip("horizontal"),
    layers.RandomRotation(0.1),
    layers.RandomZoom(0.1),
])

# =========================
# 5. Base Model
# =========================
base_model = MobileNetV2(
    input_shape=(224, 224, 3),
    include_top=False,
    weights='imagenet'
)

base_model.trainable = False

# =========================
# 6. Build Model (FIXED)
# =========================
model = models.Sequential([
    layers.Input(shape=(224, 224, 3)),   # IMPORTANT FIX
    data_augmentation,
    layers.Lambda(preprocess_input),
    base_model,
    layers.GlobalAveragePooling2D(),
    layers.BatchNormalization(),
    layers.Dense(128, activation='relu'),
    layers.Dropout(0.5),
    layers.Dense(len(class_names), activation='softmax')
])

# =========================
# 7. Compile
# =========================
model.compile(
    optimizer=tf.keras.optimizers.Adam(learning_rate=0.0001),
    loss='sparse_categorical_crossentropy',
    metrics=['accuracy']
)

# Now summary will work
model.summary()

# =========================
# 8. Train
# =========================
history = model.fit(
    train_ds,
    validation_data=val_ds,
    epochs=epochs
)

# =========================
# 9. Save Model
# =========================
os.makedirs("models", exist_ok=True)
model.save("models/food_name.h5")

print("✅ Food model trained & saved!")