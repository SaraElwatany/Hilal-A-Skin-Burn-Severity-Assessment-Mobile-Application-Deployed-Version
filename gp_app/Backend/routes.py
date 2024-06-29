import re
import random
import base64
import numpy as np
import torch.nn as nn
from datetime import date
from torchvision import models
from datetime import datetime
from sqlalchemy.exc import IntegrityError
from sqlalchemy.exc import OperationalError
from flask import Blueprint, redirect, url_for, Flask, request, jsonify, render_template, session
from werkzeug.security import generate_password_hash, check_password_hash




from .base import db
from .burn_item import Burn
from .user_class import User
from .chat_message import ChatMessage

from .model import MyModel
from .functions import load_img, transform, load_model, predict, convert_to_obj, load_hospitals_from_file, haversine



main = Blueprint('main', __name__)



# Route to get the username and password in the login screen
@main.route('/', methods = ['POST'])
def intro():
    # Move to login screen
    response = {'response': 'Log In page'}
    print('Hello there, I am Hilal')
    return jsonify(response)





# Route to get the username and password in the login screen (Done)
@main.route('/login', methods = ['POST'])
def login_info():

    # Get the data from the Json dictionary
    email = request.form.get('email').strip().replace(" ", "")  # Remove spaces from email
    password = request.form.get('password').strip().replace(" ", "")  # Remove spaces from email

    # Convert email to lowercase
    email = email.lower()

    print('Log In Route,' ,f'email: {email}', f'Password: {password}')

    user = User.query.filter_by(email=email).first()

    #print(type(user.id))
    #print(user.email)
    #print(user.username)
    #print("User's Password:", user.password)
    #hashed_password = generate_password_hash(password, method='pbkdf2')
    #print('Entered Password:', hashed_password)
    #print(check_password_hash(user.password, hashed_password))

    # User Doesn't exist
    if not user:
        print("Login Failed, Email doesn't exist", f'Entered Email: {email}', f'Entered Password: {password}')
        # Send a JSON response back to the client
        response = {'response': 'Access Denied'}
        return jsonify(response)        # Login failed
    # Check if the entered password and the stored password matches
    if (not check_password_hash(user.password, password)):
        print('Login Failed, Wrong Password', f'Entered Email: {email}', f'Entered Password: {password}')
        # Send a JSON response back to the client
        response = {'response': 'Access Denied'}
        return jsonify(response)        # Login failed
    # Log In was Successful
    else:
        print('Success, 'f'Email: {email}', f'Password: {password}')
        # Send a JSON response back to the client
        response = {'response': 'Access Allowed', 'user_id': user.id, 'user_profession': user.profession}
        # USER_ID = user.id
        # session['user_id'] = user.id  # Store user ID in session
        return jsonify(response)
    




# A route for the sign up screen (Done)
@main.route('/signup', methods = ['POST'])
def signup_info():

    regex_1 = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b'
    regex_2 = re.compile('[@_!#$%^&*()<>?/\|}{~:]')
    data = request.form
    firstname = data.get('firstname').strip()
    lastname  = data.get('lastname').strip()
    email     = data.get('email').strip().replace(" ", "")  # Remove spaces from email
    password  = data.get('password').strip().replace(" ", "")  # Remove spaces from email

    # Convert email to lowercase
    email = email.lower()

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
            profession = 'patient'
            )
            
            try:
                db.session.add(new_user)
                db.session.commit()
                print('user id: ', new_user.id) # Get user ID
                # USER_ID = new_user.id
                # session['user_id'] = new_user.id    # Store new signed up user ID in session
                response = {'response': 'Signup successful', 'user_id': new_user.id}
            except OperationalError:
                print('Operational Error Encountered')
            except IntegrityError:
                db.session.rollback()   # Rollback the transaction
                print('Integrity Error: User with this email already exists')
                response = {'response': 'Email already exists', 'user_id': 0}
            except Exception as e:
                db.session.rollback()
                print(f'Error during signup: {str(e)}')
                response = {'response': 'Internal Server Error', 'user_id': 0}
            return jsonify(response)





