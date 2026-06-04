import os
import time
from google import genai
from google.genai import types

# ========================= CONFIG =========================
API_KEY = "AIzaSyBU_ZxOWuaNTIfrKAvTPoyRsm7MPwDlEcQ"  # ← Change this

# More stable & free models (Try in this order)
MODEL_NAME = "gemini-2.5-flash"  # Best free option
# MODEL_NAME = "gemini-2.0-flash-exp"    # Alternative
# MODEL_NAME = "gemini-2.5-flash-lite"   # Lighter & more stable

client = genai.Client(api_key=API_KEY)

SYSTEM_INSTRUCTION = """
You are a friendly and helpful Food Assistant chatbot for a university mobile app.
Your job is to help users with food identification, freshness, storage tips, recipes, nutrition, and shelf life.
Keep answers short, practical, and easy to read. Use bullet points when giving tips.
"""

chat = client.chats.create(
    model=MODEL_NAME,
    config=types.GenerateContentConfig(
        system_instruction=SYSTEM_INSTRUCTION,
        temperature=0.7,
        max_output_tokens=700,
    )
)

print("🤖 Gemini Food Chatbot Ready! (Type 'exit' or 'quit' to stop)\n")


def get_gemini_response(user_message: str, detected_food: str = None, max_retries=3):
    for attempt in range(max_retries):
        try:
            prompt = user_message
            if detected_food:
                prompt = f"Detected food: {detected_food}\nUser asked: {user_message}"

            response = chat.send_message(prompt)
            return response.text.strip()

        except Exception as e:
            error_str = str(e)
            if "503" in error_str or "UNAVAILABLE" in error_str:
                print(f"⏳ Model busy (attempt {attempt + 1}/{max_retries})... waiting")
                time.sleep(2 ** attempt)  # Exponential backoff
                continue
            else:
                return f"❌ Error: {error_str[:150]}"

    return "❌ Sorry, the service is busy right now. Please try again in a few seconds."


# ===================== MAIN CHAT LOOP =====================
while True:
    user_input = input("\nYou: ").strip()

    if user_input.lower() in ['exit', 'quit', 'bye', 'goodbye']:
        print("👋 Goodbye! Best of luck with your FYP!")
        break

    if not user_input:
        continue

    print("Bot: ", end="")
    response = get_gemini_response(user_input)
    print(response)