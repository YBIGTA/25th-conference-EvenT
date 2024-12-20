package evenT.happy.dto.closetDto;

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
    private String categoryName; // 카테고리 이름
    private List<SubcategoryDto> subcategories; // 서브카테고리 목록
}
