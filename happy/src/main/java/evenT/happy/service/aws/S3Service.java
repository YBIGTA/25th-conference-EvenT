package evenT.happy.service.aws;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.nio.file.Path;
import java.util.List;
import java.util.stream.Collectors;

import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.*;

@Service
@RequiredArgsConstructor
public class S3Service {

    private final S3Client s3Client;

    @Value("${aws.s3.bucket}")
    private String bucketName;

    @Value("${aws.region.static}")
    private String region;

    public String uploadFile(File file, String userId) {
        // 파일 경로 생성
        String fileName = file.getName();
        String filePath = "users/directdb_pic/" + userId + "/" + fileName; // 경로 형식

        // S3에 파일 업로드
        s3Client.putObject(PutObjectRequest.builder()
                        .bucket(bucketName)
                        .key(filePath)
                        .build(),
                Path.of(file.getPath()));

        // 업로드된 파일의 URL 반환
        return "https://" + bucketName + ".s3." + region + ".amazonaws.com/" + filePath;
    }
    public String fulluploadFile(File file, String userId) {
        // 파일 경로 생성
        String fileName = file.getName();
        String filePath = "users/directdb_pic/" + userId + "/" + fileName; // 경로 형식

        // S3에 파일 업로드
        s3Client.putObject(PutObjectRequest.builder()
                        .bucket(bucketName)
                        .key(filePath)
                        .build(),
                Path.of(file.getPath()));

        // 업로드된 파일의 URL 반환
        return "https://" + bucketName + ".s3." + region + ".amazonaws.com/" + filePath;
    }


    public void deleteFile(String userId, String fileName) {
        // 파일 경로 생성
        String filePath = "users/directdb_pic/" + userId + "/" + fileName;

        // S3에서 파일 삭제
        s3Client.deleteObject(DeleteObjectRequest.builder()
                .bucket(bucketName)
                .key(filePath)
                .build());
    }
    public boolean doesFileExist(String userId, String fileName) {
        String filePath = "users/directdb_pic/" + userId + "/" + fileName;
        try {
            s3Client.headObject(HeadObjectRequest.builder()
                    .bucket(bucketName)
                    .key(filePath)
                    .build());
            return true; // 파일 존재
        } catch (S3Exception e) {
            if (e.statusCode() == 404) {
                return false; // 파일 없음
            }
            throw e; // 기타 예외는 다시 던짐
        }
    }
    public List<String> listFiles(String userId) {
        String prefix = "users/directdb_pic/" + userId + "/";
        ListObjectsV2Request request = ListObjectsV2Request.builder()
                .bucket(bucketName)
                .prefix(prefix)
                .build();

        ListObjectsV2Response response = s3Client.listObjectsV2(request);
        return response.contents().stream()
                .map(S3Object::key) // 파일 경로 반환
                .collect(Collectors.toList());
    }
}
