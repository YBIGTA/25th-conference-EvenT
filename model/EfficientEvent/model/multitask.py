import torch
import torch.nn as nn
from efficientnet_pytorch import EfficientNet

class MultiTaskEfficientNet(nn.Module):
    def __init__(self, num_classes_task1, num_classes_task2, num_classes_task3, num_classes_task4):
        super(MultiTaskEfficientNet, self).__init__()
        # Load EfficientNet backbone
        self.backbone = EfficientNet.from_pretrained('efficientnet-b0')
        
        # Remove the original FC layer
        self.shared_features = nn.Sequential(*list(self.backbone.children())[:-1])
        
        # Add task-specific heads
        self.pooling = nn.AdaptiveAvgPool2d(1)
        self.head1 = nn.Linear(1280, num_classes_task1)
        self.head2 = nn.Linear(1280, num_classes_task2)
        self.head3 = nn.Linear(1280, num_classes_task3)
        self.head4 = nn.Linear(1280, num_classes_task4)

    def forward(self, x):
        features = self.shared_features(x)
        features = self.pooling(features).squeeze(-1).squeeze(-1)
        return {
            'task1': self.head1(features),
            'task2': self.head2(features),
            'task3': self.head3(features),
            'task4': self.head4(features),
        }
