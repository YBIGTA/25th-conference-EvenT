package evenT.happy.dto.clothesDto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CategoryDto {
    private String categoryName; // 예: "상의"
    private List<SubcategoryDto> subcategories; // 서브카테고리 목록
}
