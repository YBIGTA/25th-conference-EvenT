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
public class ClosetRequestDto {
    private int ClothesId;
    private String userId; // 사용자 ID
    private List<CategoryDto> categories; // 카테고리 목록
}