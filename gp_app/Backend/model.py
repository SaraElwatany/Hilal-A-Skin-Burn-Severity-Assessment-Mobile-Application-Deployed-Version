import torch.nn as nn
from torchvision import models




# Resnet50 Model's Architecture used for prediction
class MyModel(nn.Module):
    def __init__(self, num_classes):
        super(MyModel, self).__init__()
        # Choose your model.
        pretrained_resnet = models.resnet50(pretrained=True)
        n_inputs = pretrained_resnet.fc.in_features

        # Freeze the weights of the ResNet50 model
        for param in pretrained_resnet.parameters():
            param.requires_grad = False

        # Remove the avgpool and fc layers
        pretrained_resnet = nn.Sequential(*list(pretrained_resnet.children())[:-2])

        # Add a new layer to the ResNet50 model for the multi-label classification task
        pretrained_resnet.fc = nn.Sequential(nn.Flatten(),
                                             nn.Linear(n_inputs*7*7, num_classes),
                                            )


        # Unfreeze the last fc layer of the model
        for param in pretrained_resnet.fc.parameters():
            param.requires_grad = True

        # Set the model to your class attribute
        self.resnet50 = pretrained_resnet

    def forward(self, x):
        return self.resnet50(x) 







""" class MyModel(nn.Module):
    def __init__(self, num_classes):
        super(MyModel, self).__init__()
        # Choose your model.
        resnet50 = models.resnet50(pretrained=True)
        # Freeze the weights of the ResNet50 model.
        for param in resnet50.parameters():
            param.requires_grad = False
        # Add a new layer to the ResNet50 model for the multi-label classification task.
        resnet50.classifier = nn.Sequential(nn.Conv2d(2048, 128, kernel_size=3, padding=1, stride=1),
                                    nn.Softmax(dim=1),
                                    nn.MaxPool2d(4, 4),

                                    nn.Conv2d(128, 64, kernel_size=3, padding=1, stride=2),
                                    nn.Softmax(dim=1),
                                    nn.MaxPool2d(2, 2),

                                    nn.Dropout(p=0.2),
                                    nn.Flatten(),

                                    nn.Linear(in_features= resnet50.fc.in_features, out_features= 3)
                                    )
        for param in resnet50.fc.parameters():
            param.requires_grad = True
        # Unfreeze the last few layers of the model.
        for param in resnet50.layer4.parameters():
            param.requires_grad = True
        # Set the model to your class attribute
        self.resnet50 = resnet50

    def forward(self, x):
        return self.resnet50(x) """