"""
전처리: 결제완료, 결제오류, 구매확정 베이스로 split
결제완료, 결제오류 block은 지워버리기
구매확정 block에서 상품정보, 색상 추출
방법1. 모델 이용
"""
import os

def list_to_string(list):
    # block to string
    block_string = ""
    for i in range(len(list)):
        block_string += list[i] + " "

    return block_string

def preprocessing(text):
    """
        split the text into three blocks: 결제완료, 결제오류, 구매확정
        We only need the clothes that is in user's closet
        We only need the block that has "구매확정".
        Because, if "구매확정" is in the block, product is already in user's closet. 
        Otherwise, it is not
    """
    keywords = ["결제완료", "결제오류", "구매확정", "상품준비중"]
    text_list = text.split("\n")
    block_list = []
    block = []
    for line in text_list:
        # check if there is a keyword in the line
        flag = True
        for keyword in keywords:
            if keyword in line:
                block_str = list_to_string(block)

                # Append only "구매확정" block
                if "구매확정" in block_str:
                    block_list.append(block_str)
                
                # clear the block
                block = []
                block.append(line)
                flag = False

        # if there was no keyword in the line
        if flag:
            block.append(line)

    if "구매확정" in list_to_string(block):
        block_list.append(list_to_string(block))

    return block_list

def textToDB():
    # find the path of all result files
    result_folder = "resultOCR"
    result_list = os.listdir(result_folder)

    for result in result_list:
        result_path = os.path.join(result_folder, result)
        with open(result_path, "r") as f:
            text = f.read()
        # Now, each element of block_list is 구매확정 block in 1 line
        block_list = preprocessing(text)
        for block in block_list:
            print(block + "\n\n")


if __name__ == "__main__":
    textToDB()
