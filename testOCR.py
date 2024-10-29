from paddleocr import PaddleOCR
import os
import json

def boundingBox(tmp_list):
    """
        get the bounding box of the whole line
    """
    x1 = tmp_list[0][0][0][0]
    y1 = tmp_list[0][0][0][1]
    x2 = tmp_list[0][0][1][0]
    y2 = tmp_list[0][0][1][1]
    for i in range(1, len(tmp_list)):
        if x1 > tmp_list[i][0][0][0]:
            x1 = tmp_list[i][0][0][0]
        if y1 > tmp_list[i][0][0][1]:
            y1 = tmp_list[i][0][0][1]
        if x2 < tmp_list[i][0][1][0]:
            x2 = tmp_list[i][0][1][0]
        if y2 < tmp_list[i][0][1][1]:
            y2 = tmp_list[i][0][1][1]
    
    return [[x1, y1], [x2, y2]]

    

def concatString(tmp_list):
    tmp_string = ""
    tmp_list.sort(key = lambda x: x[0][0][0])
    for j in range(len(tmp_list)):
        tmp_string += tmp_list[j][1][0] + " "
    
    return tmp_string

def postProcess(result):
    """
        if the elements in a result looks in a line,
        combine them into a single line
        1. Check the y coordinate of each element
        2. If the y coordinate of two elements are similar,
           combine them into a single line
    """
    result_dict = []
    result.sort(key = lambda x: x[0][0][1])
    tmp = result[0]
    tmp_list = [result[0]]
    for i in range(1, len(result)):
        if abs(tmp[0][0][1] - result[i][0][0][1]) < 10:
            tmp_list.append(result[i])
        else:
            # combine the elements in tmp_list into a single line
            # bbox = boundingBox(tmp_list)    # get bounding box of the whole line
            result_string = concatString(tmp_list)  # concat strings in tmp_list
            result_dict.append({"string": concatString(tmp_list), "bbox": bbox})    # save the result
            tmp_list = [result[i]]
        tmp = result[i]
    return result_dict

def testOCR():
    # load the OCR model
    ocr = PaddleOCR(lang = "korean")

    # find the path of all images in the folder
    img_folder = "dataset"
    img_list = os.listdir(img_folder)
    
    for img in img_list:
        # read the image
        img_path = os.path.join(img_folder, img)
        result = ocr.ocr(img_path)

        ocr_result = result[0]
        ocr_result = postProcess(ocr_result)
        
        # save the result
        result_path = os.path.join("resultOCR", img.split(".")[0] + ".txt")
        with open(result_path, "w") as f:
            f.write(ocr_result)

if __name__ == "__main__":
    testOCR()