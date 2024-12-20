package evenT.happy.dto.closetDto;

import evenT.happy.domain.closet.Subcategory;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter @Setter
public class CategoryResponseDto {
    private String categoryName;
    private List<Subcategory> subcategories;
}
