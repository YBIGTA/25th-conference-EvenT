package evenT.happy.dto.userSaveClothesDto;

import evenT.happy.domain.sampleclothes.Attributes;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ItemDto {
    private String customName; // 사용자 정의 이름
    private Attributes attributes; // 속성 (색상, 인쇄물 등)
    private String s3Url; // 이미지 URL
    private int quantity; // 수량
    private int status; // 상태
    private List<Float> vector;
}
