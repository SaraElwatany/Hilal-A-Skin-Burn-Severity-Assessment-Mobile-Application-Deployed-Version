# Hilal - Skin Burn Severity Assessment Mobile Application
![Picture5-imageonline co-merged](https://github.com/user-attachments/assets/d60feb15-53be-4300-a251-beb7da69149f)

## About

This project presents a comprehensive AI-powered clinical decision support system for skin burn severity assessment, integrated into a user-friendly mobile application. Developed by a multidisciplinary team from Cairo University’s Faculty of Engineering and Faculty of Medicine, the system assists burn specialists in diagnosing burn severity, enabling timely and accurate treatment, especially in remote areas.

**About Hilal**

Hilal is a mobile application designed to assist in the assessment of burn injuries by classifying the degree of burns from images. The app integrates doctor validation and feedback to ensure high diagnostic accuracy and better patient care.

**Tech Stack**

- Frontend: Flutter

- Backend: Flask

- Machine Learning: PyTorch

- Database: SQLAlchemy (storing images as blobs)


**System Architecture**

Hilal follows a cascading classifier approach, leveraging ResNet-50 and MobileNet models for image-based burn classification. Doctor feedback is integrated into the system to continuously improve model performance.


**Key Features:**

- Deep Learning Models: Implemented and compared ResNet50, DenseNet, MobileNet, VGG16, and ShuffleNet for burn degree classification.

- Enhanced Datasets: Curated and enriched a diverse dataset from publicly available sources and local Egyptian hospitals, with expert-annotated images.

- Mobile Application: Designed a telemedicine platform to facilitate remote diagnosis and specialist-patient communication.

- High Performance: Achieved the best classification results using a modified MobileNet model, with an accuracy of (92.34% accuracy) for One Vs. Others model and (89.55% accuracy)
for Two Vs. Three model.



## Motivation
This project aims to bridge the gap between patients and specialists by providing fast and reliable burn diagnosis support, reducing the risk of delayed treatment and improving patient outcomes through a mobile-friendly burn assessment telemedicine application.

https://github.com/user-attachments/assets/08232ad9-344e-4d1f-83ec-3b3a283c9438

## Methodology
![Untitled](https://github.com/user-attachments/assets/93662248-fbcb-4150-9c53-7ab098af1711)

**Data Collection and Preprocessing**

- Datasets: We combined multiple datasets (listed below in the readme) to build a robust training set, ensuring diverse representation of burn types.

- Image Processing: Burn region of interest (ROI) extraction was performed to focus on the affected areas, reducing noise and improving model performance.

- Color Space Transformation: Images were converted from RGB to CIELAB color space, which helped improve classification accuracy by enhancing color differentiation.

- Data Cleaning: Removed artifacts and poor-quality images that could negatively impact training.

- Standardization: Resized images and normalized pixel values to ensure consistent input format for all models.


**Model Development**

- ResNet-50 Benchmark Model:

Pretrained ResNet-50 model with added dense layers.

Additional layers: fully connected layer, dropout layer (0.3), final output layer.

Achieved 41.1% accuracy on initial trials, improved to 50% with hyperparameter tuning on initial datasets.


- DenseNet Model:

Pretrained DenseNet with added dense layers.

Achieved 50.00% accuracy on initial datasets.


- MobileNet Model:

Pretrained MobileNet with an extra flatten layer and two fully connected layers.

Dropout layer (0.7) and ReLU activation.

Achieved 49.15% accuracy on initial datasets.


- VGG16 Model:

Pretrained VGG16 with added dense layers.

Achieved 47.46% accuracy on initial datasets.


- ShuffleNet Model:

Pretrained ShuffleNet with added dense layers.

Achieved 46.61% accuracy on initial datasets.


**Advanced Strategies**

Due to the low accuracies, we adapted to advanced startegies to enhance the burn classes classification.

- I = Class 1 / First Degree Burn
- II = Class 2 / Second Degree Burn
- III = Class 3 / Third Degree Burn

- One-vs-All (OvA) Strategy:

ResNet-50 model fine-tuned for binary classification of each burn degree against the others.

I vs Others: 87.74% accuracy

II vs Others: 68.64% accuracy

III vs Others: 70.34% accuracy


- Cascading Classifier:

Integrated two models for hierarchical classification, and continued with mobilenet pretrained model for better optimization:

First-degree vs. Others (MobileNet): 92.34% accuracy

Second-degree vs. Third-degree (MobileNet): 89.55% accuracy


**Training and Evaluation**

- Loss Functions:

Multi-class classification: Cross-Entropy Loss

Binary classification (OvA): Binary Cross-Entropy Loss


- Optimization:

Adam optimizer with adaptive learning rates.

ReduceLROnPlateau scheduler to reduce learning rate by a factor of 0.1 if no improvement for 6 epochs.


- Evaluation Metrics:

Accuracy, F1-score, Precision, Recall

Confusion matrices for visual performance comparison


- Best Results:

CIELAB color space with Mobilenet using cascading classifier.



## Snapshots

![Picture1 - Copy](https://github.com/user-attachments/assets/a50c22e6-81d8-4876-a745-3aace41eebca)
![signup](https://github.com/user-attachments/assets/855e7618-4e87-4b1a-bf95-08c9021d0539)

![Picture3](https://github.com/user-attachments/assets/38d75796-77ac-4077-84b1-dee8d2910788)
![Picture4](https://github.com/user-attachments/assets/6d359178-d33f-4108-82a9-26ded6cc0026)
![WhatsApp Image 2024-07-16 at 11 41 07](https://github.com/user-attachments/assets/669b2c18-e707-4550-a869-8ba5d7733073)


## Demo
- **Sign Up**
  
https://github.com/user-attachments/assets/1a8638e8-a756-4b8d-8852-4f440090e56b

- **Admin Profile**
  
https://github.com/user-attachments/assets/9599924b-d82b-488b-bf6f-d462dab4603b

- **First Degree Burn & Voice Note Feature**

https://github.com/user-attachments/assets/decbbc72-da6d-4b1a-a950-1fab2768c982

- **Second Degree Burn & Hospitals Suggestion**

https://github.com/user-attachments/assets/d97e49df-adc9-4e57-9deb-7ee24e506c62


## References

- **DataSets**
  
[1] YOLO, “Skin burn dataset.” https://www.kaggle.com/datasets/shubhambaid/skin-burn-dataset, 2023. Accessed: Jan. 11, 2023.

[2] Roboflow, “PB Images Dataset.” https://universe.roboflow.com/pelukbakar/pb-tkjgx, 2022. Accessed: Dec. 22, 2022.

[3] B. Rangel-Olvera, “Human skin burns.” Kaggle Dataset, May 2023. Accessed: Nov. 25, 2023.

[4] Biomedical Image Processing (BIP) Group and Virgen del Roc´ıo Hospital, “Burns bip us database.” Accessed: Dec. 30, 2023, http://personal.us.es/
rboloix/Burns BIP US database.zip, Dec. 2023.

- **Papers & Articles**
  
[1] S. A. Suha and T. F. Sanam, “A deep convolutional neural network-based approach for detecting burn severity from skin burn images,” Machine Learning
and Applications, vol. 9, p. 100371, Sept. 2022.

[2] D. P. Yadav, T. Aljrees, D. Kumar, A. Kumar, K. U. Singh, and T. Singh, “Spatial attention-based residual network for human burn identification and
classification,” Scientific Reports, vol. 13, p. 12516, Aug. 2023.

[3] D. P. Yadav, “A method for human burn diagnosis using machine learning and slic superpixels based segmentation,” IOP Conf. Ser. Mater. Sci. Eng.,
vol. 1116, p. 012186, Apr. 2021.

- **Tools**
  
[1] Labelbox, “Labelbox.” https://labelbox.com, Jan. 2023. Accessed: Nov. 27, 2023.

[2] J. Ma, Y. He, F. Li, L. Han, C. You, and B. Wang, “Segment anything in medical images,” Nat. Commun., vol. 15, p. 654, Jan. 2024.

## Publication


## How To Use
1- Clone the repository.

2- Install the required Packages present in the "gp_app/requirements.txt" file.

3- Update the URLs present in the "gp_app/lib/apis/apis.dart" file to your desired URLs.

**Note:** 

1- This is a deployable version of the application, so some functionalities (camera, ..etc) may not be available if you run it locally on your computer. 

2- If you wish to run the application on your computer and not on a mobile phone you will have to update the environment variables necessary for the databse connection, can be found in "my_tokens.py", or you can type them manually in a separate file.



