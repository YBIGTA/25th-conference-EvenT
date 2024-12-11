from model import EmbeddingModel
from dataset import CustomImageDataset

from tqdm import tqdm
from torchvision import transforms

import torch
import torch.nn as nn
import torch.optim as optim
import torch.nn.functional as F

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

def split_trainval(num_train=800, num_val=200):
    trainval_annos = pd.read_csv('/root/25th-conference-EvenT/model/EmbeddingModel/file_folder_map.csv')

    categories = sorted(trainval_annos['folder'].unique())
    train_annos, val_annos = [], []
    for c in categories:
        idxs = np.arange(num_train + num_val)
        np.random.shuffle(idxs)
        tgt_df = trainval_annos.groupby('folder').get_group(c).reset_index(drop=True)
        train_annos.append(tgt_df.loc[idxs[:num_train]])
        val_annos.append(tgt_df.loc[idxs[num_train:]])

    train_annos = pd.concat(train_annos).reset_index(drop=True)
    val_annos = pd.concat(val_annos).reset_index(drop=True)

    return train_annos, val_annos

def combined_loss(embeddings, labels, outputs, margin=1.0):
    # Contrastive Loss
    distances = torch.cdist(embeddings, embeddings)  # Pairwise distances
    y = (labels.unsqueeze(1) == labels.unsqueeze(0)).float()  # Binary labels
    contrastive_loss = (1 - y) * distances**2 + y * (torch.clamp(margin - distances, min=0.0)**2)
    contrastive_loss = contrastive_loss.mean()

    # Cross-Entropy Loss
    ce_loss = F.cross_entropy(outputs, labels)

    return contrastive_loss + ce_loss


if __name__ == "__main__":
    device = 'cuda' if torch.cuda.is_available() else 'cpu'
    num_epochs = 500
    learning_rate = 1e-3
    num_workers = 4
    batch_size = 32

    # Transform the images
    transform = transforms.Compose([
        transforms.Resize((224, 224)),
        transforms.ToTensor(),
    ])

    # Split the dataset into train and validation sets
    train_annos, val_annos = split_trainval()

    train_dataset = CustomImageDataset(train_annos, transform=transform, train = True)
    val_dataset = CustomImageDataset(val_annos, transform=transform, train = False)

    print("Train dataset size: ", len(train_dataset))
    print("Validation dataset size: ", len(val_dataset))

    # Create the DataLoader
    train_loader = torch.utils.data.DataLoader(train_dataset, batch_size=batch_size, 
                                               shuffle=True, num_workers=num_workers, pin_memory=False)
    val_loader = torch.utils.data.DataLoader(val_dataset, batch_size=batch_size,
                                             num_workers=num_workers, pin_memory=False)

    # Build the model
    model = EmbeddingModel()
    net = model.to(device)

    # Define the loss function and optimizer
    optimizer = optim.Adam(filter(lambda p: p.requires_grad, net.parameters()), lr=1e-3, weight_decay=1e-4)
    scheduler = optim.lr_scheduler.StepLR(optimizer, step_size=10, gamma=0.1)

    # Train the model
    train_losses, val_losses = [], []
    for epoch in range(num_epochs):
        net.train()
        running_loss = 0.0
        
        for images, labels in tqdm(train_loader):  # train_loader is your DataLoader
            images, labels = images.to(device), labels.to(device)
            
            optimizer.zero_grad()
            embeddings, outputs = net(images)  # Forward pass
            loss = combined_loss(embeddings, labels, outputs)  # Compute loss
            loss.backward()  # Backpropagation
            optimizer.step()  # Update weights
            
            running_loss += loss.item()
        
        scheduler.step()  # Update learning rate
        train_losses.append(running_loss/len(train_loader))
        print(f"Epoch [{epoch+1}/{num_epochs}], Loss: {running_loss/len(train_loader):.4f}")

        net.eval()
        val_loss = 0.0
        correct = 0
        total = 0
        with torch.no_grad():
            for images, labels in val_loader:
                images, labels = images.to(device), labels.to(device)
                embeddings, outputs = net(images)

                loss = combined_loss(embeddings, labels, outputs)
                val_loss += loss.item()

                _, predicted = torch.max(outputs, 1)
                correct += (predicted == labels).sum().item()
                total += labels.size(0)
        
        val_losses.append(val_loss/len(val_loader))
        print(f"Validation Loss: {val_loss/len(val_loader):.4f}, Accuracy: {correct/total:.4f}")
    
    # Make the plot
    plt.plot(range(num_epochs), train_losses, label='Training Loss')
    plt.plot(range(num_epochs), val_losses, label='Validation Loss')
    # Save the model
    torch.save(net.state_dict(), "/root/25th-conference-EvenT/model/EmbeddingModel/pytorch-embedding-resnext101_32x8d.pth")
