package evenT.happy.service.que;

import evenT.happy.service.UserService;
import evenT.happy.service.pinecone.CustomResult;
import evenT.happy.service.pinecone.PineconeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.concurrent.CompletableFuture;

@RestController
@RequestMapping("/recommendations")
@RequiredArgsConstructor
public class RecommendationController {
    private final UserService userService;
    private final PineconeService pineconeService;



    // 추천 데이터 추가
    @PostMapping("/add/example")
    public ResponseEntity<String> addRecommendation(@RequestBody RecommendationRequest request) {
        userService.addRecommendationForUser(request.getUserId(), request.getItem());
        return ResponseEntity.ok("Recommendation added for user " + request.getUserId());
    }

    // 추천 데이터 소비 (GET)
    @GetMapping("/consume")
    public ResponseEntity<RecommendedItem> consumeRecommendation(@RequestParam(name = "userId") String userId) {
        RecommendedItem item = userService.consumeRecommendationForUser(userId);
        if (item == null) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(item);
    }


    // 추천 데이터 조회
    @PostMapping("/list")
    public ResponseEntity<Queue<RecommendedItem>> getRecommendations(@RequestBody UserRequest request) {
        Queue<RecommendedItem> recommendations = userService.getRecommendationsForUser(request.getUserId());
        return ResponseEntity.ok(recommendations);
    }


}
