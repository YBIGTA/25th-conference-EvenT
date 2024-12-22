package evenT.happy.service.que;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor // 추천 데이터 추가 요청 객체
public class RecommendationRequest {
    private String userId;
    private RecommendedItem item;
}
