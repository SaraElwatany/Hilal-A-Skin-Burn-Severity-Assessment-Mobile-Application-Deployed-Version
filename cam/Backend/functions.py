import io
from google.oauth2 import service_account
from googleapiclient.discovery import build
from google.auth.transport.requests import Request
from googleapiclient.http import MediaIoBaseUpload




# Define the scopes required for accessing Google Drive
SCOPES = ['https://www.googleapis.com/auth/drive.file']
# Define the service account required for accessing Google Drive
SERVICE_ACCOUNT_FILE = 'D:/Graduation Project/PatientAssistantMobileApplication/cam/Backend/service_account.json'
# Define the ID of the Google Drive folder
PARENT_FOLDER_ID = "1H_y12h_m_B5C4ZWF1DvvWC6P_IgnyUF6"



# Function to Authenticate with Google Drive API
def authenticate():
    # Authenticate with Google Drive API
    creds = service_account.Credentials.from_service_account_file(SERVICE_ACCOUNT_FILE, scopes=SCOPES)
    return creds



# Function to upload the images to the google drive
def upload_image(image_data, file_name):
    # Authenticate with Google Drive API
    creds = authenticate()
    service = build('drive', 'v3', credentials=creds)

    file_name = f'{file_name.split(".jpg")[0].split("/")[-1]}'

    # Create the file metadata
    file_metadata = {
        'name' : f"{file_name}",
        'parents' : [PARENT_FOLDER_ID]
    }

    # Create a BytesIO object to read the image data
    image_io = io.BytesIO(image_data)


    # Create the media object for the image file
    media = MediaIoBaseUpload(image_io, mimetype='image/jpeg')
    # Upload the file to Google Drive
    img = service.files().create(
        body=file_metadata,
        media_body=media,
        fields='id'
    ).execute()

    return img['id']


    # # Upload the file to Google Drive
    # file = service.files().create(
    #     body=file_metadata,
    #     media_body=file_path
    # ).execute()

    # # Upload the file to Google Drive
    # media = service.files().create(
    #     body=file_metadata,
    #     media_body=image_data,
    #     fields='id',
    # ).execute()




