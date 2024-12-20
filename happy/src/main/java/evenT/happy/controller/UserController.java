package evenT.happy.controller;

import evenT.happy.config.JwtUtil;
import evenT.happy.domain.User;
import evenT.happy.dto.LoginDto;
import evenT.happy.dto.UserSignupDto;
import evenT.happy.repository.UserRepository;
import evenT.happy.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
public class UserController {
    private final UserRepository userRepository;
    private final UserService userService;
    private final AuthenticationManager authenticationManager;
    private final JwtUtil jwtUtil;


  //  @PostMapping("/signup")
   // public ResponseEntity<?> signup(@RequestBody UserSignupDto userSignupDto) {
     //   String token = userService.SignUp(userSignupDto);
       // return ResponseEntity.ok(Map.of("token", token));
    //}
  @PostMapping("/signup")
  public ResponseEntity<Map<String, Object>> signup(@RequestBody UserSignupDto userSignupDto) {
      String token = userService.SignUp(userSignupDto);

      Map<String, Object> response = new HashMap<>();
      response.put("status", HttpStatus.OK.value());
      response.put("message", "회원가입 성공");
      response.put("token", token);

      return ResponseEntity.ok(response);
  }


    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody LoginDto loginDto) {
        String token = userService.login(loginDto);
        Map<String, Object> response = new HashMap<>();
        response.put("status", HttpStatus.OK.value());
        response.put("message", "로그인 성공");
        response.put("token", token);

        return ResponseEntity.ok(response);
    }


//    @PostMapping("/{userId}/upload-pic")
//    public ResponseEntity<String> uploadUserPic(
//            @PathVariable("userId") String userId,
//            @RequestParam("file") MultipartFile file) {
//
//        try {
//            String key = "user_pic/" + userId + "/" + file.getOriginalFilename();  // S3 저장 경로
//            String fileUrl = s3Service.uploadFile(file, key);  // S3에 파일 업로드 후 URL 반환
//
//            // MongoDB에서 사용자 엔티티 업데이트
//            User user = userRepository.findById(userId)
//                    .orElseThrow(() -> new RuntimeException("User not found"));
//            user.setUserPicUrl(fileUrl);
//            userRepository.save(user);
//
//            return ResponseEntity.ok("Image uploaded and URL saved: " + fileUrl);
//        } catch (Exception e) {
//            return ResponseEntity.internalServerError()
//                    .body("Failed to upload image: " + e.getMessage());
//        }
//    }
    @GetMapping("/{userId}/pic")
    public ResponseEntity<String> getUserPic(@PathVariable("userId")String userId) {
        return userRepository.findById(userId)
                .map(user -> ResponseEntity.ok(user.getUserPicUrl()))  // 이미지 URL 반환
                .orElse(ResponseEntity.notFound().build());  // 사용자 없으면 404 반환
    }
}
