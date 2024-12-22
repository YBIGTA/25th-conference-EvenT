import torch

def evaluate_model(model, dataloader, device='cuda'):
    model = model.to(device)
    model.eval()

    correct = {task: 0 for task in ['task1', 'task2', 'task3', 'task4']}
    total = len(dataloader.dataset)

    with torch.no_grad():
        for inputs, labels in dataloader:
            inputs = inputs.to(device)
            labels = {k: v.to(device) for k, v in labels.items()}
            outputs = model(inputs)

            for task in outputs:
                _, preds = torch.max(outputs[task], 1)
                correct[task] += (preds == labels[task]).sum().item()

    for task, count in correct.items():
        print(f"Accuracy for {task}: {count / total:.2%}")