# A route for the sign up screen (Done)
@main.route('/doctorsignup', methods = ['POST'])
def doctor_signup_info():

    regex_1 = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b'
    regex_2 = re.compile('[@_!#$%^&*()<>?/\|}{~:]')
    data = request.form
    firstname = data.get('firstname').strip()
    lastname  = data.get('lastname').strip()
    email     = data.get('email').strip().replace(" ", "")  # Remove spaces from email
    password  = data.get('password').strip().replace(" ", "")  # Remove spaces from email
    speciality  = data.get('speciality').strip()

    # Convert email to lowercase
    email = email.lower()

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
            speciality= speciality,
            profession = 'doctor'
            )
            
            try:
                db.session.add(new_user)
                db.session.commit()
                print('user id: ', new_user.id) # Get user ID
                # USER_ID = new_user.id
                # session['user_id'] = new_user.id    # Store new signed up user ID in session
                response = {'response': 'Signup successful', 'user_id': new_user.id}
            except OperationalError:
                print('Operational Error Encountered')
            except IntegrityError:
                db.session.rollback()   # Rollback the transaction
                print('Integrity Error: User with this email already exists')
                response = {'response': 'Email already exists', 'user_id': 0}
            except Exception as e:
                db.session.rollback()
                print(f'Error during signup: {e}')
                response = {'response': 'Internal Server Error', 'user_id': 0}
            return jsonify(response)





# Route to receive the burn image from user and return the model's prediction as well as the burn id  (Done)
@main.route('/uploadImg', methods=['POST'])
def upload():

    # BURN_ID, USER_ID, prediction variables
    BURN_ID, USER_ID, prediction  = 0, 0, {} 

    print('Entered UploadImg Route')

    #my_model = model.MyModel(3)
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
        #IMAGE_DATA = base64.b64decode(IMAGE_DATA)   # Image to be stored in the database as blob file
        #print('Image Sent with Data: ', IMAGE_DATA)
        #print('Data Type: ', type(IMAGE_DATA))
        #IMAGE_DATA_OBJECT = convert_to_obj(IMAGE_DATA)    # Convert binary data to image object (if needed)
        
        # Get the user_id from the received request 
        # USER_ID = int(request.form['user_id'])  # Cast user id to integer
        # Get the user_id and Image data from the form
        USER_ID = int(request.form.get('user_id', None))
        # image_data = request.form.get('Image', None)
        print('User ID Associated with burn:', USER_ID)
        # user_id = session.get('user_id')
        # print('User ID Associated with burn:', user_id)

        # Read the image file 
        print('The file received from App: ', file)
        # Read image data as bytes
        image_data = file.read()        # BLOB File 
        print('burn_img is a file with type:', type(image_data))
        image = convert_to_obj(image_data)
        #image = np.array(image)
        # Preprocess the image (if needed)
        IMAGE_DATA_OBJECT = transform(image)
        # Pass image to the model for inference
        #model = load_model()
        #output = predict(model, IMAGE_DATA_OBJECT)
        output = 0
        prediction = {'prediction': degrees[output]}
        print("Model's output:", output)
        print("Model's prediction:", prediction['prediction'])
        # Initialize the burn_id variable & dictionary
        burn_id_dict = {}

        # Try To Get the user associated with that id, if error encountered then the user is a guest
        # If the user already exists
        if User.query.filter_by(id=USER_ID).first():
            print('Creating a new burn item for the pre-existing/signed up user......')
            # create new burn item and add to db
            new_burn = Burn(
                            fk_burn_user_id = USER_ID,
                            burn_date = date.today(),
                            burn_img = image_data,
                            burn_class_model = int(output),
                            trembling_limbs = 0, #'None'
                            nausea = 0, #'None'
                            diarrhea = 0, #'None'
                            cold_extremities = 0, #'None'
                            burn_type = 'None', #'None'
                            burn_place = 'None' #'None'
                            )
            
            # get the burn id for the already existed user
            #burn_id = new_burn.burn_id
            # add burn item to db
            db.session.add(new_burn)
            db.session.commit()

        # If the user doesn't exist then it is a guest & autoincrement the burn id
        else:
            print('Burn Item received from guest')
            print('No User Was Found with an associated ID, creating a new burn item for the guest user......')
            # create a new burn item and add to db
            new_burn = Burn(
                            #fk_burn_user_id = USER_ID,  # USER_ID, No USER ID FOUND
                            burn_date = date.today(),
                            burn_img = file,
                            burn_class_model = int(output),
                            trembling_limbs = 0, #'None'
                            nausea = 0, #'None'
                            diarrhea = 0, #'None'
                            cold_extremities = 0, #'None'
                            burn_type = 'None', #'None'
                            burn_place = 'None' #'None'
                            )

            # get the burn id for the guest user
            # burn_id = new_burn.burn_id
            # add burn item to db
            db.session.merge(new_burn)
            db.session.commit() 

            #print("Associated burn_id 1: ", str(burn_id))


        # get the burn id of the latest added burn item for user/guest 
        latest_user = Burn.query.order_by(Burn.burn_id.desc()).first()
        BURN_ID = latest_user.burn_id

        # Create a dictionary for the burn id
        burn_id_dict = {'burn_id': str(BURN_ID)}
        print("Associated burn_id 2: ", str(BURN_ID))

        response = {**burn_id_dict, **prediction}

        return jsonify(response)
    
    



