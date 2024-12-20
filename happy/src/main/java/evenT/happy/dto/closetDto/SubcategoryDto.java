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
public class SubcategoryDto {
    private String name; // 서브카테고리 이름
    private List<ItemDto> items; // 아이템 목록
}