package evenT.happy.dto.userSaveClothesDto;

import evenT.happy.dto.closetDto.CategoryResponseDto;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter @Setter
public class ClothesResponseDto {
    private int clothesId;
    private List<CategoryResponseDto> categories;
}
