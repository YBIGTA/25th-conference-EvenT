package evenT.happy.service.que;

import evenT.happy.domain.User;
import evenT.happy.repository.UserRepository;
import evenT.happy.service.pinecone.PineconeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class RecommendationService {

    private final RecommendationQueue recommendationQueue;
    private final PineconeService pineconeService;
    private final UserRepository userRepository;

    public Mono<Void> addRecommendationsToQueue(String userId) {
        // MongoDB에서 사용자 정보 조회
        Optional<User> optionalUser = userRepository.findByUserId(userId);
        if (optionalUser.isEmpty()) {
            return Mono.error(new IllegalArgumentException("User not found with userId: " + userId));
        }

        User user = optionalUser.get();
        List<Double> preference = user.getPreference();

        // Vector DB 호출 및 큐에 데이터 추가
        return pineconeService.findAddSimilarDocuments(userId, preference, 10, "clothing-recommendation")
                .doOnNext(item -> recommendationQueue.addRecommendation(userId, item)) // 큐에 추가
                .then();
    }
}
