package evenT.happy.domain.sampleclothes;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.ArrayList;
import java.util.List;

@Document(collection = "clothes")
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
public class ClothesItem {

    @Id
    private String id;

    private int clothesId;
    private List<Category> closet = new ArrayList<>(); // 카테고리 목록
    private String fulls3url;
    private List<Double> vector ;
    public ClothesItem(int clothesId, List<Category> closet, String fulls3url, List<Double> vector) {
        this.clothesId = clothesId;
        this.closet = closet;
        this.fulls3url = fulls3url;
        this.vector = vector;
    }

    public <E> ClothesItem(int clothesId, ArrayList<E> es) {
    }
}
