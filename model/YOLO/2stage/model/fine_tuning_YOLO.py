import os
import io
import cv2
from ultralytics import YOLO


def train_yolo():
    model = YOLO("yolo11m.pt")

    model.train(data="/sample_data/after_processing/split_data/data.yaml", 
                               save_period = 5, epochs = 50, workers = 8, batch = 32,
                               imgsz = 640, device = 0)

    model.save("yolo11m_fine_tuned.pt")

    # results = model("/sample_data/after_processing/split_data/val/images/56.jpg")

    print("Fine-tuning is done!")
    # Plot the detections
    results = model.predict(source="/sample_data/after_processing/split_data/val/images/56.jpg")

    # Plot inference results
    plot = results[0].plot() 

    # Convert the plot to bytes
    im_bytes = cv2.imencode(".jpg", plot)[1].tobytes()

    # Save the resultant file locally
    output_path = "/25th-conference-EvenT/model/YOLO/2stage/model/image_with_detections.jpg"
    os.makedirs(os.path.dirname(output_path), exist_ok=True)  # Create directory if it doesn't exist
    with open(output_path, "wb") as f:
        f.write(im_bytes)
    print(f"Image with detections saved at: {output_path}")

if __name__ == "__main__":
    train_yolo()