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

        // FastAPI로 데이터 전송
        String fastApiResponse = fastApiService.sendDataToFastApi(userId, s3Url);

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

        return "S3 URLs: " + s3Urls + ", FastAPI Response: " + fastApiResponse;
    }

    @PostMapping("/upload/{userId}")
    public ResponseEntity<Map<String, Object>> uploadFile1(
            @PathVariable("userId") String userId,
            @RequestParam("file") MultipartFile multipartFile) throws IOException {

        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new LoginFailedException("사용자를 찾을 수 없습니다: " + userId));

        File file = convertMultiPartToFile(multipartFile);
        String s3Url = s3Service.uploadFile(file, userId);

        // FastAPI로 데이터 전송 및 JSON 응답 받기
        String fastApiResponse = fastApiService.sendDataToFastApi(userId, s3Url);

        // FastAPI 응답을 JSON 객체로 변환
        ObjectMapper objectMapper = new ObjectMapper();
        Map<String, Object> responseJson = objectMapper.readValue(fastApiResponse, Map.class);

        // "closet" 내부의 모든 "items"의 status 값을 2로 설정
        List<Map<String, Object>> closet = (List<Map<String, Object>>) responseJson.get("closet");
        if (closet != null) {
            for (Map<String, Object> category : closet) {
                List<Map<String, Object>> subcategories = (List<Map<String, Object>>) category.get("subcategories");
                if (subcategories != null) {
                    for (Map<String, Object> subcategory : subcategories) {
                        List<Map<String, Object>> items = (List<Map<String, Object>>) subcategory.get("items");
                        if (items != null) {
                            for (Map<String, Object> item : items) {
                                item.put("status", 2); // status 값을 2로 고정
                            }
                        }
                    }
                }
            }
        }

        // 최종 JSON 응답 반환
        return ResponseEntity.ok(responseJson);
    }

}