package evenT.happy.service.userSaveClothes;

import evenT.happy.dto.userSaveClothesDto.UserSaveClothesRequestDto;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class UserSaveClothesController {
    private final UserSaveClothesService userSaveClothesService;

    public UserSaveClothesController(UserSaveClothesService userSaveClothesService) {
        this.userSaveClothesService = userSaveClothesService;
    }

    @PostMapping("/pinecone/action/save")
    public ResponseEntity<String> saveUserClothes(@RequestBody Map<String, Object> requestBody) {
        // requestBody에서 userId와 clothesId 추출
        String userId = (String) requestBody.get("userId");
        int clothesId = (int) requestBody.get("clothesId");

        // 서비스 호출
        userSaveClothesService.saveUserClothes(userId, clothesId);

        return ResponseEntity.ok("Clothes added successfully for user: " + userId);
    }

}