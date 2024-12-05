import os 
import json

def convert_to_coco_format(input_data):
    coco_format = {
        "info": {
            "description": "Custom Dataset converted to COCO format",
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

    # Categories Mapping
    categories = [
        {"id": 1, "name": "outer", "supercategory": "clothing"},
        {"id": 2, "name": "pants", "supercategory": "clothing"},
        {"id": 3, "name": "dress", "supercategory": "clothing"},
        {"id": 4, "name": "top", "supercategory": "clothing"}
    ]
    coco_format["categories"] = categories

    category_mapping = {
        "아우터": 1,  # outer
        "하의": 2,   # pants
        "원피스": 3, # dress
        "상의": 4    # top
    }
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

    annotation_id = 1  # Unique annotation ID
    for item in input_data:
        # Safely access image metadata
        image_info = item.get("이미지 정보", {})
        if not image_info:  # Skip if no image info is available
            continue

        image_metadata = {
            "id": image_info.get("이미지 식별자", -1),
            "file_name": f"{image_info.get('이미지 식별자', -1)}.jpg",
            "width": image_info.get("이미지 너비", 0),
            "height": image_info.get("이미지 높이", 0),
        }
        coco_format["images"].append(image_metadata)

        # Access dataset details
        dataset_info = item.get("데이터셋 정보", {}).get("데이터셋 상세설명", {})
        rect_data = dataset_info.get("렉트좌표", {})
        polygon_data = dataset_info.get("폴리곤좌표", {})
        attributes_data = dataset_info.get("라벨링", {})

        # Extract and validate style information
        style_data = attributes_data.get("스타일", [{}])[0]  # Extract first style data
        style_category = style_data.get("스타일", "")
        substyle = style_data.get("서브스타일", "")
        style_encoded = {"style": style_category, "substyle": substyle} if style_category else None

        for category_name in category_mapping:
            # Process rectangle data for the current category
            if category_name not in rect_data or not rect_data[category_name]:
                continue

            for rect in rect_data[category_name]:
                # Skip invalid bounding box data
                if not all(key in rect for key in ["X좌표", "Y좌표", "가로", "세로"]):
                    continue

                bbox = [
                    rect["X좌표"],
                    rect["Y좌표"],
                    rect["가로"],
                    rect["세로"]
                ]

                # Determine subcategory_id if available
                subcategory_id = None
                attributes = attributes_data.get(category_name, [{}])[0]
                subcategory_name = attributes.get("카테고리")
                if subcategory_name:
                    subcategory = next(
                        (sub for sub in subcategory_mapping.get(category_name, []) if sub["name"] == subcategory_name),
                        None
                    )
                    if subcategory:
                        subcategory_id = subcategory["id"]

                # Create annotation
                annotation = {
                    "id": annotation_id,
                    "image_id": image_info.get("이미지 식별자", -1),
                    "category_id": subcategory_id, # category_mapping[category_name],
                    "bbox": bbox,
                    "area": bbox[2] * bbox[3],
                    "segmentation": [],
                    "iscrowd": 0,
                    "style": style_encoded
                }

                # Add segmentation if polygon data exists
                if category_name in polygon_data:
                    for polygon in polygon_data[category_name]:
                        segmentation = [
                            polygon[key]
                            for key in sorted(polygon.keys())
                            if "X좌표" in key or "Y좌표" in key
                        ]
                        if segmentation:
                            annotation["segmentation"].append(segmentation)

                # Append annotation
                coco_format["annotations"].append(annotation)
                annotation_id += 1

    return coco_format



base_dir = "/home/Validation"
output_base_dir = "/home/Validation/processed"  # Directory to store processed files

for root, dirs, files in os.walk(base_dir):
    for file in files:
        if file.endswith(".json"):  # Process only JSON files
            # Construct the full input file path
            input_file_path = os.path.join(root, file)

            # Compute relative path to maintain directory structure
            relative_path = os.path.relpath(root, base_dir)

            # Create the corresponding output directory structure
            output_dir = os.path.join(output_base_dir, relative_path)
            os.makedirs(output_dir, exist_ok=True)

            # Create the output file path
            output_file_path = os.path.join(output_dir, f"modified_{file}")

            try:
                # Read the input JSON file
                with open(input_file_path, 'r') as f:
                    input_data = json.load(f)

                # Convert the data to COCO format
                converted_coco_data = convert_to_coco_format([input_data])  # Wrapping in list if function expects list

                # Save the converted data to the output file
                with open(output_file_path, 'w') as f:
                    json.dump(converted_coco_data, f, ensure_ascii=False, indent=4)

                print(f"Processed file saved at: {output_file_path}")

            except Exception as e:
                # Log errors if file processing fails
                print(f"Error processing file {input_file_path}: {e}")