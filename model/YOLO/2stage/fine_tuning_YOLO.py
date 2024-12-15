import os
from ultralytics import YOLO


def train_yolo():
    model = YOLO("yolo11m.pt")

    result_model = model.train(data="/dataset/after_processing/split_data/data.yaml", imgsz = 640, epochs = 100, device = [0, 1], workers = 12)

    result_model.save("yolo11m_fine_tuned.pt")

    results = model("/dataset/after_processing/split_data/val/images/1263525.jpg")

    print("Fine-tuning is done!")
    print(results.show())

if __name__ == "__main__":
    train_yolo()
