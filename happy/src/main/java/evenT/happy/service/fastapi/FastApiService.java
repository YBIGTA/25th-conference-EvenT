package evenT.happy.service.fastapi;

import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class FastApiService {
    private final WebClient webClient;

    public FastApiService(WebClient.Builder webClientBuilder) {
        this.webClient = webClientBuilder.baseUrl("http://api-spring:8000").build(); // FastAPI ip 주소
    }
    //43.203.147.92

    public String sendDataToFastApi(String userId, String s3Url, String fulls3url) {
        Map<String, String> requestData = new HashMap<>();
        requestData.put("userId", userId);
        requestData.put("s3Url", s3Url);
        requestData.put("fulls3url",fulls3url);

        return webClient.post()
                .uri("/process") // FastAPI의 엔드포인트
                .bodyValue(requestData)
                .retrieve()
                .bodyToMono(String.class)
                .block(); // FastAPI의 응답 받기
    }

}
