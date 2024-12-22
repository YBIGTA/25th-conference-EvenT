from torchvision import transforms
from sklearn.model_selection import train_test_split
from dataset import MultiTaskDataset

def load_dataset(image_dir, label_dir):
    image_paths, labels_task1, labels_task2, labels_task3, labels_task4 = [], [], [], [], []

    for image_file in os.listdir(image_dir):
        if image_file.endswith(('.jpg', '.png', '.jpeg')):
            image_path = os.path.join(image_dir, image_file)
            label_path = os.path.join(label_dir, image_file.replace('.jpg', '.json'))

            if os.path.exists(label_path):
                with open(label_path, 'r') as f:
                    labels = json.load(f)

                image_paths.append(image_path)
                labels_task1.append(labels['task1'])
                labels_task2.append(labels['task2'])
                labels_task3.append(labels['task3'])
                labels_task4.append(labels['task4'])

    return image_paths, labels_task1, labels_task2, labels_task3, labels_task4

def preprocess_data(image_dir, label_dir, batch_size=32, test_size=0.2):
    # Load dataset
    image_paths, labels_task1, labels_task2, labels_task3, labels_task4 = load_dataset(image_dir, label_dir)

    # Train-test split
    train_imgs, val_imgs, train_labels_task1, val_labels_task1, train_labels_task2, val_labels_task2, train_labels_task3, val_labels_task3, train_labels_task4, val_labels_task4 = train_test_split(
        image_paths, labels_task1, labels_task2, labels_task3, labels_task4, test_size=test_size, random_state=42)

    # Define transformations
    transform = transforms.Compose([
        transforms.Resize((224, 224)),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
    ])

    # Create datasets
    train_dataset = MultiTaskDataset(train_imgs, train_labels_task1, train_labels_task2, train_labels_task3, train_labels_task4, transform)
    val_dataset = MultiTaskDataset(val_imgs, val_labels_task1, val_labels_task2, val_labels_task3, val_labels_task4, transform)

    return train_dataset, val_dataset
