//package evenT.happy.controller;
//import org.springframework.http.HttpHeaders;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//import org.springframework.web.multipart.MultipartFile;
//
//import java.io.*;
//
//@RestController
//@RequestMapping("/api/s3")
//public class S3Controller {
//
//    private final S3Service s3Service;
//
//    public S3Controller(S3Service s3Service) {
//        this.s3Service = s3Service;
//    }
//
////    @PostMapping("/upload")
////    public ResponseEntity<String> uploadFile(@RequestParam("file") MultipartFile file) {
////        try {
////            File tempFile = convertMultiPartToFile(file);
////            s3Service.uploadFile(file.getOriginalFilename(), tempFile);
////            return ResponseEntity.ok("File uploaded successfully");
////        } catch (IOException e) {
////            return ResponseEntity.internalServerError().body("File upload failed");
////        }
////    }
//
////    @GetMapping("/download/{key}")
////    public ResponseEntity<String> downloadFile(@PathVariable String key) {
////        try {
////            s3Service.downloadFile(key);
////            return ResponseEntity.ok("File downloaded successfully");
////        } catch (Exception e) {
////            return ResponseEntity.internalServerError().body("File download failed");
////        }
////    }
//    @GetMapping("/download/{key}")
//    public ResponseEntity<byte[]> downloadFile(@PathVariable("key") String key) {
//        try (InputStream inputStream = s3Service.downloadFile(key);
//             ByteArrayOutputStream outputStream = new ByteArrayOutputStream()) {
//
//            byte[] buffer = new byte[1024];
//            int bytesRead;
//
//            while ((bytesRead = inputStream.read(buffer)) != -1) {
//                outputStream.write(buffer, 0, bytesRead); //읽은 데이터만큼 출력 스트림에 저장
//            }
//
//            byte[] fileContent = outputStream.toByteArray(); // 저장된 데이터를 바이트 배열로 변환
//
//            return ResponseEntity.ok()
//                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + key + "\"")
//                    .header(HttpHeaders.CONTENT_TYPE, "image/jpeg")  // Content-Type 설정
//                    .body(fileContent); //파일 데이터를 응답으로 보냄
//        } catch (IOException e) {
//            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
//                    .body(("File download failed: " + e.getMessage()).getBytes());
//        }
//    }
//
////    @DeleteMapping("/delete/{key}")
////    public ResponseEntity<String> deleteFile(@PathVariable String key) {
////        try {
////            s3Service.deleteFile(key);
////            return ResponseEntity.ok("File deleted successfully");
////        } catch (Exception e) {
////            return ResponseEntity.internalServerError().body("File deletion failed");
////        }
////    }
//
//    private File convertMultiPartToFile(MultipartFile file) throws IOException {
//        File convertedFile = new File(file.getOriginalFilename());
//        try (FileOutputStream fos = new FileOutputStream(convertedFile)) {
//            fos.write(file.getBytes());
//        }
//        return convertedFile;
//    }
//}
