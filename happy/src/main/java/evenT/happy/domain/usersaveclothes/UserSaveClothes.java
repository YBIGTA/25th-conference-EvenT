package evenT.happy.domain.usersaveclothes;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.ArrayList;
import java.util.List;
@Getter
@Setter
@Document(collection = "userSaveClothes")
public class UserSaveClothes {


    private String userId;
    private String fulls3url;
    private List<Double> vector;
    private List<ClothesItem> userSaveCloset = new ArrayList<>();

    public UserSaveClothes() {
    }

    public UserSaveClothes(String userId, List<ClothesItem> userSaveCloset, String fulls3url, List<Double> vector) {
        this.userId = userId;
        this.userSaveCloset = userSaveCloset;
        this.fulls3url = fulls3url;
        this.vector = vector;
    }


}
