import os
from ultralytics import YOLO


def train_yolo():
    model = YOLO("yolo11n.pt")

    result_model = model.train(data="data.yaml", imgsz = 640, epochs = 100, device = [0, 1])

    result_model.save("yolo11n_fine_tuned.pt")

    results = model("")

    print("Fine-tuning is done!")
    print(results.show())

if __name__ == "__main__":
    train_yolo()
