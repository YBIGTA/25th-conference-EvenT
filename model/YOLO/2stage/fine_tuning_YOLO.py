import os
from ultralytics import YOLO


def train_yolo():
    model = YOLO("yolo11m.pt")

    result_model = model.train(data="/dataset/after_processing/split_data/data.yaml", 
                               save_period = 5, epochs = 50, workers = 8, batch = 32,
                               imgsz = 640, device = [0, 1])

    result_model.save("yolo11m_fine_tuned.pt")

    results = model("/dataset/after_processing/split_data/val/images/1263525.jpg")

    print("Fine-tuning is done!")
    print(results.show())

if __name__ == "__main__":
    train_yolo()
