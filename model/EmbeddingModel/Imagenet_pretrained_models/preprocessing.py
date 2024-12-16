import csv
import os
import time
from PIL import Image
from ultralytics import YOLO
from tqdm import tqdm


def make_file_folder_map(directory = "../../../dataset/Musinsa_dataset"):
    # get folder names in the directory
    folders = os.listdir(directory)

    # save the file name with the number(i) corresponding to the folder name
    style2index = []
    file_folder_map = {}
    for i in range(len(folders)):
        folder = folders[i]
        files = os.listdir(f"{directory}/{folder}")
        
        for file in files:
            file_folder_map[file] = i
        
        style2index.append({folder: i})

    # save the file name and the corresponding folder number to a csv file
    with open("file_folder_map.csv", "w") as f:
        writer = csv.writer(f)
        writer.writerow(["file", "folder"])
        for file, folder in file_folder_map.items():
            writer.writerow([file, folder])

    print("Saved file_folder_map.csv")
    print(style2index)

def crop_image_using_bbox():
    # model_path = '/root/runs/detect/train13/weights/best.pt'
    model_path = '/root/25th-conference-EvenT/model/YOLO/2stage/best.pt'
    model = YOLO(model_path)

    # img_path from the folder
    root_image_folder = '/root/25th-conference-EvenT/dataset/Musinsa_dataset'
    img_folders = os.listdir(root_image_folder)

    new_root_image_folder = '/root/25th-conference-EvenT/dataset/Musinsa_dataset_cropped'

    for img_folder in img_folders:
        # Make a folder for the cropped images if it does not exist
        if not os.path.exists(f"{new_root_image_folder}/{img_folder}"):
            os.mkdir(f"{new_root_image_folder}/{img_folder}")
        
        # Get the original images in the folder
        img_files = os.listdir(f"{root_image_folder}/{img_folder}")

        number_of_images = 0
        too_small_images = 0
        less_than_2_boxes = 0
        print(f"Start cropping images in {img_folder}")
        for img_file in tqdm(img_files):
            img_path = f"{root_image_folder}/{img_folder}/{img_file}"
            result = model(img_path, verbose=False)

            result[0].save(filename = 'result.jpg')
            boxes = result[0].boxes

            # Make sure that there exist more than 2 boxes
            # Because it is normal for human to wear more than 2 clothings
            if len(boxes) < 2:
                # Exceptional case: 1 box with class = 원피스(dress)
                if len(boxes) == 1 and boxes[0].cls.item() == 2:
                    pass

                # print("Less than 2 boxes detected, image will not be saved: ", img_path)
                less_than_2_boxes += 1
                continue

            # Get the minimum and maximum coordinates of the boxes
            # That will be used as bounding box of human in the image
            real_boxes = [50000, 50000, 0, 0]
            for box in boxes:
                x1, y1, x2, y2 = box.xyxy[0].tolist()
                real_boxes[0] = min(real_boxes[0], x1)
                real_boxes[1] = min(real_boxes[1], y1)
                real_boxes[2] = max(real_boxes[2], x2)
                real_boxes[3] = max(real_boxes[3], y2)

            # If final box is too small, skip the image
            if real_boxes[2] - real_boxes[0] < 100 or real_boxes[3] - real_boxes[1] < 100:
                # print("Box too small, image will not be saved: ", img_path)
                too_small_images += 1
                continue

            # Save the image cropped by the box
            img = Image.open(img_path)
            img2 = img.crop((real_boxes[0], real_boxes[1], real_boxes[2], real_boxes[3]))
            img2.save(f"{new_root_image_folder}/{img_folder}/{img_file}")
            number_of_images += 1

        print(f"Finished cropping images in {img_folder}: \n{number_of_images} images cropped")
        print(f"Too small images: {too_small_images}")
        print(f"Less than 2 boxes: {less_than_2_boxes}")

if __name__ == "__main__":
    # crop_image_using_bbox()
    make_file_folder_map("../../../dataset/Musinsa_dataset_cropped")