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
    private List<evenT.happy.domain.sampleclothes.ClothesItem> userSaveCloset = new ArrayList<>();

    public UserSaveClothes() {
    }

    public UserSaveClothes(String userId, List<evenT.happy.domain.sampleclothes.ClothesItem> userSaveCloset) {
        this.userId = userId;
        this.userSaveCloset = userSaveCloset;
    }

}
