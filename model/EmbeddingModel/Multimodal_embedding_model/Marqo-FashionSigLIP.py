from transformers import AutoModel, AutoProcessor
import torch
from PIL import Image

model = AutoModel.from_pretrained('Marqo/marqo-fashionSigLIP', trust_remote_code=True)
processor = AutoProcessor.from_pretrained('Marqo/marqo-fashionSigLIP', trust_remote_code=True)

image = [Image.open("/root/25th-conference-EvenT/dataset/Musinsa_dataset/Casual/snap_card_1273191526769336686.jpg"), 
          Image.open("/root/25th-conference-EvenT/dataset/Musinsa_dataset/Casual/snap_card_1285240349896928778.jpg"),
          Image.open("/root/25th-conference-EvenT/dataset/Musinsa_dataset/Sporty/snap_card_1297901502898259067.jpg"),
          Image.open("/root/25th-conference-EvenT/dataset/Musinsa_dataset/Workwear/snap_card_1239373857858232324.jpg")]
text =  ['Casual', 'Minimal', 'Street', 'Girlish', 'Workwear', 'Chic', 
         'Gorpcore', 'Classic', 'Sporty', 'Romantic', 'Cityboy', 'Retro', 'Preppy']

processed = processor(text=text, images=image, padding='max_length', return_tensors="pt")

with torch.no_grad():
    image_features = model.get_image_features(processed['pixel_values'], normalize=True)
    print(image_features.shape)
    text_features = model.get_text_features(processed['input_ids'])
    
    text_probs = (100.0 * image_features @ image_features.T).softmax(dim=-1)
    text_probs1 = (100.0 * image_features @ text_features.T).softmax(dim=-1)

print("Label probs:\n", text_probs)
print("Label probs:\n", text_probs1)
