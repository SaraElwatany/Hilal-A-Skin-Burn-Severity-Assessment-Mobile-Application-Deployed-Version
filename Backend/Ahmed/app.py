import datetime
from flask import Flask, render_template, request
from werkzeug.security import generate_password_hash, check_password_hash
from my_tokens import SECRET_KEY, SQLALCHEMY_DATABASE_URI as URI
import base
# from flask_login import UserMixin, LoginManager, login_user, logout_user, login_required
from models.user_class import User
from models.burn_item import Burn

app = Flask(__name__)
# database config
app.config['SQLALCHEMY_DATABASE_URI'] = URI
db = base.db
db.init_app(app)


# for web based testing only, COMMENT WHEN DONE
@app.route('/')
def index():
    return render_template('index.html')

# users with burn route
@app.route('/get_users', methods=['GET', 'POST'])
def get_users():
    # check that request is from doctor

    # check the request method
    if request.method == 'GET':
        # check in the burn table for users with burns
        burn_list = Burn.query.all()
        user_list = [burn.fk_burn_user_id for burn in burn_list]
        user_list = list(dict.fromkeys(user_list)) # remove duplicates
        # convert the list to a dictionary
        user_list = [{
            'id': user,
            'username': User.query.filter_by(id=user).first().username,
            'dob': User.query.filter_by(id=user).first().dob,
            'weight': User.query.filter_by(id=user).first().weight,
            'height': User.query.filter_by(id=user).first().height
            } for user in user_list]
        # return the user list
        return { 'message': 'Users found', 'users': user_list}
    else: return "error: wrong method"


# burn item route
@app.route('/add_burn', methods=['GET', 'POST'])
def burn_new():
    if request.method == 'POST':
        print('burn item received')
        data = request.get_json()
        # create new burn item and add to db
        new_burn = Burn(
            fk_burn_user_id = data['fk_burn_user_id'],
            burn_date = data['burn_date'],
            burn_img_path = data['burn_img_path']
        )
        # Model prediction goes here

        # add burn item to db
        db.session.add(new_burn)
        db.session.commit()
        # return the burn id
        return { 'message': 'New burn item created', 'id': new_burn.burn_id}
    else: return "error: wrong method"

# fetch burns associated with a user
@app.route('/get_burns', methods=['GET', 'POST'])
def get_burns():
    if request.method == 'POST':
        print('get burns request received. User ID:', request.get_json()['fk_burn_user_id'] )
        data = request.get_json()
        # get the burns associated with the user id
        burn_list = Burn.query.filter_by(fk_burn_user_id=data['fk_burn_user_id']).all()

        # build a dictionary of the burns
        burn_list = [{
            'burn_id': burn.burn_id, 
            'fk_burn_user_id': burn.fk_burn_user_id,
            'burn_date': burn.burn_date, 
            'burn_img_path': burn.burn_img_path, 
            'dr_id': burn.dr_id,
            'burn_class_dr': burn.burn_class_dr,
            'burn_class_model': burn.burn_class_model,
            'dr_reply': burn.dr_reply,
            }
                 for burn in burn_list] 
        # return the burn list
        return { 'message': 'Burns found', 'burns': burn_list}
    else: return "error: wrong method"

# Signup route
@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        print('signup request received')
        data = request.get_json()
        
        # print the conent of the JSON
        # print(data)

        hashed_password = generate_password_hash(data['password'],method='pbkdf2')
        print('password is ', hashed_password)
        # add info from form to user
        new_user = User(
            username = data['username'], 
            password = hashed_password,
            email = data['email'],
            phone = data['phone'], 
            weight = data['weight'],
            height = data['height'], 
            gender = data['gender'],
            dob = data['dob'],
            profession = data['profession']
            )
        db.session.add(new_user)
        db.session.commit()
        print('user id: ', new_user.id) 
        # return the user id
        return { 
            'message': 'New user created',
            'username': new_user.username,
            'id': new_user.id}
    else: return "error: wrong method"

# login route
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    # print the conent of the JSON
    print(data)
    
    user = User.query.filter_by(username=data['username']).first()
    if not user or not check_password_hash(user.password, data['password']):
        return {'message': 'Login failed'}
    return {'message': 'Login successful'}



if __name__ == "__main__":
    app.run()
