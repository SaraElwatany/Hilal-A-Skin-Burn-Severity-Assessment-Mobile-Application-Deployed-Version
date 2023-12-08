from flask import Flask, render_template, request
from werkzeug.security import generate_password_hash, check_password_hash
from my_tokens import SECRET_KEY, SQLALCHEMY_DATABASE_URI as URI
import base

app = Flask(__name__)
app.config['SECRET_KEY'] = SECRET_KEY
app.config['SQLALCHEMY_DATABASE_URI'] = URI

db = base.db
db.init_app(app)
from models.user_class import User

# for web based testing only, COMMENT WHEN DONE
@app.route('/')
def index():
    return render_template('index.html')




@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        print('request received')
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
        return {'message': 'New user created'}
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



# from flask import Flask
# from flask import render_template
# from flask_sqlalchemy import SQLAlchemy
# from my_tokens import SECRET_KEY, SQLALCHEMY_DATABASE_URI as URI 

# # This part is validation for the web app
# from flask_wtf import FlaskForm
# from wtforms import StringField, SubmitField
# from wtforms.validators import DataRequired
# from flask import flash


# @app.route('/signin', methods=['GET', 'POST'])
# def signin():
#     username = None
#     form = UserForm()

#     if form.validate_on_submit():
#         username = form.username.data
#         form.username.data = ''
#         flash('!!!!!!Your username is {}'.format(username))

#     return render_template('signin.html'
#                            , username=username
#                            , form=form)

# class UserForm(FlaskForm):
#     username = StringField(label='Enter username', validators=[DataRequired()])
#     email = StringField(label='Enter email', validators=[DataRequired()])
#     submit = SubmitField('Submit')



# app = Flask(__name__)

# # mysql URI
# app.config['SQLALCHEMY_DATABASE_URI'] = URI
# app.config['SECRET_KEY'] = SECRET_KEY
# db = SQLAlchemy(app)





# @app.route('/')
# def index():
#     return render_template('index.html')


# if __name__ == "__main__":
#     app.run()





