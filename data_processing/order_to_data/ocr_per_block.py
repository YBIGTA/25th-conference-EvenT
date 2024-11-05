from paddleocr import PaddleOCR
import os
import json

def concat_bbox_to_line(tmp_list):
    """
        get the bounding box of the whole line
        each bounding box is consist of 4 points: [x1, y1], [x2, y2], [x3, y3], [x4, y4]
    """
    x_min = 0
    y_min = 10000
    x_max = 0
    y_max = 0
    for i in range(len(tmp_list)):
        for j in range(4):
            y_min = min(y_min, tmp_list[i][0][j][1])
            x_max = max(x_max, tmp_list[i][0][j][0])
            y_max = max(y_max, tmp_list[i][0][j][1])
    
    return [[x_min, y_min], [x_max, y_min], [x_max, y_max], [x_min, y_max]]

def concat_bbox_to_block(tmp_list):
    """
        get the bounding box of the whole block
        each bounding box is consist of 4 points: [x1, y1], [x2, y2], [x3, y3], [x4, y4]
    """
    x_min = 0
    y_min = 10000
    x_max = 0
    y_max = 0
    for i in range(len(tmp_list)):
        for j in range(4):
            y_min = min(y_min, tmp_list[i]["bbox"][j][1])
            x_max = max(x_max, tmp_list[i]["bbox"][j][0])
            y_max = max(y_max, tmp_list[i]["bbox"][j][1])

    
    return [[x_min, y_min], [x_max, y_min], [x_max, y_max], [x_min, y_max]]

def concat_string_to_line(tmp_list):
    """
        concatenate the strings in the list
        if words_to_line = True, concatenate the strings in the list in the order of x coordinate
        if words_to_line = False, it is used in line_to_block function
            which needs to be concatenated in the order of y coordinate
    """
    tmp_string = ""
    tmp_list.sort(key = lambda x: x[0][0][0])

    if tmp_list:
        for j in range(len(tmp_list)):
            tmp_string += tmp_list[j][1][0] + " "
    
    return tmp_string

def concat_string_to_block(tmp_list):
    """
        concatenate the strings in the list
        tmp_list: list of dictionary
            each dictionary has string and bbox
    """
    tmp_string = ""

    for j in range(len(tmp_list)):
        tmp_string += tmp_list[j]["string"] + "\n"

    return tmp_string

def word_to_line(result):
    """
        if the elements in a result looks in a line, combine them into a single line
        1. Check the y coordinate of each element
        2. If the y coordinate of two elements are similar, combine them
    """
    result_dict = []
    result.sort(key = lambda x: x[0][0][1])
    tmp = result[0]
    tmp_list = [result[0]]
    for i in range(1, len(result)):
        # if two elements are in the same line, append the element
        if abs(tmp[0][0][1] - result[i][0][0][1]) < 10:
            tmp_list.append(result[i])

        # combine the elements in tmp_list
        else:
            result_dict.append({"string": concat_string_to_line(tmp_list), "bbox": concat_bbox_to_line(tmp_list)})
            tmp_list = [result[i]]
        tmp = result[i]
    return result_dict

def line_to_block(result):
    """
        split the text into 4 types of blocks: 결제완료, 결제오류, 구매확정, 상품준비중
        We only need the clothes that is in user's closet
        We only need the block that has "구매확정" because if "구매확정" is in the block, product is already in user's closet. 
        Otherwise, it is not.

        input: result (list of dictionary)
            OCR results per line, with bbox and string
            If keyword is in the line, it is a start of a new block
        output: block_list (list of dictionary)
            OCR results per block, with bbox and string

    """
    keywords = ["결제완료", "결제오류", "구매확정", "상품준비중"]
    block_list = []
    block = []
    for line in result:
        # check if there is a keyword in the line
        text_for_line = line["string"]

        flag = True
        for keyword in keywords:
            if keyword in text_for_line:
                # Append only "구매확정" block
                if "구매확정" in text_for_line:
                    block_list.append({"string": concat_string_to_block(block), "bbox": concat_bbox_to_block(block)})
                
                # clear the block
                block = []
                block.append(line)
                flag = False

        # if there was no keyword in the line
        if flag:
            block.append(line)

    if "구매확정" in concat_string_to_block(block):
        block_list.append({"string": concat_string_to_block(block), "bbox": concat_bbox_to_block(block)})

    return block_list

def ocr_per_block(img_folder):
    # load the OCR model
    ocr = PaddleOCR(lang = "korean")

    # find the path of all images in the folder
    img_list = os.listdir(img_folder)
    
    for img in img_list:
        # read the image
        img_path = os.path.join(img_folder, img)
        result = ocr.ocr(img_path)

        ocr_result = result[0]
        ocr_result_in_line = word_to_line(ocr_result)
        ocr_result_in_block = line_to_block(ocr_result_in_line)

        # save the result in block
        result_path = os.path.join("resultOCRinBlock", img.split(".")[0] + ".json")
        # it includes korean characters so we need to use utf-8 encoding
        with open(result_path, "w", encoding = "utf-8") as f:
            json.dump(ocr_result_in_block, f, ensure_ascii = False, indent = 4)

if __name__ == "__main__":
    img_folder = "dataset/order_dataset/Musinsa"
    ocr_per_block(img_folder)