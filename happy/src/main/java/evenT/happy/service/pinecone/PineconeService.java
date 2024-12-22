package evenT.happy.service.pinecone;


import evenT.happy.service.UserService;
import evenT.happy.service.que.QueryResponse;
import evenT.happy.service.que.RecommendedItem;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class PineconeService {
    private final UserService userService;

    @Value("${pinecone.api-key}")
    private String PINECONE_API_KEY;

    @Value("${pinecone.api-url}")
    private String PINECONE_API_URL;

    private WebClient webClient;

    @PostConstruct
    void init() {
        this.webClient = WebClient.builder()
                .baseUrl(PINECONE_API_URL)
                .defaultHeader("Api-Key", PINECONE_API_KEY)
                .defaultHeader("Accept", MediaType.APPLICATION_JSON_VALUE)
                .defaultHeader("Content-Type", MediaType.APPLICATION_JSON_VALUE)
                .build();
    }

    public Mono<Void> addVectors(List<Map<String, Object>> vectors, String namespace) {
        // 데이터 검증
        if (vectors == null || vectors.isEmpty()) {
            throw new IllegalArgumentException("Documents list is null or empty");
        }
        if (namespace == null) {
            namespace = ""; // Free Tier에서는 빈 문자열 사용
        }

        // 요청 본문 생성
        var body = Map.of(
                "vectors", vectors,
                "namespace", namespace
        );

        return this.webClient.post()
                .uri("/vectors/upsert")
                .bodyValue(body)
                .retrieve()
                .bodyToMono(Void.class);
    }

    public Flux<CustomResult> findSimilarDocuments(String userId, List<Double> embedding, int maxResults, String namespace) {
        // Build the request body
        var body = Map.of(
                "vector", embedding,
                "topK", maxResults,
                "includeMetadata", true,
                "namespace", namespace
        );

        System.out.println("Request Body: " + body);

        // Call Pinecone API
        return this.webClient.post()
                .uri("/query")
                .bodyValue(body)
                .retrieve()
                .bodyToMono(QueryResponse.class)
                .doOnNext(response -> System.out.println("Response: " + response))
                .map(QueryResponse::getMatches)
                .flatMapIterable(matches -> matches)
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

                    // Create RecommendedItem and add to queue
                    RecommendedItem item = new RecommendedItem(userId, clothesId != null ? clothesId : 0, s3Url);
                    userService.addRecommendationForUser(userId, item);

                    // Return CustomResult for client
                    return new CustomResult(userId, clothesId, s3Url);
                });







    }
    public Flux<RecommendedItem> findAddSimilarDocuments(String userId, List<Double> embedding, int maxResults, String namespace) {
        // Build the request body
        var body = Map.of(
                "vector", embedding,
                "topK", maxResults,
                "includeMetadata", true,
                "namespace", namespace
        );

        System.out.println("Request Body: " + body);

        // Call Pinecone API
        return this.webClient.post()
                .uri("/query")
                .bodyValue(body)
                .retrieve()
                .bodyToMono(QueryResponse.class)
                .flatMapIterable(QueryResponse::getMatches)
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

                    // Create RecommendedItem
                    return new RecommendedItem(userId, clothesId != null ? clothesId : 0, s3Url);
                });
    }

}








