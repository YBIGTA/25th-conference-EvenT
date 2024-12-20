package evenT.happy.domain.closet;

import evenT.happy.domain.closet.Item;
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
    private String name; // 서브카테고리 이름 (셔츠, 티셔츠 등)
    private List<Item> items = new ArrayList<>(); // 아이템 목록
}