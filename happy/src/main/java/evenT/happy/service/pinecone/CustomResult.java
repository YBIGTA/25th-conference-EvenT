package evenT.happy.service.pinecone;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;

@Data
@NoArgsConstructor
public class CustomResult {
    private String userId;
    private Item item;

    public CustomResult(String userId, Integer clothesId, String s3Url) {
        this.userId = userId;
        this.item = new Item(clothesId, s3Url);
    }

    // Inner class to represent "item" structure
    public static class Item {
        private Integer clothesId;
        private String s3Url;

        public Item(Integer clothesId, String s3Url) {
            this.clothesId = clothesId;
            this.s3Url = s3Url;
        }

        // Getters and setters
        public Integer getClothesId() {
            return clothesId;
        }

        public void setClothesId(Integer clothesId) {
            this.clothesId = clothesId;
        }

        public String getS3Url() {
            return s3Url;
        }

        public void setS3Url(String s3Url) {
            this.s3Url = s3Url;
        }
    }

    // Getters and setters for userId and item
    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public Item getItem() {
        return item;
    }

    public void setItem(Item item) {
        this.item = item;
    }}
