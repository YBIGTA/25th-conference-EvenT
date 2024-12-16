import os
from ultralytics import YOLO
from PIL import Image

model = YOLO('/root/runs/detect/train13/weights/best.pt')
# 1223455.jpg  242896.jpg   504821.jpg  775186.jpg  999993.jpg
# 1223456.jpg  242898.jpg   504823.jpg  775187.jpg  999997.jpg
img_path = '/dataset/after_processing/split_data/train/images/1223455.jpg'
results = model([img_path])

for result in results:
    boxes = result.boxes
    result.save(filename = 'result.jpg')

