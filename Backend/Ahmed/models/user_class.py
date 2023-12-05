from flask_sqlalchemy import SQLAlchemy
from base import db

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    username = db.Column(db.String(255), nullable=False)
    password = db.Column(db.String(128), nullable=False)

    phone = db.Column(db.Integer, nullable=True, default=None)
    email = db.Column(db.String(255), nullable=True, default=None)

    dob = db.Column(db.Date, nullable=False , default=None)
    gender = db.Column(db.String(1), nullable=False)
    height = db.Column(db.Integer, nullable=True, default=None)
    weight = db.Column(db.Integer, nullable=True, default=None)
  
    profession = db.Column(db.String(20), nullable=False, default='patient')
    
    # # Create a cursor object to execute SQL queries
    # cursor = db.cursor()

    
    # # Prepare the SQL query to insert a new user into the table
    # query = "INSERT INTO users (username, password, age, gender, dob, weight, height, profession) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
    # values = (self.username, self.password, self.age, self.gender, self.dob, self.weight, self.height, self.profession)

    # # Execute the SQL query
    # cursor.execute(query, values)

    # # Commit the changes to the database
    # db.commit()

    # # Close the cursor and database connection
    # cursor.close()
    # db.close()
