import torch

def train_model(model, dataloader, optimizer, num_epochs=10, device='cuda'):
    criterion = torch.nn.CrossEntropyLoss()
    model = model.to(device)
    model.train()

    for epoch in range(num_epochs):
        epoch_loss = 0.0
        for inputs, labels in dataloader:
            inputs = inputs.to(device)
            labels = {k: v.to(device) for k, v in labels.items()}

            optimizer.zero_grad()
            outputs = model(inputs)
            loss = sum(criterion(outputs[task], labels[task]) for task in outputs)
            loss.backward()
            optimizer.step()

            epoch_loss += loss.item()

        print(f"Epoch {epoch + 1}/{num_epochs}, Loss: {epoch_loss / len(dataloader)}")
