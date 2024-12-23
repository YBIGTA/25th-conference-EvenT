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
    private int clothesId;
    private String categoryName;
    private String name;
    private String color;
    private String print;
    private String s3Url;

    // 생성자
    public UserActionSaveComparison(String userId, int clothesId, String categoryName, String name, String color, String print, String s3Url) {
        this.userId = userId;
        this.clothesId = clothesId;
        this.categoryName = categoryName;
        this.name = name;
        this.color = color;
        this.print = print;
        this.s3Url = s3Url;
    }
}
