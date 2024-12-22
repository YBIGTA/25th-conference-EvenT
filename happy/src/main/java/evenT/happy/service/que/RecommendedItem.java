package evenT.happy.service.que;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RecommendedItem {
    private String userId;   // 사용자 ID
    private int clothesId;   // 추천된 옷 ID
    private String s3Url;    // 이미지 URL
}