# Add Burn item route (Patient Screen) (Done)
@main.route('/add_burn', methods=['POST'])
def burn_new():

    # BURN_ID, USER_ID, prediction Variables
    BURN_ID, USER_ID = 0, 0

    if request.method == 'POST':

        print('Burn Item Received')
        data = request.form
        print('Clinical Data: ', data)

        trembling_limbs, cold_extremities, diarrhea, nausea, burn_type, burn_place = 0, 0, 0, 0, 'None', 'None'

        if not data:
            return jsonify({'response': 'Failed to Load info...'})    

        BURN_ID = int(request.form['burn_id'])  # Cast user id from string to integer
        print('Received Burn ID: ', BURN_ID)
        USER_ID = int(request.form['user_id']) # Cast user id from string to integer
        print('Received USER_ID ID: ', USER_ID)
        # Get the latest burn item added for that user
        # user = Burn.query.filter_by(fk_burn_user_id=USER_ID).order_by(Burn.burn_id.desc()).first()

        # Parse the received data
        if 'cold_extremities' in data: cold_extremities = 1
        else: cold_extremities = 0
        if 'trembling_limbs' in data: trembling_limbs = 1
        else: trembling_limbs = 0
        if 'nausea' in data: nausea = 1
        else: nausea = 0
        if 'diarrhea' in data: diarrhea = 1
        else: diarrhea = 0
        if 'Cause of Burn' in data: burn_type = data['Cause of Burn']
        else: burn_type = 'None'
        if 'Place of Burn' in data: burn_place = data['Place of Burn']
        else: burn_place = 'None'

        print('Nausea: ', nausea)
        print('Burn Type: ', burn_type)
        print('Burn Place: ', burn_place)

        # Check if burn item already exists 
        if Burn.query.filter_by(burn_id=BURN_ID).first(): 
            user = Burn.query.filter_by(burn_id=BURN_ID).first()
            # Print the user id if it exists
            try:
                # USER_ID = user.fk_burn_user_id
                print('Updated the Clinical Data For Signed Up User With ID: ', USER_ID)
            # Update Clinical Data For Signed Up & GUESTS Users 
            finally:
                # add symptoms (clinical data) if sent
                user.trembling_limbs = trembling_limbs
                user.nausea = nausea
                user.diarrhea = diarrhea
                user.cold_extremities = cold_extremities
                user.burn_type = burn_type
                user.burn_place = burn_place

            db.session.commit()

        # For the emulator
        else:
            print('No User Found, creating a new burn item for the guest user......')

            # create a new burn item and add to db
            new_burn = Burn(
            #fk_burn_user_id = USER_ID,  # USER_ID
            burn_date = date.today(),
            burn_img = None,
            burn_class_model = 0,
            trembling_limbs = trembling_limbs, #'None'
            nausea = nausea, #'None'
            diarrhea = diarrhea, #'None'
            cold_extremities = cold_extremities, #'None'
            burn_type = burn_type, #'None'
            burn_place = burn_place #'None'
            )

            # add burn item to db
            db.session.merge(new_burn)
            db.session.commit() 

        return jsonify({'response': 'Success'})  






