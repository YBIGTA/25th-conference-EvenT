package evenT.happy.dto.closetDto.UserDto;

import evenT.happy.dto.closetDto.CategoryResponseDto;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class ClosetResponseDto {
    private String userId;
    private List<CategoryResponseDto> categories;
}
