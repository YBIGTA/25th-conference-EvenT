from torch.utils.data import Dataset, DataLoader
from PIL import Image
import os
import json

class MultiTaskDataset(Dataset):
    def __init__(self, image_paths, labels_task1, labels_task2, labels_task3, labels_task4, transform=None):
        self.image_paths = image_paths
        self.labels_task1 = labels_task1
        self.labels_task2 = labels_task2
        self.labels_task3 = labels_task3
        self.labels_task4 = labels_task4
        self.transform = transform

    def __len__(self):
        return len(self.image_paths)

    def __getitem__(self, idx):
        image = Image.open(self.image_paths[idx]).convert('RGB')
        if self.transform:
            image = self.transform(image)

        return image, {
            'task1': self.labels_task1[idx],
            'task2': self.labels_task2[idx],
            'task3': self.labels_task3[idx],
            'task4': self.labels_task4[idx]
        }

def create_dataloader(dataset, batch_size, shuffle):
    return DataLoader(dataset, batch_size=batch_size, shuffle=shuffle)
