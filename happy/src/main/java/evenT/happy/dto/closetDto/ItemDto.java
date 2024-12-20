package evenT.happy.dto.closetDto;

import evenT.happy.domain.closet.Attributes;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ItemDto {
    private String customName; // 커스텀 이름
    private Attributes attributes; // 아이템 속성
    private String s3Url; // 이미지 URL
    private int quantity; // 수량
    private int status;

}
