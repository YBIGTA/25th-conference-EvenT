package evenT.happy.domain.closet;

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
public class Category {
    private String categoryName; // 카테고리 이름 (상의, 하의 등)
    private List<Subcategory> subcategories = new ArrayList<>(); // 서브카테고리 목록
}