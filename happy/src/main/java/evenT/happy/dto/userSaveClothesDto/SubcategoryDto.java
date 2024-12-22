package evenT.happy.dto.userSaveClothesDto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SubcategoryDto {
    private String name; // 예: "셔츠"
    private List<ItemDto> items; // 아이템 목록
}
