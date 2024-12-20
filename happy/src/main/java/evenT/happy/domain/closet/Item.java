package evenT.happy.domain.closet;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Item {
    private String customName; // 커스텀 이름
    private Attributes attributes; // 아이템 속성 (색상, 프린트, 길이)
    private String s3Url; // 이미지 URL (S3)
    private int quantity; // 수량
    private int status;
}