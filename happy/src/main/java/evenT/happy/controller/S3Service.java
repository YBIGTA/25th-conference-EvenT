//package evenT.happy.controller;
//
//import com.amazonaws.services.s3.AmazonS3;
//import com.amazonaws.services.s3.model.ObjectMetadata;
//import com.amazonaws.services.s3.model.PutObjectRequest;
//import com.amazonaws.services.s3.model.S3Object;
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.stereotype.Service;
//import org.springframework.web.multipart.MultipartFile;
//
//import java.io.File;
//import java.io.IOException;
//import java.io.InputStream;
//
//@Service
//public class S3Service {
//
//    private final AmazonS3 amazonS3;
//
//    @Value("${cloud.aws.s3.bucket}")
//    private String bucketName;
//
//    public S3Service(AmazonS3 amazonS3) {
//        this.amazonS3 = amazonS3;
//    }
//
////    public void uploadFile(String key, File file) {
////
////        amazonS3.putObject(bucketName, key, file);
////        System.out.println("Uploaded Key: " + key); // 업로드된 Key 출력
////
////    }
//    public String uploadFile(MultipartFile file, String key) throws IOException {
//        ObjectMetadata metadata = new ObjectMetadata();
//        metadata.setContentLength(file.getSize());
//        metadata.setContentType(file.getContentType());
//
//        amazonS3.putObject(
//                new PutObjectRequest(bucketName, key, file.getInputStream(), metadata)
//        );
//
//        // 업로드된 파일의 URL 반환
//        return amazonS3.getUrl(bucketName, key).toString();
//    }
//    public InputStream downloadFile(String key) {
//        S3Object s3Object = amazonS3.getObject(bucketName, key);
//        return s3Object.getObjectContent(); // InputStream 반환
//    }
//
//    // public S3Object downloadFile(String key) {
//    //   return amazonS3.getObject(bucketName, key);
//}