# Fetch info of all users with burns (Doctor Screen)
@main.route('/get_all_burns', methods=['POST'])
def get_all_burns():

    print("fetching users with burns...")

    # Get all users from the Burn table
    users = Burn.query.all()
    print('Users: ', users)

    # Check if each user from Burn table exists in Users table
    user_list = []

    # build a dictionary of the users
    for burn_user in users:
        user_in_users_table = User.query.filter_by(id=burn_user.fk_burn_user_id).first()
        if user_in_users_table:
            user_dict = {
                         'id': user_in_users_table.id,
                         'username': user_in_users_table.username, 
                         'email': user_in_users_table.email, 
                         'phone': user_in_users_table.phone, 
                         'weight': user_in_users_table.weight, 
                         'height': user_in_users_table.height
                        }
            user_list.append(user_dict)
        else:
            # Generate a random integer for the guest user
            last_user = User.query.order_by(User.id.desc()).first()
            last_user_id = last_user.id
            user_dict = {
                         'id': last_user_id+1,
                         'username': 'Guest', 
                         'email': 'None', 
                         'phone': None, 
                         'weight': None, 
                         'height': None
                        }
            user_list.append(user_dict)


    print('User lists found', user_list)

    user_ids = [user.get('id') for user in user_list] 
    user_names = [user.get('username') for user in user_list]
    user_info = ['Email: '+str(user.get('email')) for user in user_list]
    # user_info = ['email: '+str(user.get('email'))+' '+'Height: '+str(user.height) for user in users]

    # return the user list
    return {
            'message': 'Users with burns found', 
            'user_ids': user_ids, 
            'user_names': user_names, 
            'user_info': user_info 
            }

    


# Fetch info of all signed up doctors (Admin Screen)
@main.route('/get_all_doctors', methods=['POST'])
def get_all_doctors():

    print("fetching all doctors...")
    # Get all doctors from the Users table
    users = User.query.all()
    print('Users: ', users)

    user_list = []
    # build a dictionary of the doctor users' information only
    for user in users:
        # Check if the user is doctor
        if user.profession == 'doctor':
            user_dict = {
                        'id': user.id,
                        'username': user.username, 
                        'email': user.email, 
                        'phone': user.phone, 
                        'weight': user.weight, 
                        'height': user.height,
                        'speciality':user.speciality
                        }
            user_list.append(user_dict)

    print('Doctor User lists found', user_list)
    user_ids = [user.get('id') for user in user_list] 
    user_names = [user.get('username') for user in user_list]
    # user_info = ['Email: '+str(user.get('email'))+' Speciality: '+str(user.get('speciality'))+' Phone: '+str(user.get('phone')) for user in user_list]
    user_info = ['Speciality: '+str(user.get('speciality'))+' Phone: '+str(user.get('phone')) for user in user_list]

    # return the doctor user list
    return {
            'message': 'Users with burns found', 
            'user_ids': user_ids, 
            'user_names': user_names, 
            'user_info': user_info 
            }
    


# Fetch all burns associated with a user
@main.route('/get_user_burns', methods=['POST'])
def get_user_burns():

    if request.method == 'POST':

        degree_map = {
                        0: 'First Degree Burn',
                        1: 'Second Degree Burn',
                        2: 'Third Degree Burn',
                    }

        USER_ID = int(request.form['user_id']) # Cast user id from string to integer
        print('Get burns request received. User ID:', USER_ID)
        print("fetching user's burns...")

        # get the burns associated with the user id
        burn_list = Burn.query.filter_by(fk_burn_user_id=USER_ID).all()
        print('User Burns: ', burn_list)
            
        burn_ids = [burn.burn_id for burn in burn_list] 
        burn_degrees = [degree_map.get(burn.burn_class_model) for burn in burn_list]

        # return the doctor user list
        return {
                'message': 'Burns associated with user was found', 
                'burn_ids': burn_ids, 
                'burn_degrees': burn_degrees
                }








# route for updating burn item 
@main.route('/update_burn', methods=['GET', 'POST'])
def update_burn():
    # check the request method
    if request.method == 'POST':
        data = request.get_json()
        # check that user is doctor and has permission to update this burn item
        user = User.query.filter_by(id=data['id']).first()
        if user.profession != 'doctor' and user.profession != 'admin':
            return {'message': 'Not authorized'}
        else:
            print('update burn request received')
            # get the burn item
            burn = Burn.query.filter_by(burn_id=data['burn_id']).first()
            # update the burn item if the data is not empty
            if data['burn_class_dr'] != '': burn.burn_class_dr = data['burn_class_dr']
            if data['dr_reply'] != '': burn.dr_reply = data['dr_reply']
            # commit the changes to the db
            db.session.commit()
            # return the burn id
            return { 'message': 'Burn item updated',
                    'burn_id': burn.burn_id,
                    'burn_class_dr': burn.burn_class_dr,
                    'dr_reply': burn.dr_reply}

    else: return "error: wrong method"



