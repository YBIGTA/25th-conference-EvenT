# Models
## Task1: Clothing Detection
We trained both [Co-DETR](https://arxiv.org/abs/2211.12860) model and [YOLO](https://docs.ultralytics.com/models/) model. We compared the performance of models, and decided to use ____.

### Dataset
We used [K-fashion dataset](https://www.aihub.or.kr/aihubdata/data/view.do?currMenu=115&topMenu=100&aihubDataSe=data&dataSetSn=51) to fine-tune our model. The original dataset includes segmentation information, overall style, bounding boxes for each piece of clothing, and detailed attributes of the clothing.

### Categories of dataset
This dataset is categorized into four major classes: '상의'(tops), '하의'(bottoms), '원피스'(dresses), and '아우터'(outerwear). Each class is annotated with attributes such as has sub-category, color, detail, print, textile, size, clothing length, and sleeve length. Additionally, certain classes include neckline, and collar information. 

### Preprocessing
Since the dataset contained a large amount of information, we decided to simplify it. We only retained sub-category, color, print, and sleeve length attributes, while also reducing the number of categories for clothing length. All other attributes were removed.
Our objective was to use only the bounding boxes and detailed clothing attributes for training YOLO. To achieve this, we performed preprocessing converting the dataset into the format suitable for YOLO training.


## Task2: Outfit Of The Day(OOTD) image embedding
The specific information is in [README file](EmbeddingModel/README.md)