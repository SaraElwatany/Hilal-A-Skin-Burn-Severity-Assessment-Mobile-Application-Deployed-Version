from flask import Flask, request, jsonify, render_template
from werkzeug.security import generate_password_hash, check_password_hash
from my_tokens import SECRET_KEY, SQLALCHEMY_DATABASE_URI as URI
from flask_socketio import SocketIO, emit
from models.user_class import User
from datetime import datetime, timedelta
import base
import re



app = Flask(__name__)
app.config['SECRET_KEY'] = SECRET_KEY
app.config['SQLALCHEMY_DATABASE_URI'] = URI

socketio = SocketIO(app, cors_allowed_origins='*')

db = base.db
db.init_app(app)
    
   

# Route to get the username and password in the login screen
@app.route('/login', methods = ['POST'])
def login_info():
    # Get the data from the Json dictionary
    username = request.form.get('username')
    password = request.form.get('password')

    print('Log In Route,' ,f'Username: {username}', f'Password: {password}')

    user = User.query.filter_by(username= username).first()

    # Check if the username and password matches
    if not user or not check_password_hash(user.password, password):
        print('Fail', f'Username: {username}', f'Password: {password}')
        # Send a JSON response back to the client
        response = {'response': 'Access Denied'}
        return jsonify(response)        # Login failed
    else:
        print('Success, 'f'Username: {username}', f'Password: {password}')
        # Send a JSON response back to the client
        response = {'response': 'Access Allowed'}
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

    email_val = 0
    pass_val = 0

    if capital and small and special_character:
        pass_val = 1

    if(re.fullmatch(regex_1, email)):
        email_val = 1

    print('Sign Up Information, 'f'Username: {firstname} {lastname}', f'Email: {email}', f'Password: {password}')
    print(f'Email: {bool(re.fullmatch(regex_1, email))}')
    print(f'Capital: {capital}')
    print(f'Small: {small}')
    print(f'Special Character: {special_character}')

    if (not pass_val) and (not email_val):
        response = {'response': 'Failed Password and Email'}
        return jsonify(response)

    if not pass_val:
        print(f'Failed Password: {password}')
        response = {'response': 'Failed Password'}
        return jsonify(response)

    if not email_val:
        response = {'response': 'Failed Email'}
        return jsonify(response)
    
    print('Signed Up Successfully, 'f'Username: {firstname} {lastname}', f'Email: {email}', f'Password: {password}')

    hashed_password = generate_password_hash(password, method='pbkdf2')
    print('password is: ', hashed_password)

    # Define target format
    format_string = "%Y-%m-%d"
    # Generate a random date
    current_date = datetime.now()
    # Format the date
    formatted_date = current_date.strftime(format_string)

    # add info from form to user
    new_user = User(
        username = f'{firstname} {lastname}', 
        password = hashed_password,
        dob = formatted_date,#'None'
        gender = 'N',
        height = int(170), #'None'
        weight = int(50),#'None'
        phone = int(122), #'None'
        email = email,
        profession = 'None'
        )
    
    db.session.add(new_user)
    #db.session.commit()
    print('user id: ', new_user.id) # Get user ID

    response = {'response': 'Signup successful'}
    return jsonify(response)






if __name__ == "__main__":
    app.run(debug=True, port= 19999)        # Modify the Port number to avoid any conflicts with available ports