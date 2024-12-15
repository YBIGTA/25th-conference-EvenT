# Models

# Task1: Clothing Detection

## Abstract
We trained both [Co-DETR](https://arxiv.org/abs/2211.12860) model and [YOLO](https://docs.ultralytics.com/models/) model. We compared the performance of models, and decided to use ____.

## Detailed Information on Models
- [Co-DETR](DETR/README.md)
- [YOLO](YOLO/README.md)

## Dataset
We used [K-fashion dataset](https://www.aihub.or.kr/aihubdata/data/view.do?currMenu=115&topMenu=100&aihubDataSe=data&dataSetSn=51) to fine-tune our model. This dataset provides segmentation information, overall style, bounding boxes for individual clothing items, and detailed clothing attributes. 

### Categories of dataset
This dataset is categorized into four primary classes: 
- 상의(tops)
- 하의(bottoms)
- 원피스(dresses)
- 아우터(outerwear)

Each class is annotated with attributes such as has '세부 카테고리'(sub-category), '컬러'(color), '디테일'(detail), '프린트'(print), '소재'(textile), '사이즈'(size), '기장'(clothing length), and '소매기장'(sleeve length). Additional attributes such as '넥라인'(neckline), and '칼라'(collar) information are included for relevant clothing types.

### Preprocessing
Since the dataset contained a large amount of information, we decided to simplify it. We only retained '세부 카테고리'(sub-category), '컬러'(color), '디테일'(detail), '프린트'(print), and '소매기장'(sleeve length) attributes, while also reducing the number of categories for clothing length. All other attributes were removed.
Our objective was to use only the bounding boxes and detailed clothing attributes for training YOLO. To achieve this, we performed preprocessing converting the dataset into the format suitable for YOLO training.

# Task2: Outfit Of The Day(OOTD) image embedding

## Detailed Information on Models
The detailed information is in [EmbeddingModel](EmbeddingModel/README.md)

## Dataset
We crawled style image from [Musinsa](https://www.musinsa.com/). We utilized 13 different styles (Casual, Chic, Cityboy, Classic, Girlish, Gorpcore, Minimal, Preppy, Retro, Romantic, Sporty, Street, Workwear), and about 2,000 images for each styles. 