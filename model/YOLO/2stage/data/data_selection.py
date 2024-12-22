import os
import random

"""
In this file, we will implement the random selection of data for training and testing.
We need this step because dataset is too large and we can't use all of them.
We already split the dataset into 2 parts: train and test.
Therefore, we will randomly select a subset of data from each part.

Current tree structure:
dataset 
    - after_processing 
        - images (nothing here)
        - labels (nothing here)
        - split_data
            - data.yaml
            - train
                - images
                - labels
            - val
                - images
                - labels
    - original
        - images
        - labels

After this step, we will have:
dataset
    - after_processing
        - images (nothing here)
        - labels (nothing here)
        - split_data
            - real
                - train
                    - images
                    - labels
                - val
                    - images
                    - labels
            - data.yaml
            - train
                - images
                - labels
            - val
                - images
                - labels
    - original
        - images (nothing here)
        - labels (nothing here)

This code will move 10% of data from train to real/train and 10% of data from val to real/val.
Also will move the corresponding labels to real folder.
"""

def data_random_selection():
    path = '/dataset/sample_data/final/split_data/'
    real_path = path + 'real/'

    # Create real folder
    if not os.path.exists(real_path):
        os.makedirs(real_path)
        os.makedirs(real_path + 'train')
        train_path = os.path.join(real_path, 'train/') # Dynamically set train_path
        os.makedirs(real_path + 'val')

    # Move 30% of data from train to real/train
    train_images = os.listdir(train_path + 'images/')
    val_images = os.listdir(val_path + 'images/')

    # random select 30% of data
    train_images = random.sample(train_images, int(len(train_images) * 0.1))
    train_labels = [image.replace('jpg', 'txt') for image in train_images]
    val_images = random.sample(val_images, int(len(val_images) * 0.1))
    val_labels = [image.replace('jpg', 'txt') for image in val_images]

    # Move train images
    for image in train_images:
        os.rename(train_path + 'images/' + image, real_path + 'train/images/' + image)

    # Move val images
    for image in val_images:
        os.rename(val_path + 'images/' + image, real_path + 'val/images/' + image)

    # Move train labels
    for label in train_labels:
        os.rename(train_path + 'labels/' + label, real_path + 'train/labels/' + label)

    # Move val labels
    for label in val_labels:
        os.rename(val_path + 'labels/' + label, real_path + 'val/labels/' + label)

    print('Data selection is done!')

def create_yaml():
    dir = '/dataset/sample_data/final/split_data/'
    # YAML 파일 생성
    yaml_path = os.path.join(dir, "data.yaml")

    # 클래스 정의
    class_names = ['아우터', '하의', '원피스', '상의']  # 클래스 이름 리스트

    # 정확한 경로 작성
    train_path = os.path.join(dir, "train/images").replace("\\", "/")
    val_path = os.path.join(dir, "val/images").replace("\\", "/")

    # YAML 내용 작성
    yaml_content = f"""path: {dir}  # dataset path \ntrain: {train_path}  # training image path \nval: {val_path}  # validation image path \n\n# number of classes \nnc: {len(class_names)} \n\n# name of classes \nnames: \n"""

    # 클래스 이름 추가
    for i, class_name in enumerate(class_names):
        yaml_content += f"  {i}: {class_name}\n"

    # YAML 파일 생성
    with open(yaml_path, 'w', encoding='utf-8') as f:
        f.write(yaml_content)

    print(f"'data.yaml' generated for YOLO v11: {yaml_path}")

if __name__ == '__main__':
    data_random_selection()
    create_yaml()