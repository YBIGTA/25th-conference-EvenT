package evenT.happy.dto.userSaveClothesDto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ClothesItemDto {
    private int clothesId;
    private List<CategoryDto> closet = new ArrayList<>();
}
