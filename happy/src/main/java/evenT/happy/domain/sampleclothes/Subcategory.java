package evenT.happy.domain.sampleclothes;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Subcategory {
    private String name; // 예: "셔츠", "청바지"
    private List<Item> items = new ArrayList<>(); // 아이템 목록
}
