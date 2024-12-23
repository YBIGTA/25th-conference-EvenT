# YOLO

## Preprocessing
- We only used bounding boxes and detailed clothing attributes for training YOLO
    - We needed bounding boxes for each clothings, and detailed attributes for detected clothings. Therefore, we only used bounding boxes and detailed attributes in labels. 
    - To achieve this, we performed preprocessing converting the dataset into the format suitable for YOLO training.
- We only used several detailed clothing attributes
    - Since the dataset contained a large amount of information, we decided to simplify it.
    - We retained '세부 카테고리'(sub-category), '컬러'(color), '디테일'(detail), '프린트'(print), and '소매기장'(sleeve length) attributes, while also reducing the number of categories for clothing length. All other attributes were removed.

## Methods

### Two-stage
Our label of dataset has hierarchical structure. If category is different, then some labels are different. For example, 세부 카테고리(sub-category) of 원피스(dress) only has 2 value: 원피스, 점프수트, but 하의(pants) has 5 values. Therefore, we tried 2-stage structure. 
First stage is detecting primary classes. After that, for each bounding boxes, we detect other details.