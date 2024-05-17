from dotenv import load_dotenv
import os

load_dotenv()

print(os.getenv('SECRET_KEY'))
print(os.getenv('SQLALCHEMY_DATABASE_URI'))
