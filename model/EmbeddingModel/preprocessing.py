import csv
import os

if __name__ == "__main__":
    # get folder names in the directory
    directory = "../../dataset/Musinsa_dataset"
    folders = os.listdir(directory)

    # save the file name with the number(i) corresponding to the folder name
    style2index = []
    file_folder_map = {}
    for i in range(len(folders)):
        folder = folders[i]
        files = os.listdir(f"{directory}/{folder}")
        
        for file in files:
            file_folder_map[file] = i
        
        style2index.append({folder: i})

    # save the file name and the corresponding folder number to a csv file
    with open("file_folder_map.csv", "w") as f:
        writer = csv.writer(f)
        writer.writerow(["file", "folder"])
        for file, folder in file_folder_map.items():
            writer.writerow([file, folder])

    print("Saved file_folder_map.csv")
    print(style2index)
