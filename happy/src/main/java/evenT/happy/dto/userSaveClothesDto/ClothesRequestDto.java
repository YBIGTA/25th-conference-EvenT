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
public class ClothesRequestDto {
    private int clothesId; // 사용자 ID
    private List<CategoryDto> categories; // 카테고리 목록
}