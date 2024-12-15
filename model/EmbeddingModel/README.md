# Outfit Of The Day (OOTD) image embedding

## Abstract
We developed a model to generate image embeddings for a recommendation service that displays style-similar images. Using style images crawled from [Musinsa](https://www.musinsa.com/), we leveraged pretrained models like ResNet and EfficientNet. To improve training performance, we preprocessed images with a [clothing detection model]() to focus on relevant features, reducing unnecessary background noise.

## Necessity
Our service aims to display images similar to the styles that users prefer. To achieve this, we built a vector database (vectorDB) to store image embeddings. Since the database requires inputs in the form of image embeddings, we developed this model to generate and store those embeddings effectively.

## Models
We utilized pretrained models such as ResNet, EfficientNet, and ResNeXt available in PyTorch or Keras.

## Methods
Initially, we attempted to implement contrastive learning using full OOTD images. However, we observed that the images contained too much unnecessary information, such as background details, which overshadowed the relevant style information. As a result, the training process was ineffective, with loss values stagnating and accuracy not improving.
To address this, we decided to preprocess the images using a clothing detection model. First, we extracted the bounding boxes (bboxes) for the clothing items. Then, we determined the bounding box for the entire human figure by calculating the maximum and minimum values of the x and y coordinates across all detected clothing bboxes. Finally, we used the human bbox as input to the image embedding model for better feature representation.