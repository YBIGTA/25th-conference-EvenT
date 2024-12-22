package evenT.happy.service.pinecone;

import evenT.happy.domain.User;
import evenT.happy.domain.sampleclothes.ClothesItem;
import evenT.happy.repository.SampleClothesRepository;
import evenT.happy.repository.UserRepository;
import evenT.happy.service.UserService;
import evenT.happy.service.que.RecommendationQueue;
import evenT.happy.service.que.RecommendationService;
import evenT.happy.service.que.UserRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@RestController
@RequestMapping("/pinecone")
@RequiredArgsConstructor
public class PineconeController {


    private final PineconeService pineconeService;
    private final UserService userService;
    private final UserRepository userRepository;
    private final RecommendationService recommendationService;


    // test 데이터 넣는거
    @PostMapping("/add")
    public ResponseEntity<String> addVectors(@RequestBody Map<String, Object> request) {
        try {
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> vectors = (List<Map<String, Object>>) request.get("vectors");
            String namespace = (String) request.getOrDefault("namespace", "");

            if (vectors == null || vectors.isEmpty()) {
                return ResponseEntity.badRequest().body("Documents list is null or empty");
            }

            pineconeService.addVectors(vectors, namespace);
            return ResponseEntity.ok("Documents added successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error: " + e.getMessage());
        }
    }

//    @GetMapping("/search")
//    public Flux<CustomResult> searchDocuments(@RequestBody Map<String, Object> request) {
//        @SuppressWarnings("unchecked")
//        List<Double> embedding = (List<Double>) request.get("embedding");
//        int maxResults = (int) request.getOrDefault("maxResults", 5);
//        String namespace = (String) request.getOrDefault("namespace", "");
//        String userId = (String) request.getOrDefault("userId", "user123"); // Default value if userId is not provided
//        return pineconeService.findSimilarDocuments(userId, embedding, maxResults, namespace);
//    }
    @GetMapping("/search")
    public Flux<CustomResult> searchDocuments(@RequestParam(name = "userId") String userId) {
    // Retrieve preference from UserRepository
        User user = userRepository.findByUserId(userId)
            .orElseThrow(() -> new RuntimeException("User not found with userId: " + userId));

    // Extract preference
        List<Double> embedding = user.getPreference(); // Assuming preference is a List<Double>

    // Default values for maxResults and namespace
        int maxResults = 10;
        String namespace = "";

    // Call the service
        return pineconeService.findSimilarDocuments(userId, embedding, maxResults, namespace);
}
    @PostMapping("/action/like")
    public ResponseEntity<String> likeItem(@RequestBody LikeRequest likeRequest) {
        String userId = likeRequest.getUserId();
        userService.updateUserPreference(userId);
        return ResponseEntity.ok("User preference updated successfully.");
    }
    // 호출되면 뒤에 다가 데이터 추가
    @PostMapping("/action/add")
    public ResponseEntity<String> addRecommendation(@RequestBody UserRequest userRequest) {
        // 추천 데이터를 큐에 추가
        recommendationService.addRecommendationsToQueue(userRequest.getUserId())
                .subscribe(); // 비동기 실행

        return ResponseEntity.ok("Recommendation process started successfully.");
    }

}
