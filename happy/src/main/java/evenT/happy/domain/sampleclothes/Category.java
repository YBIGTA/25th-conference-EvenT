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
public class Category {
    private String categoryName; // 예: "상의", "하의"
    private List<Subcategory> subcategories = new ArrayList<>(); // 서브카테고리 목록
}
