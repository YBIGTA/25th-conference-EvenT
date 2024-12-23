package evenT.happy.domain.user_action_save_comparison;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "user_action_save_comparison")
public class UserActionSaveComparison {
    @Id
    private String id;
    private String userId;
    private String fulls3url;
    private int clothesId;
    private String categoryName;
    private String name;
    private String color;
    private String length;
    private String s3Url;

    // 생성자
    public UserActionSaveComparison(String userId, int clothesId,String fulls3url, String categoryName, String name, String color, String length, String s3Url) {
        this.userId = userId;
        this.clothesId = clothesId;
        this.fulls3url = fulls3url;
        this.categoryName = categoryName;
        this.name = name;
        this.color = color;
        this.length = length;
        this.s3Url = s3Url;
    }
}