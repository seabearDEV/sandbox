from llama_cpp import Llama

# Instantiate the model
mixtral = Llama(model_path="/Users/kh/Projects/models/mixtral-8x7b-instruct-v0.1.Q6_K.gguf")

def generate_text_from_prompt(prompt):
    top_p = 0.1

    # Generate the model output
    model_output = mixtral.generate(  # Assuming the method to generate text is called 'generate'
        prompt,
        top_p=top_p
    )
    return model_output["choices"][0]["text"].strip()

if __name__ == "__main__":
    my_prompt = "What do you think about the inclusion policies in Tech companies?"
    zephyr_model_response = generate_text_from_prompt(my_prompt)
    print(zephyr_model_response)
