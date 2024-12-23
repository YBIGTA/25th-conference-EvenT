package evenT.happy.service.aws;

import com.fasterxml.jackson.databind.ObjectMapper;
import evenT.happy.config.exception.LoginFailedException;
import evenT.happy.domain.User;
import evenT.happy.repository.UserRepository;
import evenT.happy.service.fastapi.FastApiService;
import evenT.happy.service.fastapi.TestService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/s3")
public class S3Controller {
    private final S3Service s3Service;
    private final UserRepository userRepository;
    private final FastApiService fastApiService;
    private final TestService testService;


    // 파일 업로드
    @PostMapping("/upload1/{userId}")
    public String uploadFile(
            @PathVariable("userId") String userId,
            @RequestParam("file") MultipartFile multipartFile) throws IOException {

        // MongoDB에서 userId로 사용자 조회
        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new LoginFailedException("사용자를 찾을 수 없습니다: " + userId));
        File file = convertMultiPartToFile(multipartFile); // 파일 변환
        String s3Url = s3Service.uploadFile(file, userId); // S3 업로드 후 URL 반환
        String fulls3url = s3Service.fulluploadFile(file, userId);

        // FastAPI로 데이터 전송
        String fastApiResponse = fastApiService.sendDataToFastApi(userId, s3Url ,fulls3url);

        return "S3 URL: " + s3Url + ", FastAPI Response: " + fastApiResponse;
    }

    // 파일 삭제
    @DeleteMapping("/delete/{userId}/{fileName}")
    public String deleteFile(@PathVariable String userId, @PathVariable String fileName) {
        s3Service.deleteFile(userId, fileName);
        return "File " + fileName + " deleted successfully for user " + userId;
    }

    // 파일 존재 여부 확인
    @GetMapping("/exists/{userId}/{fileName}")
    public boolean doesFileExist(@PathVariable String userId, @PathVariable String fileName) {
        return s3Service.doesFileExist(userId, fileName);
    }

    // 사용자 디렉토리의 파일 목록 가져오기
    @GetMapping("/list/{userId}")
    public List<String> listUserFiles(@PathVariable String userId) {
        return s3Service.listFiles(userId);
    }

    // MultipartFile을 File로 변환
    private File convertMultiPartToFile(MultipartFile file) throws IOException {
        File convFile = new File(file.getOriginalFilename());
        try (FileOutputStream fos = new FileOutputStream(convFile)) {
            fos.write(file.getBytes());
        }
        return convFile;
    }
    @PostMapping("/upload/test/{userId}")
    public String uploadTestFiles(
            @PathVariable("userId") String userId,
            @RequestParam("files") List<MultipartFile> multipartFiles) throws IOException {

        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new LoginFailedException("사용자를 찾을 수 없습니다: " + userId));

        List<String> s3Urls = new ArrayList<>();
        for (MultipartFile multipartFile : multipartFiles) {
            File file = testService.convertMultiPartToFile(multipartFile); // 파일 변환
            String s3Url = testService.uploadFileToS3(file, userId); // S3 업로드 후 URL 반환
            s3Urls.add(s3Url); // S3 URL 리스트에 추가
        }

        // FastAPI로 데이터 전송
        String fastApiResponse = testService.sendDataToFastApi(userId, s3Urls);

        return fastApiResponse;
     //   "S3 URLs: " + s3Urls + ", FastAPI Response: " + fastApiResponse;
    }
    @PostMapping("/upload/{userId}")
    public ResponseEntity<Map<String, Object>> uploadFile1(
            @PathVariable("userId") String userId,
            @RequestParam("file") MultipartFile multipartFile) throws IOException {

        // 사용자 조회 및 예외 처리
        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new LoginFailedException("사용자를 찾을 수 없습니다: " + userId));

        // 파일 변환 및 S3 업로드
        File file = convertMultiPartToFile(multipartFile);
        String s3Url = s3Service.uploadFile(file, userId);
        String fulls3url = s3Service.fulluploadFile(file, userId);

        // FastAPI로 데이터 전송 및 JSON 응답 받기
        String fastApiResponse = fastApiService.sendDataToFastApi(userId, s3Url, fulls3url);

        // FastAPI 응답을 JSON 객체로 변환
        ObjectMapper objectMapper = new ObjectMapper();
        Map<String, Object> responseJson = objectMapper.readValue(fastApiResponse, Map.class);

        // "categories" 처리 및 status, fulls3url, vector 값 업데이트
        List<Map<String, Object>> categories = (List<Map<String, Object>>) responseJson.get("categories");
        if (categories != null) {
            categories.forEach(category -> {
                List<Map<String, Object>> subcategories = (List<Map<String, Object>>) category.get("subcategories");
                if (subcategories != null) {
                    subcategories.forEach(subcategory -> {
                        List<Map<String, Object>> items = (List<Map<String, Object>>) subcategory.get("items");
                        if (items != null) {
                            items.forEach(item -> {
                                item.put("status", 2); // status 값을 2로 고정
                                item.put("fulls3url", fulls3url); // fulls3url 추가
                                item.put("vector", List.of(0.1, 0.2, 0.3, 0.4)); // vector 추가
                            });
                        }
                    });
                }
            });
        }

        // fulls3url을 최상위 레벨에서도 추가
        responseJson.put("fulls3url", fulls3url);

        // 최종 JSON 응답 반환
        return ResponseEntity.ok(responseJson);
    }

    @PostMapping("/upload2/{userId}")
    public String uploadFile2(
            @PathVariable("userId") String userId,
            @RequestParam("file") MultipartFile multipartFile) throws IOException {

        // MongoDB에서 userId로 사용자 조회
        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new LoginFailedException("사용자를 찾을 수 없습니다: " + userId));

        // MultipartFile -> File 변환
        File file = convertMultiPartToFile(multipartFile);

        // S3 업로드 및 URL 생성
        String s3Url = s3Service.uploadFile(file, userId);
        String fullS3Url = s3Service.fulluploadFile(file, userId);

        // FastAPI로 데이터 전송
        String fastApiResponse;
        try {
            fastApiResponse = fastApiService.sendDataToFastApi(userId, s3Url, fullS3Url);
        } catch (Exception e) {
            throw new RuntimeException("FastAPI와 통신 중 문제가 발생했습니다: " + e.getMessage());
        }

        // 결과 반환
        return String.format("S3 URL: %s, Full S3 URL: %s, FastAPI Response: %s", s3Url, fullS3Url, fastApiResponse);
    }


}
