import json
import numpy as np
import tensorflow as tf
from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.preprocessing.sequence import pad_sequences
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Embedding, GlobalAveragePooling1D, Dense
import pickle

print("🚀 Starting Training (Final Fixed Version)...")

# Load Data
with open('qa_dataset.json', 'r', encoding='utf-8') as f:
    qa_pairs = json.load(f)

questions = [pair['question'].strip() for pair in qa_pairs]
answers = [pair['answer'].strip() for pair in qa_pairs]

print(f"✅ Loaded {len(questions)} QA pairs")

# Tokenizer
tokenizer = Tokenizer(oov_token="<OOV>", lower=True)
tokenizer.fit_on_texts(questions)

vocab_size = len(tokenizer.word_index) + 1
sequences = tokenizer.texts_to_sequences(questions)
max_len = max(len(seq) for seq in sequences)
padded = pad_sequences(sequences, maxlen=max_len, padding='post')

# Build Model
model = Sequential([
    Embedding(input_dim=vocab_size, output_dim=128, input_length=max_len),
    GlobalAveragePooling1D(),
    Dense(256, activation='relu'),
    Dense(128, activation='relu'),
    Dense(64, name="embedding_output")
])

model.compile(optimizer='adam', loss='mse')
model.summary()

# Compute Embeddings
print("Computing embeddings...")
question_embeddings = model.predict(padded, batch_size=128, verbose=1)

# ===================== FIXED SAVING =====================
# Save in native Keras format (Recommended)
model.save('food_chatbot_model.keras')

with open('tokenizer.pkl', 'wb') as f:
    pickle.dump(tokenizer, f)

with open('qa_data.pkl', 'wb') as f:
    pickle.dump({
        'questions': questions,
        'answers': answers,
        'embeddings': question_embeddings,
        'max_len': max_len
    }, f)

print("✅ Model saved as food_chatbot_model.keras")

# TFLite Conversion
converter = tf.lite.TFLiteConverter.from_keras_model(model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]
tflite_model = converter.convert()

with open('food_chatbot_model.tflite', 'wb') as f:
    f.write(tflite_model)

print("🎉 TFLite model saved successfully!")