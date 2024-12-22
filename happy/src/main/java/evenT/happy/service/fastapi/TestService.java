package evenT.happy.service.fastapi;

import evenT.happy.service.aws.S3Service;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.reactive.function.client.WebClient;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service

public class TestService {
    private final S3Service s3Service;
    private final WebClient webClient;


    public TestService(S3Service s3Service, WebClient.Builder webClientBuilder) {
        this.s3Service = s3Service;
        this.webClient = webClientBuilder.baseUrl("http://api-spring:8000").build();
    }
    public File convertMultiPartToFile(MultipartFile multipartFile) throws IOException {
        File convFile = new File(System.getProperty("java.io.tmpdir") + "/" + multipartFile.getOriginalFilename());
        try (FileOutputStream fos = new FileOutputStream(convFile)) {
            fos.write(multipartFile.getBytes());
        }
        return convFile;
    }

    public String uploadFileToS3(File file, String userId) {
        return s3Service.uploadFile(file, userId);
    }

    public String sendDataToFastApi(String userId, List<String> s3Urls) {
        Map<String, Object> requestData = new HashMap<>();
        requestData.put("userId", userId);
        requestData.put("s3Urls", s3Urls); // 여러 URL 전송

        return webClient.post()
                .uri("/process-multiple") // FastAPI의 새로운 엔드포인트
                .bodyValue(requestData)
                .retrieve()
                .bodyToMono(String.class)
                .block();
    }
}
