# Import packages needed
import os
import keras
import cv2
import numpy as np
import tensorflow as tf
import matplotlib.pyplot as plt

from keras import Model, Input
from keras.layers import Lambda, Dense
from keras.models import load_model, Sequential
from keras.ops import cast, maximum, square, norm
from keras.metrics import binary_accuracy
from keras.optimizers import Adam
from keras.applications import EfficientNetV2S


from tensorflow.keras.callbacks import EarlyStopping


from tqdm import tqdm
from sklearn.model_selection import train_test_split

# Set the GPU I want to use
gpus = tf.config.list_physical_devices('GPU')
if gpus:
    try:
        # Restrict TensorFlow to only use GPU:1
        tf.config.set_visible_devices(gpus[1], 'GPU')
        tf.config.experimental.set_memory_growth(gpus[1], True)
    except RuntimeError as e:
        print(e)


os.environ["KERAS_BACKEND"] = "tensorflow"

def load_image(image_path):
    image = cv2.imread(image_path)
    image = cv2.resize(image, (384, 384))
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    image = image.astype(np.float32) / 255.0

    return image

# Function for reading all the image from the dataset folder
def get_data():
    # read all the folders
    data_path = "/root/25th-conference-EvenT/dataset/Musinsa_dataset_cropped"
    folders = os.listdir(data_path)

    # read all the images inside the folders
    style2index = []
    images = []
    labels = []
    for i in range(len(folders)):
        folder = folders[i]
        folder_path = f"{data_path}/{folder}"

        if not os.path.isdir(folder_path):
            continue

        files = os.listdir(folder_path)
        print(folder)

        count = 0

        for file in tqdm(files):
            try:
                # read the image
                image = load_image(f"{folder_path}/{file}")
                image = image.astype(np.float16)

                images.append(image)
                labels.append(i)
                count += 1
                if count >= 100:
                    break

            except Exception as e:
                print(f"Error reading image {file}: {e}")
        style2index.append({folder: i})

    return images, labels, style2index

def generate_pair(X, y):
    """
        For contrastive learning, we need the dataset in pair.
        There should exist 
        Input: X(image), y(label)
        Output: X_pairs(image pair), y_pairs(label pair)
    """
    X = np.array(X)
    y = np.array(y)
    
    X_pairs = []
    y_pairs = []

    for i in range(len(X)):
        digit = y[i]

        positive_digit_index = np.random.choice(np.where(y == digit)[0])
        X_pairs.append([X[i], X[positive_digit_index]])
        y_pairs.append([0])

        negative_digit_index = np.random.choice(np.where(y!=digit)[0])
        X_pairs.append([X[i], X[negative_digit_index]])
        y_pairs.append([1])

    indices = np.arange(len(X_pairs))
    np.random.shuffle(indices)

    return np.array(X_pairs)[indices], np.array(y_pairs)[indices]

def cosine_distance(twins):
    twin1_output, twin2_output = twins
    twin1_norm = tf.linalg.l2_normalize(twin1_output, axis=1)
    twin2_norm = tf.linalg.l2_normalize(twin2_output, axis=1)

    cosine_similarity = twin1_norm * twin2_norm  # Element-wise multiplication
    cosine_similarity = tf.reduce_sum(cosine_similarity, axis=1, keepdims=True)

    return (1 - cosine_similarity)

def euclidean_distance(twins):
    """Compute the euclidean distance (norm) of the output of
    the twin networks.
    """
    twin1_output, twin2_output = twins
    return norm(twin1_output - twin2_output, axis=1, keepdims=True)


def contrastive_loss(y, d):
    """
    Compute the contrastive loss introduced by Yann LeCun et al. in the paper
    "Dimensionality Reduction by Learning an Invariant Mapping."
    """
    margin = 1
    y = cast(y, d.dtype)

    loss = (1 - y) / 2 * square(d) + y / 2 * square(maximum(0.0, margin - d) + 1e-6)
    return loss


if __name__ == "__main__":
    image, labels, style2index = get_data()
    print(len(image), len(labels))
    print(style2index)

    X_train, X_test, y_train, y_test = train_test_split(image, labels, test_size=0.2, random_state=42)
    print(f"train set size: {len(X_train)}, {len(y_train)}")
    print(f"test set size: {len(X_test)}, {len(y_test)}")

    X_train = np.array(X_train)
    X_test = np.array(X_test)
    Y_train = np.array(y_train)
    Y_test = np.array(y_test)

    print(X_train.shape, X_test.shape, Y_train.shape, Y_test.shape)

    X_train_pairs, Y_train_pairs = generate_pair(X_train, y_train)
    X_test_pairs, Y_test_pairs = generate_pair(X_test, y_test)

    print("X_train_pairs shape: ", X_train_pairs.shape)
    print("X_test_pairs shape: ", X_test_pairs.shape)


    # Use backbone of pretrained model

    input1 = Input(shape=(384,384,3,))
    input2 = Input(shape=(384,384,3,))

    base_model = EfficientNetV2S(weights="imagenet", include_top=True)

    network = Sequential(
        [
            Input(shape=(384, 384, 3)),
            base_model,
            Dense(256, activation=None)
        ]
    )

    twin1 = network(input1)
    twin2 = network(input2)

    distance = Lambda(cosine_distance)([twin1, twin2])
    # distance = Lambda(euclidean_distance)([twin1, twin2])
    model = Model(inputs=[input1, input2], outputs=distance)

    optimizer = Adam(0.005)
    model.compile(loss=contrastive_loss, optimizer=optimizer, metrics=[binary_accuracy])

    early_stopping = EarlyStopping(
        monitor='val_loss',  # Metric to monitor
        patience=100,         # Number of epochs with no improvement to stop training
        restore_best_weights=True  # Restore weights from the best epoch
    )

    with tf.device('/GPU:1'):
        history = model.fit(
            x=[X_train_pairs[:, 0], X_train_pairs[:, 1]],
            y=Y_train_pairs[:],
            validation_data=([X_test_pairs[:, 0], X_test_pairs[:, 1]], Y_test_pairs[:]),
            batch_size=8,
            epochs=500,
            callbacks=[early_stopping]
        )

    plt.plot(history.history["loss"])
    plt.plot(history.history["val_loss"])
    plt.title("Training and Validation Loss")
    plt.ylabel("loss")
    plt.xlabel("epoch")
    plt.legend(["train", "val"], loc="upper right")
    plt.show()

    predictions = model.predict([X_test_pairs[:, 0], X_test_pairs[:, 1]]) >= 0.5

    print(model.layers)
    print(model.layers[2].input)

    embedding_model = model.layers[2]
    print(embedding_model)

    # image_path = "/root/25th-conference-EvenT/dataset/Musinsa_dataset/Cityboy/snap_card_1277506810595237743.jpg"
    # image = load_image(image_path)
    # embedding = embedding_model.predict(image.reshape(1, 384, 384, 3))

    # print(embedding.shape)


    # Save the model
    embedding_model = Model(inputs=input1, outputs=twin1)
    embedding_model_path = "/root/25th-conference-EvenT/model/EmbeddingModel/embedding_model.h5"
    embedding_model.save(embedding_model_path)

    # Load the model
    # loaded_model = load_model(embedding_model_path)
    # image = load_image(image_path)

    # embedding = loaded_model.predict(image.reshape(1, 384, 384, 3))

    # print("Generated embedding: ", embedding)