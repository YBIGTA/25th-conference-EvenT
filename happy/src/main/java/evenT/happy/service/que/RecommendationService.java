package evenT.happy.service.que;

import evenT.happy.domain.User;
import evenT.happy.repository.UserRepository;
import evenT.happy.service.pinecone.CustomResult;
import evenT.happy.service.pinecone.PineconeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class RecommendationService {

    private final RecommendationQueue recommendationQueue;
    private final PineconeService pineconeService;
    private final UserRepository userRepository;

    public Mono<Void> addRecommendationsToQueue1(String userId) {
        // MongoDB에서 사용자 정보 조회
        Optional<User> optionalUser = userRepository.findByUserId(userId);
        if (optionalUser.isEmpty()) {
            return Mono.error(new IllegalArgumentException("User not found with userId: " + userId));
        }

        User user = optionalUser.get();
        List<Double> preference = user.getPreference();

        // Vector DB 호출 및 큐에 데이터 추가
        return pineconeService.findAddSimilarDocuments1(userId, preference, 10, "clothing-recommendation")
                .doOnNext(item -> recommendationQueue.addRecommendation(userId, item)) // 큐에 추가
                .then();
    }
    public Flux<CustomResult> addRecommendations(String userId) {
        // MongoDB에서 사용자 정보 조회
        Optional<User> optionalUser = userRepository.findByUserId(userId);
        if (optionalUser.isEmpty()) {
            return Flux.error(new IllegalArgumentException("User not found with userId: " + userId));
        }

        User user = optionalUser.get();
        List<Double> preference = user.getPreference();

        // Vector DB 호출 및 추천 데이터 생성
        return pineconeService.findAddSimilarDocuments(userId, preference, 10, "clothing-recommendation")
                .map(match -> {
                    // Extract clothesId
                    Integer clothesId = null;
                    if (match.getMetadata() != null && match.getMetadata().containsKey("clothesId")) {
                        Object clothesIdObj = match.getMetadata().get("clothesId");
                        if (clothesIdObj instanceof Integer) {
                            clothesId = (Integer) clothesIdObj;
                        } else if (clothesIdObj instanceof String) {
                            try {
                                clothesId = Integer.parseInt((String) clothesIdObj);
                            } catch (NumberFormatException e) {
                                System.err.println("Invalid clothesId: " + clothesIdObj);
                            }
                        }
                    }

                    // Extract s3Url
                    String s3Url = match.getMetadata() != null && match.getMetadata().containsKey("s3Url")
                            ? match.getMetadata().get("s3Url").toString()
                            : null;

                    // Return CustomResult for client
                    return new CustomResult(userId, clothesId != null ? clothesId : 0, s3Url);
                });
}}