@main.route('/send_message', methods=['POST'])
def send_message():

    from .__init__ import socketio 

    try:
        data = request.json
        print(f"Received data: {data}")  # Print received data for debugging

        print(f"Message Receiver State For the User: {data['receiver']}")

        if not data:
            return jsonify({'error': 'No data provided'}), 400

        required_keys = ['sender_id', 'receiver_id', 'message', 'receiver']
        for key in required_keys:
            if key not in data:
                return jsonify({'error': f'Missing key: {key}'}), 400

        message = ChatMessage(
            sender_id=data['sender_id'],
            receiver_id=data['receiver_id'],
            message=data['message'],
            receiver=data['receiver'],
            burn_id=data['burn_id'],
            image=data.get('image'),
            timestamp=datetime.now()
        )

        print(message)
        db.session.add(message)
        db.session.commit()

        # if socketio:
        #     socketio.emit('message', message.to_dict())
        # else:
        #     print("SocketIO is not initialized")
        #     return jsonify({'error': 'SocketIO is not initialized'}), 500
        
        return jsonify(message.to_dict()), 201
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'error': str(e)}), 500





# Endpoint to retrieve chat history
@main.route('/get_chat_history', methods=['GET'])
def get_chat_history():
    try:
        sender_id = int(request.args.get('sender_id'))
        receiver_id = int(request.args.get('receiver_id'))
        burn_id = int(request.args.get('burn_id'))

        if (not sender_id) or (not receiver_id) or (not burn_id):
            return jsonify({'error': 'Missing sender_id or receiver_id or burn_id'}), 400
        

        # Fetch the Chat History, and include the model messages
        chat_history = ChatMessage.query.filter(
            ((ChatMessage.sender_id == sender_id) & (ChatMessage.receiver_id == receiver_id))
            | ((ChatMessage.sender_id == receiver_id) & (ChatMessage.receiver_id == sender_id))
            | ((ChatMessage.sender_id == 3) & (ChatMessage.receiver_id == sender_id)) # Include messages where sender_id is 3 , represents the model
        ).order_by(ChatMessage.timestamp.asc()).all()


        for message in chat_history:
            print(f"Message: {message.message}, Sender: {message.sender_id}, Receiver: {message.receiver_id}, Burn: {message.burn_id}")
            # Modify the receiver field according to the user id to adjust the message color
            if message.sender_id != sender_id:    # if the sender of the message wasn't the user
                message.receiver = False
            else:
                message.receiver = True

        return jsonify([message.to_dict() for message in chat_history]), 200

    except Exception as e:
            print(f"Error: {e}")
            return jsonify({'error': str(e)}), 500




# @main.route('/upload_audio', methods=['POST'])
# def upload_file():
#     if 'file' not in request.files:
#         return 'No file part'
#     file = request.files['file']
#     if file.filename == '':
#         return 'No selected file'
#     if file:
#         filename = secure_filename(file.filename)
#         file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
#         return 'File uploaded successfully'






# Route to Get the user Location
@main.route('/get_user_location', methods=['POST'])
def get_user_location():

    user_lat, user_lon = 0.0 , 0.0

    user_lat = float(request.args.get('user_latitude', 0))
    user_lon = float(request.args.get('user_longitude', 0))

    print('Received Latitude: ', user_lat)
    print('Received Longitude: ', user_lon)

    if user_lat == 0 or user_lon == 0:
        return jsonify({"error": "Invalid coordinates"}), 400
    

    # Prepare JSON response
    response = { "message": "User Location Successfully Identified",
               }

    return jsonify(response)





# Route to Get the Top 5 Nearest Burn Hospitals to the user & the model's prediction
@main.route('/respond_to_user', methods=['POST'])
def respond_to_user():

    user_lat, user_lon = 0.0, 0.0

    user_lat = float(request.args.get('user_latitude', 0))
    user_lon = float(request.args.get('user_longitude', 0))

    # Load hospitals data
    hospitals = load_hospitals_from_file()

    if user_lat == 0 or user_lon == 0:
        return jsonify({"error": "Invalid coordinates"}), 400

    # Calculate distance from user's location to each hospital
    for hospital in hospitals:
        hospital['distance'] = haversine(user_lon, user_lat, hospital['lon'], hospital['lat'])

    # Sort hospitals by distance
    hospitals_sorted = sorted(hospitals, key=lambda x: x['distance'])

    # Get the top 5 nearest hospitals
    nearest_hospitals = hospitals_sorted[:5]

    # Prepare JSON response
    response = {
                "message": "Top 5 nearest burn hospitals:",
                "hospitals": nearest_hospitals,
                }

    return jsonify(response)





# Logout route
@main.route('/logout', methods=['POST'])
def logout():
    print('Logged out successfully & Cleared Session')
    return jsonify({'response': 'Logged out successfully'})