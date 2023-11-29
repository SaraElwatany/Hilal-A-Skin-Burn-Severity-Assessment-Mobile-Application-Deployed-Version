
from flask import Flask, request, jsonify


app = Flask(__name__)



# Trial route
@app.route('/api', methods = ['GET'])
def get_sign_in_info():
    dictionary = {}
    if request.method == 'GET':
        signin_info = str(request.args['query'])  
        print(type(signin_info))
        dictionary['output'] = 10
        return signin_info
    else:
        return 'Hello from Post'
    

# Route to get the username and password
@app.route('/login', methods = ['POST'])
def login_info():
    username = request.form.get('username')
    password = request.form.get('password')

    print('Route' ,f'Username: {username}', f'Password: {password}')

    # Check if the username and password match
    if username == 'admin' and password == 'password':
        print('Success, 'f'Username: {username}', f'Password: {password}')
        # Login successful
        return 'Login successful'
    else:
        print('Fail', f'Username: {username}', f'Password: {password}')
        # Login failed
        return 'Login failed'



if __name__ == "__main__":
    app.run(debug=True, port= 19999)        #