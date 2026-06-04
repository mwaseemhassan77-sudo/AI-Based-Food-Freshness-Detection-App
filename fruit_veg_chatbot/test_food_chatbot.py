import pickle
import numpy as np
import tensorflow as tf
from tensorflow.keras.preprocessing.sequence import pad_sequences

print("Loading Food Chatbot Model...\n")

# Load model (Fixed)
model = tf.keras.models.load_model('food_chatbot_model.keras')

with open('tokenizer.pkl', 'rb') as f:
    tokenizer = pickle.load(f)

with open('qa_data.pkl', 'rb') as f:
    data = pickle.load(f)

questions = data['questions']
answers = data['answers']
question_embeddings = data['embeddings']
max_len = data['max_len']

print(f"✅ Model loaded successfully! ({len(questions)} QA pairs)\n")


def get_response(user_input: str):
    seq = tokenizer.texts_to_sequences([user_input])
    padded = pad_sequences(seq, maxlen=max_len, padding='post')

    user_embedding = model.predict(padded, verbose=0)[0]

    similarities = np.dot(question_embeddings, user_embedding) / (
            np.linalg.norm(question_embeddings, axis=1) * np.linalg.norm(user_embedding) + 1e-8
    )

    best_idx = np.argmax(similarities)
    confidence = similarities[best_idx]

    print(f"Confidence: {confidence:.4f}")

    if confidence < 0.30:
        return "Sorry, I couldn't find a good match. Please try asking differently."

    return answers[best_idx]


# Test Chat
print("🤖 Chatbot Ready! Type 'exit' to quit.\n")
while True:
    user_input = input("You: ").strip()
    if user_input.lower() in ['exit', 'quit', 'bye']:
        print("👋 Goodbye!")
        break
    if user_input:
        response = get_response(user_input)
        print(f"Bot: {response}\n")