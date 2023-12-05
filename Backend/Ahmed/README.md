# Hilal_MobileApplication

## flask application with mySQL

### How to run
before everything, create a `my_tokens.py` file with the following arrtibutes.
`SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://<username>:<pssword>@host/<database>'
mysql_username = username
mysql_password = password
SECRET_KEY = secre_key`

make sure to replace dummy values with real values


1. To run the MySQL server, open command line, run `services.msc` 
2. find the MySQL80 service, right click and choose start
3. Open mysql command line or mysql workbench and connect to the local instance.
4. Run the "Final_schema.sql" file to create your database.


### Naming conventions
- Foreign Keys:

FK_[اللي احنا فيه]_[الأصلي]_[referenced column]

example: in the burn table, the foreign key would be named fk_burn_user_id