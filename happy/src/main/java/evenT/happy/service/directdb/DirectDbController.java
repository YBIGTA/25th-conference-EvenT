package evenT.happy.service.directdb;

import evenT.happy.config.exception.LoginFailedException;
import evenT.happy.domain.User;
import evenT.happy.repository.UserRepository;
import evenT.happy.service.fastapi.FastApiService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/directdb")
public class DirectDbController {
    private final DirectDbService directDbService;
    private final UserRepository userRepository;
    private final FastApiService fastApiService;

    // 파일 업로드
    @PostMapping("/upload/{userId}")
    public String uploadFile(
            @PathVariable("userId") String userId,
            @RequestParam("file") MultipartFile multipartFile) throws IOException {

        // MongoDB에서 userId로 사용자 조회
        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new LoginFailedException("사용자를 찾을 수 없습니다: " + userId));
        File file = convertMultiPartToFile(multipartFile); // 파일 변환
        String s3Url = directDbService.uploadFile(file, userId); // S3 업로드 후 URL 반환

        // FastAPI로 데이터 전송
        String fastApiResponse = fastApiService.sendDataToFastApi(userId, s3Url);

        return "S3 URL: " + s3Url + ", FastAPI Response: " + fastApiResponse;
    }
    // 파일 삭제
    @DeleteMapping("/delete/{userId}/{fileName}")
    public String deleteFile(@PathVariable String userId, @PathVariable String fileName) {
        directDbService.deleteFile(userId, fileName);
        return "File " + fileName + " deleted successfully for user " + userId;
    }

    // 파일 존재 여부 확인
    @GetMapping("/exists/{userId}/{fileName}")
    public boolean doesFileExist(@PathVariable String userId, @PathVariable String fileName) {
        return directDbService.doesFileExist(userId, fileName);
    }

    // 사용자 디렉토리의 파일 목록 가져오기
    @GetMapping("/list/{userId}")
    public List<String> listUserFiles(@PathVariable String userId) {
        return directDbService.listFiles(userId);
    }

    // MultipartFile을 File로 변환
    private File convertMultiPartToFile(MultipartFile file) throws IOException {
        File convFile = new File(file.getOriginalFilename());
        try (FileOutputStream fos = new FileOutputStream(convFile)) {
            fos.write(file.getBytes());
        }
        return convFile;
    }
}
