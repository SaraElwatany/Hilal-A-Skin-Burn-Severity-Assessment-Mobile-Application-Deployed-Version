from flask import Flask, render_template, request
from werkzeug.security import generate_password_hash, check_password_hash
from my_tokens import SECRET_KEY, SQLALCHEMY_DATABASE_URI as URI
import base

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = URI

db = base.db
db.init_app(app)
from models.user_class import User
from models.burn_item import Burn

# for web based testing only, COMMENT WHEN DONE
@app.route('/')
def index():
    return render_template('index.html')


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
        db.session.add(new_burn)
        db.session.commit()
        print('burn id: ', new_burn.burn_id)
        # return the burn id
        return { 'message': 'New burn item created', 'id': new_burn.burn_id}
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
