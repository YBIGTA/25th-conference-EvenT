"""
일단 sample data로 먼저 학습시켜보려고 
드라이브에 있는 Sample_dataset의 데이터를 
yolo v11 데이터셋 포맷에 맞추려고 함. 
yolo v11 데이터 포맷이 
split_data/
├── train/
│   ├── images/
│   │   ├── 11.jpg
│   │   └── ...
│   └── labels/
│       ├── 11.txt
│       └── ...
└── val/
    ├── images/
    │   ├── 17.jpg
    │   └── ...
    └── labels/
        ├── 17.txt
        └── ...

이런 형식이고 여기에 이 정보 담긴 yaml 파일이 최종적으로 필요함
yaml 파일에는 

path: ../datasets/coco8 # dataset root dir
train: images/train # train images (relative to 'path') 4 images
val: images/val # val images (relative to 'path') 4 images
test: # test images (optional)

# Classes
names:
  0: person
  1: bicycle
  2: car

이런 형식이 필요

이 코드 돌리면 yaml 까지 생김
"""

import os
import json
import shutil
from sklearn.model_selection import train_test_split

# 경로 설정
labelling_dir = '/dataset/original/labels'
origin_dir = '/dataset/original/images'
output_dir = '/dataset/after_processing'

# 출력 디렉토리 생성
os.makedirs(f"{output_dir}/images", exist_ok=True)
os.makedirs(f"{output_dir}/labels", exist_ok=True)

# 클래스 이름과 ID 매핑
class_name_to_id = {
    '아우터': 0,
    '하의': 1,
    '원피스': 2,
    '상의': 3
}

# JSON 파일 처리 및 YOLO 형식으로 저장
for category in os.listdir(labelling_dir):
    json_dir = os.path.join(labelling_dir, category)
    image_dir = os.path.join(origin_dir, category)
    if not os.path.isdir(json_dir):
        continue

    # JSON 파일 순회
    for dirpath, _, filenames in os.walk(json_dir):  # 서브 디렉토리 포함 순회
        for json_file in filenames:
            if not json_file.endswith('.json'):
                continue

            json_path = os.path.join(dirpath, json_file)
            with open(json_path, 'r', encoding='utf-8') as f:
                data = json.load(f)

            # 이미지 파일명과 라벨 파일명 설정
            image_filename = json_file.replace('.json', '.jpg')
            label_filename = json_file.replace('.json', '.txt')

            # 이미지 파일 복사
            src_image_path = os.path.normpath(os.path.join(image_dir, image_filename))  # 경로 통일
            dst_image_path = os.path.normpath(os.path.join(output_dir, 'images', image_filename))  # 경로 통일

            # 디버깅: 경로와 파일 존재 여부 확인
            print(f"Source path: {src_image_path}")
            print(f"Destination path: {dst_image_path}")
            print(f"Source file exists: {os.path.exists(src_image_path)}")

            if os.path.exists(src_image_path):
                shutil.move(src_image_path, dst_image_path)

            # 라벨 파일 생성
            label_path = os.path.join(output_dir, 'labels', label_filename)
            with open(label_path, 'w') as f:
                # 데이터셋 상세설명에서 렉트좌표 추출
                if '데이터셋 정보' in data and '데이터셋 상세설명' in data['데이터셋 정보']:
                    rect_coords = data['데이터셋 정보']['데이터셋 상세설명']['렉트좌표']
                    for category, items in rect_coords.items():
                        if category in class_name_to_id:
                            class_id = class_name_to_id[category]
                            for item in items:
                                if 'X좌표' in item and 'Y좌표' in item and '가로' in item and '세로' in item:
                                    # 바운딩 박스 좌표 계산
                                    x_center = (item['X좌표'] + item['가로'] / 2) / data['이미지 정보']['이미지 너비']
                                    y_center = (item['Y좌표'] + item['세로'] / 2) / data['이미지 정보']['이미지 높이']
                                    width = item['가로'] / data['이미지 정보']['이미지 너비']
                                    height = item['세로'] / data['이미지 정보']['이미지 높이']

                                    # YOLO 라벨 포맷으로 저장
                                    f.write(f"{class_id} {x_center:.6f} {y_center:.6f} {width:.6f} {height:.6f}\n")

# 데이터 분할 (train-val split)
base_dir = output_dir
image_dir = os.path.join(base_dir, "images")
label_dir = os.path.join(base_dir, "labels")
split_dir = os.path.join(base_dir, "split_data")

# 출력 디렉토리 생성
for split in ['train', 'val']:
    os.makedirs(os.path.join(split_dir, split, 'images'), exist_ok=True)
    os.makedirs(os.path.join(split_dir, split, 'labels'), exist_ok=True)

# 이미지와 라벨 파일 매칭
image_files = sorted(os.listdir(image_dir))
label_files = sorted(os.listdir(label_dir))

# 파일 이름에서 확장자 제거 후 딕셔너리 생성
image_dict = {os.path.splitext(img)[0]: img for img in image_files}
label_dict = {os.path.splitext(lbl)[0]: lbl for lbl in label_files}

# 공통 파일 이름 찾기
common_keys = set(image_dict.keys()).intersection(set(label_dict.keys()))

# 매칭된 파일 리스트 생성
matched_images = [image_dict[key] for key in common_keys]
matched_labels = [label_dict[key] for key in common_keys]

# 매칭된 파일 개수 확인
print(f"Matched {len(matched_images)} images and labels.")

# train-val split (80:20)
train_images, val_images, train_labels, val_labels = train_test_split(
    matched_images, matched_labels, test_size=0.2, random_state=42
)

# 파일 이동 함수
def move_files(file_list, src_folder, dst_folder):
    for file in file_list:
        src_path = os.path.join(src_folder, file)
        dst_path = os.path.join(dst_folder, file)
        shutil.move(src_path, dst_path)

# train 데이터 이동
move_files(train_images, image_dir, os.path.join(split_dir, 'train', 'images'))
move_files(train_labels, label_dir, os.path.join(split_dir, 'train', 'labels'))

# val 데이터 이동
move_files(val_images, image_dir, os.path.join(split_dir, 'val', 'images'))
move_files(val_labels, label_dir, os.path.join(split_dir, 'val', 'labels'))

print("데이터 분할이 완료되었습니다!")

# YAML 파일 생성
yaml_path = os.path.join(split_dir, "data.yaml")

# 클래스 정의
class_names = ['아우터', '하의', '원피스', '상의']  # 클래스 이름 리스트

# 정확한 경로 작성
train_path = os.path.join(split_dir, "train/images").replace("\\", "/")
val_path = os.path.join(split_dir, "val/images").replace("\\", "/")

# YAML 내용 작성
yaml_content = f"""
path: {split_dir}  # 데이터셋 루트 경로
train: {train_path}  # 훈련 이미지 경로
val: {val_path}  # 검증 이미지 경로

# 클래스 수
nc: {len(class_names)}

# 클래스 이름
names:
"""

# 클래스 이름 추가
for i, class_name in enumerate(class_names):
    yaml_content += f"  {i}: {class_name}\n"

# YAML 파일 생성
with open(yaml_path, 'w', encoding='utf-8') as f:
    f.write(yaml_content)

print(f"YOLO v11 데이터셋 포맷에 맞는 'data.yaml' 파일이 생성되었습니다: {yaml_path}")