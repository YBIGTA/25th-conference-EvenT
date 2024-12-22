package evenT.happy.dto.userSaveClothesDto;

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
public class UserSaveClothesRequestDto {
    private String userId; // 사용자 ID
    private List<ClothesItemDto> userSaveCloset = new ArrayList<>();

}
