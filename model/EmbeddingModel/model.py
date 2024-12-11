import torch
import torch.nn as nn
import torch.optim as optim

from torchvision import models
from collections import OrderedDict

class EmbeddingModel(nn.Module):
    def __init__(self):
        super(EmbeddingModel, self).__init__()
        embedding_dim = 128
        self.resnet = models.resnext101_32x8d(pretrained=True)
        # Remove the last layer
        self.backbone = nn.Sequential(OrderedDict([*(list(self.resnet.named_children())[:-2])]))

        # # Freezing backbone
        # for param in self.backbone.parameters():
        #     param.requires_grad = False

        self.avgpool = nn.AdaptiveAvgPool2d((1, 1))

        # Add a fully connected layer
        self.embeddingLayer = nn.Linear(self.resnet.fc.in_features, embedding_dim)
        self.classifier = nn.Linear(embedding_dim, 13)

    def forward(self, x):
        x = self.backbone(x)
        x = self.avgpool(x)
        x = torch.flatten(x, 1)
        embedding = self.embeddingLayer(x)
        out = self.classifier(embedding)
        return embedding, out
