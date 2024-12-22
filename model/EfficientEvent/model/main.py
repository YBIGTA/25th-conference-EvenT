import torch
import torch.optim as optim
from model import MultiTaskEfficientNet
from pre_processing import preprocess_data
from dataset import create_dataloader
from train import train_model
from evaluate import evaluate_model

# Paths
image_dir = 'path/to/images'
label_dir = 'path/to/labels'

# Preprocess data
train_dataset, val_dataset = preprocess_data(image_dir, label_dir)
train_loader = create_dataloader(train_dataset, batch_size=32, shuffle=True)
val_loader = create_dataloader(val_dataset, batch_size=32, shuffle=False)

# Model
model = MultiTaskEfficientNet(num_classes_task1=10, num_classes_task2=5, num_classes_task3=8, num_classes_task4=12)

# Optimizer
optimizer = optim.Adam(model.parameters(), lr=1e-4)

# Train
train_model(model, train_loader, optimizer, num_epochs=10, device='cuda')

# Evaluate
evaluate_model(model, val_loader, device='cuda')
