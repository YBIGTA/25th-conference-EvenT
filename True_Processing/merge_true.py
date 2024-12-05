import os
import json

def merge_coco_files(input_dir, output_file):
    merged_data = {
        "info": {
            "description": "Combined Dataset",
            "version": "1.0",
            "year": 2024,
            "contributor": "Your Name",
            "date_created": "2024-11-15"
        },
        "licenses": [],
        "images": [],
        "annotations": [],
        "categories": []
    }

    # Flatten subcategory_mapping into categories
    subcategory_mapping = {
        "아우터": [
            {"id": 1, "name": "코트"}, {"id": 2, "name": "재킷"}, {"id": 3, "name": "점퍼"},
            {"id": 4, "name": "패딩"}, {"id": 5, "name": "베스트"}, {"id": 6, "name": "가디건"}, {"id": 7, "name": "짚업"}
        ],
        "하의": [
            {"id": 8, "name": "청바지"}, {"id": 9, "name": "팬츠"}, {"id": 10, "name": "스커트"},
            {"id": 11, "name": "레깅스"}, {"id": 12, "name": "조거팬츠"}
        ],
        "원피스": [
            {"id": 13, "name": "드레스"}, {"id": 14, "name": "점프수트"}
        ],
        "상의": [
            {"id": 15, "name": "탑"}, {"id": 16, "name": "블라우스"}, {"id": 17, "name": "티셔츠"},
            {"id": 18, "name": "니트웨어"}, {"id": 19, "name": "셔츠"}, {"id": 20, "name": "브라탑"}, {"id": 21, "name": "후드티"}
        ]
    }

    # Flattened categories for COCO format
    merged_data["categories"] = [
        sub for main_category in subcategory_mapping.values() for sub in main_category
    ]

    annotation_id_offset = 0
    image_id_offset = 0

    # Walk through all subdirectories and files
    for root, _, files in os.walk(input_dir):
        for file_name in files:
            if file_name.endswith(".json"):
                input_file_path = os.path.join(root, file_name)
                print(f"Processing file: {input_file_path}")

                with open(input_file_path, "r") as f:
                    coco_data = json.load(f)

                # Adjust images
                for image in coco_data["images"]:
                    old_image_id = image["id"]
                    new_image_id = image_id_offset + image["id"]
                    image["id"] = new_image_id
                    merged_data["images"].append(image)

                    # Update annotations to use new image IDs
                    for annotation in coco_data["annotations"]:
                        if annotation["image_id"] == old_image_id:
                            annotation["image_id"] = new_image_id

                # Adjust annotations
                for annotation in coco_data["annotations"]:
                    # Validate `category_id` exists in the subcategory_mapping
                    if annotation["category_id"] not in [cat["id"] for cat in merged_data["categories"]]:
                        print(f"Error: category_id {annotation['category_id']} not found in categories. Skipping annotation.")
                        continue

                    # Assign a unique annotation ID
                    annotation["id"] += annotation_id_offset
                    merged_data["annotations"].append(annotation)

                # Update offsets
                annotation_id_offset = max(ann["id"] for ann in merged_data["annotations"]) + 1
                image_id_offset = max(img["id"] for img in merged_data["images"]) + 1

    # Write merged data to output JSON file
    with open(output_file, "w") as f:
        json.dump(merged_data, f, indent=4, ensure_ascii=False)

    print(f"Merged annotations saved to {output_file}")

# Usage
input_directory = "/home/Training/processed"  # Directory containing all JSON annotation files
output_json = "/home/Training/merged_annotation.json"  # Path for the merged JSON
merge_coco_files(input_directory, output_json)