package evenT.happy.domain.userClothesComparsion;


import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "user_clothes_comparison")
public class UserClothesComparison {
    @Id
    private String id;
    private String userId;
    private String categoryName;
    private String name;
    private String color;
    private String length;
    private String s3Url;
    public UserClothesComparison(String userId, String categoryName, String name, String color, String length, String s3Url) {
        this.userId = userId;
        this.categoryName = categoryName;
        this.name = name;
        this.color = color;
        this.length = length;
        this.s3Url = s3Url;
    }
}
