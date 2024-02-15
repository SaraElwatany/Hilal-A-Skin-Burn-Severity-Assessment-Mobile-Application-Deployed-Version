import torch.nn as nn
from torchvision import models




# Resnet50 Model's Architecture used for prediction
class MyModel(nn.Module):
    def __init__(self, num_classes):
        super(MyModel, self).__init__()
        # Choose your model.
        resnet50 = models.resnet50(pretrained=True)

        # Unfreeze the last 5 layers' weights of the original model
        for name, param in self.base_model.named_parameters():
          if 'layer' in name:
            param.requires_grad = True

        # Set the model to your class attribute
        self.resnet50 = resnet50

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