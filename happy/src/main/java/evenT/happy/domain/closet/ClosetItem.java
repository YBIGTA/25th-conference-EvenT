package evenT.happy.domain.closet;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Document(collection = "closet_items")
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
public class ClosetItem {
    @Id
    private String id; // MongoDB 기본 ID

    private String userId; // 사용자 ID
    private List<Category> closet = new ArrayList<>(); // 초기화

    public ClosetItem(String userId, List<Category> closet) {
        this.userId = userId;
        this.closet = closet;
    }

}
