import re
import os
import base
import base64
import model
import torch.nn as nn
import functions as func
from datetime import date
from torchvision import models
from models.burn_item import Burn
from models.user_class import User
from sqlalchemy.exc import IntegrityError
from flask_socketio import SocketIO, emit
from  sqlalchemy.exc import OperationalError
from flask import Flask, request, jsonify, render_template
from my_tokens import SECRET_KEY, SQLALCHEMY_DATABASE_URI as URI
from werkzeug.security import generate_password_hash, check_password_hash



############################
""" img = func.load_img()
print(img, type(img))
# Pass the Image to the model
IMAGE_DATA = func.transform(img)
model = func.load_model()
output = func.predict(model, IMAGE_DATA)
print(output, type(output))  """
#########################



app = Flask(__name__)
app.config['SECRET_KEY'] = SECRET_KEY
app.config['SQLALCHEMY_DATABASE_URI'] = URI
# postgresql://ehr_user:ERx4cIQJTRXrZBJE2NVMTY0oDnIuJK41@dpg-cn4ka80cmk4c73emrvd0-a.oregon-postgres.render.com/ehr

socketio = SocketIO(app, cors_allowed_origins='*')

db = base.db
db.init_app(app)



# Route to get the username and password in the login screen
@app.route('/', methods = ['POST'])
def intro():
    # Move to login screen
    response = {'response': 'Log In page'}
    return jsonify(response)



# Route to get the username and password in the login screen
@app.route('/login', methods = ['POST'])
def login_info():
    # Get the data from the Json dictionary
    username = request.form.get('username')
    password = request.form.get('password')

    print('Log In Route,' ,f'Username: {username}', f'Password: {password}')

    user = User.query.filter_by(username=username).first()

    #print(user.email)
    #print(user.username)
    #print("User's Password:", user.password)
    #hashed_password = generate_password_hash(password, method='pbkdf2')
    #print('Entered Password:', hashed_password)
    #print(check_password_hash(user.password, hashed_password))

    # User Doesn't exist
    if not user:
        print("Login Failed, Username doesn't exist", f'Entered Username: {username}', f'Entered Password: {password}')
        # Send a JSON response back to the client
        response = {'response': 'Access Denied'}
        return jsonify(response)        # Login failed
    # Check if the entered password and the stored password matches
    if (not check_password_hash(user.password, password)):
        print('Login Failed, Wrong Password', f'Entered Username: {username}', f'Entered Password: {password}')
        # Send a JSON response back to the client
        response = {'response': 'Access Denied'}
        return jsonify(response)        # Login failed
    # Log In was Successful
    else:
        print('Success, 'f'Username: {username}', f'Password: {password}')
        # Send a JSON response back to the client
        response = {'response': 'Access Allowed', 'user': user}
        return jsonify(response)
        


# A route for the sign up screen
@app.route('/signup', methods = ['POST'])
def signup_info():

    regex_1 = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b'
    regex_2 = re.compile('[@_!#$%^&*()<>?/\|}{~:]')
    data = request.form
    firstname = data.get('firstname').strip()
    lastname  = data.get('lastname').strip()
    email     = data.get('email').strip()
    password  = data.get('password').strip()

    # Password Validation
    capital = any(char.isupper() for char in password)
    small = any(char.islower() for char in password)
    special_character = bool(regex_2.search(password))
    email_val, pass_val = 0, 0

    # Check the password for small, capital & special characters
    if capital and small and special_character:
        pass_val = 1    # Set flag to true
    # Check the email format
    if(re.fullmatch(regex_1, email)):
        email_val = 1   # Set flag to true

    print('Sign Up Information, 'f'Username: {firstname} {lastname}', f'Email: {email}', f'Password: {password}')
    print(f'Email: {bool(re.fullmatch(regex_1, email))}')
    print(f'Capital: {capital}')
    print(f'Small: {small}')
    print(f'Special Character: {special_character}')

    # Both, Email & Password don't match the criteria
    if (not pass_val) and (not email_val):
        print('Sign Up Failed Due to Password & Email')
        response = {'response': 'Failed Password and Email'}
        return jsonify(response)
    # Password doesn't match the criteria
    if not pass_val:
        print('Sign Up Failed Due to Password')
        print(f'Failed Password: {password}')
        response = {'response': 'Failed Password'}
        return jsonify(response)
    # Email doesn't match the criteria
    if not email_val:
        print('Sign Up Failed Due to Email')
        response = {'response': 'Failed Email'}
        return jsonify(response)
    # Email & Password accepted
    else:
        print('Signed Up Successfully, 'f'Username: {firstname} {lastname}', f'Email: {email}', f'Password: {password}')
        hashed_password = generate_password_hash(password, method='pbkdf2')
        print('Hashed Password is: ', hashed_password)

        # Check if the email already exists
        if User.query.filter_by(email=email).first():
            print('Sign Up Failed Due to Duplicate Email')
            response = {'response': 'Failed: Email already exists'}
            return jsonify(response)
        # Email doesn't exist
        else:
            # add info from form to user
            new_user = User(
            username = f'{firstname} {lastname}', 
            password = hashed_password,
            email = email,
            phone = 1224355, #'None'
            weight = 50,#'None'
            height = 170, #'None'
            gender = 'M', #'None'
            dob = date(2020,4,2),#'None'
            profession = 'None'
            )
            
            try:
                db.session.add(new_user)
                db.session.commit()
                print('user id: ', new_user.id) # Get user ID
                response = {'response': 'Signup successful'}
            except OperationalError:
                print('Operational Error Encountered')
            except IntegrityError:
                db.session.rollback()   # Rollback the transaction
                print('Integrity Error: User with this email already exists')
                response = {'response': 'Email already exists'}
            except Exception as e:
                db.session.rollback()
                print(f'Error during signup: {str(e)}')
                response = {'response': 'Internal Server Error'}
            return jsonify(response)




# Route to receive the burn image from user and return the model's prediction
@app.route('/uploadImg', methods=['POST'])
def upload():
    my_model = model.MyModel(3) 
    degrees = {0: 'First Degree Burn',
               1: 'Second Degree Burn',
               2: 'Third Degree Burn'
               }
    if 'file' not in request.files:
        return jsonify({'error': 'No selected file'})    # 'No file part'
    # Get the Image
    file = request.files['file']
    if file:
        IMAGE_DATA = request.form['Image']      # Will be stored in the database as a string
        # Decode the base64 encoded string (Image) back to binary data
        IMAGE_DATA = base64.b64decode(IMAGE_DATA)   # Image to be stored in the database as blob file
        print('Image Sent with Data: ', IMAGE_DATA)
        print('Data Type: ', type(IMAGE_DATA))
        #IMAGE_DATA = convert_to_obj(IMAGE_DATA, output_file_path)   # Convert binary data to image object (if needed)
        # Pass the Image to the model
        IMAGE_DATA = func.transform(IMAGE_DATA)
        model = func.load_model()
        output = func.predict(model, IMAGE_DATA)
        prediction = {'prediction': degrees[output]}

        return jsonify(prediction) , 200        #return 'File uploaded successfully' 
    
    
""" if file.filename == '':
        return  
    if file:
        # Read and preprocess the image
        image = Image.open(io.BytesIO(file.read()))
 """



if __name__ == "__main__":
    # app.run(debug=True, port= 19999)        # Modify the Port number to avoid any conflicts with available ports
    app.run() 


