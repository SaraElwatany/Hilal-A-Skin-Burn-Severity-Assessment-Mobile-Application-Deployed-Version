import base64
import functions as func
from flask import Flask, request, jsonify


app = Flask(__name__)


@app.route('/upload', methods=['POST'])
def upload_image():
    # Get the uploaded file from the request
    data = request.get_json(force=True)

    IMAGE_DATA = data['Image']
    FILE_NAME = data['File Name']

    #uploaded_file = request.files['image']
    
    # save image
    saved_img_file_path = 'D:/trials/something.jpg'
    IMAGE_DATA = base64.b64decode(IMAGE_DATA)
    with open(saved_img_file_path, 'wb') as f:
        f.write(IMAGE_DATA)
        print("Image Saved on PC Successfuly")


    #print('image_data', type(image_data), image_data)
    #print('img_data', type(IMAGE_DATA), IMAGE_DATA)
    #print('raw_data', type(FILE_NAME), FILE_NAME)

    try:
        MEDIA_ID = func.upload_image(IMAGE_DATA, FILE_NAME)
        print("Image Uploaded Successfuly")
        response = {'response': f'Image uploaded to Google Drive with ID: {MEDIA_ID}'}
        return jsonify(response)
    except:
        print('Exception Encountered')
        response = {'response': 'Upload Failed'}
        return jsonify(response)
        


if __name__ == '__main__':
    app.run(debug=True, port=9999)