from torch.utils.data import Dataset, DataLoader
from PIL import Image
from tqdm import tqdm

import os.path as osp
import cv2
import numpy as np
import os

class CustomImageDataset(Dataset):
    def __init__(self, annos, transform=None, train=True):
        """        
        annos: DataFrame([filename, folder_name_as_label])
        """
        self.annos = annos
        self.transform = transform
        self.train = train
        self.label_to_folder = {
            0: 'Classic', 1: 'Chic', 2: 'Cityboy', 
            3: 'Casual', 4: 'Minimal', 5: 'Preppy', 
            6: 'Workwear', 7: 'Retro', 8: 'Street',
            9: 'Gorpcore', 10: 'Sporty', 11: 'Romantic', 12: 'Girlish'
        }


    def __len__(self):
        return len(self.annos)

    def __getitem__(self, idx):
        target_row = self.annos.loc[idx]
        # Make image path
        filename = target_row['file']
        folder = self.label_to_folder[target_row['folder']]
        img_path = f'/root/25th-conference-EvenT/dataset/Musinsa_dataset/{folder}/{filename}'
        if not osp.exists(img_path):
            raise FileNotFoundError(f"Image file not found: {img_path}")
        
        img = cv2.imread(img_path)
        if img is None:
            raise ValueError(f"Image file is corrupted or could not be read: {img_path}")

        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        img = Image.fromarray(img)

        if self.transform:
            image = self.transform(img)
        
        return image, target_row['folder']