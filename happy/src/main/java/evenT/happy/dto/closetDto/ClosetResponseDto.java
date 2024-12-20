package evenT.happy.dto.closetDto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class ClosetResponseDto {
    private String userId;
    private List<CategoryResponseDto> categories;
}
