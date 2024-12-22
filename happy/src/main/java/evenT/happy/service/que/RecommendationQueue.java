package evenT.happy.service.que;

import evenT.happy.domain.User;
import evenT.happy.repository.UserRepository;
import evenT.happy.service.pinecone.PineconeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Mono;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

import static reactor.netty.internal.util.MapUtils.computeIfAbsent;

@Component
@RequiredArgsConstructor
public class RecommendationQueue {
    // 사용자별 큐를 저장하는 Map
    private final Map<String, Queue<RecommendedItem>> userQueues = new ConcurrentHashMap<>();

    // 사용자 큐에 추천 데이터 추가
    public void addRecommendation(String userId, RecommendedItem item) {
        userQueues.putIfAbsent(userId, new LinkedList<>()); // 큐가 없으면 생성
        Queue<RecommendedItem> queue = userQueues.get(userId);

        if (queue.size() >= 10) { // 큐 크기 제한
            queue.poll(); // 가장 오래된 데이터 삭제
        }

        queue.offer(item); // 새로운 추천 데이터 추가
    }

    // 사용자 큐에서 추천 데이터 소비
    public RecommendedItem consumeRecommendation(String userId) {
        Queue<RecommendedItem> queue = userQueues.get(userId);
        if (queue == null) {
            return null; // 큐가 없으면 null 반환
        }
        return queue.poll(); // 큐에서 데이터 제거 및 반환
    }

    // 사용자 큐 상태 조회
    public Queue<RecommendedItem> getRecommendations(String userId) {
        Queue<RecommendedItem> queue = userQueues.get(userId);
        return queue == null ? new LinkedList<>() : new LinkedList<>(queue); // 복사본 반환
    }



}
