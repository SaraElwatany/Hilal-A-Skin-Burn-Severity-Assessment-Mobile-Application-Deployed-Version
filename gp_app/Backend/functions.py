import os
import io
import json
import math
import torch
from PIL import Image
import torch.nn as nn
from torchvision import models
from torchvision import transforms
from torch.autograd import Variable


    


# Function to load the saved model
def load_model():
    # Print the current working directory
    current_directory = os.getcwd()
    print("Current working directory:", current_directory)
    # Specify the full path to the model file
    model_path = os.path.join(current_directory, 'Backend/best_model.pkl')
    #model_path = 'best_model.pkl'
    # Check if the model file exists
    if not os.path.exists(model_path):
        raise FileNotFoundError(f"Model file '{model_path}' not found.")
    # Load the saved model
    model = torch.load(model_path, map_location=torch.device('cuda' if torch.cuda.is_available() else 'cpu'))
    model.eval()    # Set the model to evaluation mode
    return model # Return the loaded model




# Function to transform the input image to match the trained dataset
def transform(img):
    # Define image transformations
    transform = transforms.Compose([
        transforms.Resize((224, 224)),
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225]),
    ])
    # Transform the image
    img = transform(img)
    img = img.unsqueeze(0)  # Add batch dimension
    # Convert the input to a Variable
    img = Variable(img)
    return img  # Return the transformed image




# Function to Load & preprocess the input image
def load_img():
    # Load and preprocess the input image
    image_path = 'C:/Users/saraa/Downloads/Test Images/Woman.jpg'
    img = Image.open(image_path)
    return img




# Function to predict the output of the model
def predict(model, img):
    output = model(img)
    #print(output)
    # Postprocess predictions if needed
    
    # Get the predicted class
    probabilities, predicted_class = torch.max(output.data, 1)
    predicted_class = predicted_class.item()
    # Display or use predictions as needed
    print(probabilities)
    return predicted_class # Return the output of the model




# Function to convert the input image (binary data) to image object
def convert_to_obj(bytes_img):
    #try:
    # Create a BytesIO object
    bytes_io = io.BytesIO(bytes_img)
    # Use PIL to open the image from BytesIO
    image = Image.open(bytes_io)
    #except Exception as e:
        #print("Error converting image to object:", e)
        #return None
    # Save the image to a file
    #image.save(output_file_path)
    return image
    



# Function to check the validaty of the signed up password
def password_val(password):
    pass





# Function to check the validaty of the signed up email
def email_val(email):
    pass



# Function to load hospitals data from the text file
def load_hospitals_from_file():
    # Print the current working directory
    current_directory = os.getcwd()
    print("Current working directory:", current_directory)
    # File path to your hospitals data file
    hospitals_file = 'Backend/burn_hospitals_egypt.txt'
    # Specify the full path to the Hospitals file
    hospitals_full_path = os.path.join(current_directory, hospitals_file)
    with open(hospitals_full_path, 'r', encoding='utf-8') as file:
        content = file.read()
        # Remove 'burn_hospitals_egypt =' and any trailing/leading whitespace
        content = content.replace('burn_hospitals_egypt =', '').strip()
        # Parse the content as JSON
        hospitals = json.loads(content)
    return hospitals





# Function to calculate the distance between two points using the Haversine formula
def haversine(lon1, lat1, lon2, lat2):
    R = 6371.0  # Earth radius in kilometers
    lon1_rad = math.radians(lon1)
    lat1_rad = math.radians(lat1)
    lon2_rad = math.radians(lon2)
    lat2_rad = math.radians(lat2)

    dlon = lon2_rad - lon1_rad
    dlat = lat2_rad - lat1_rad

    a = math.sin(dlat / 2)**2 + math.cos(lat1_rad) * math.cos(lat2_rad) * math.sin(dlon / 2)**2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    distance = R * c

    return distance





# Load hospitals data
hospitals = load_hospitals_from_file()
# print(hospitals)