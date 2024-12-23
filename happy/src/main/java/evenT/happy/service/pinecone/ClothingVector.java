package evenT.happy.service.pinecone;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ClothingVector {
    private int clothesId; // MongoDB에 저장된 고유 ID
    private String pineconeId; // Pinecone에 저장될 고유 ID
    private String userId; // 사용자 ID
    private List<Double> vector; // 벡터 데이터 (float 리스트)
}
