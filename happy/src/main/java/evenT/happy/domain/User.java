package evenT.happy.domain;


import lombok.*;
import org.springframework.data.annotation.*;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Document(collection = "users")
@Getter @Setter
@AllArgsConstructor // pirvate 보고 생성자 만듬
@NoArgsConstructor // 기본 생성자 만듬
public class User {

    @Id
    private String id;  // MongoDB 기본 ID
    private String userName;
    private String password;
    private String gender;
    private String nickName;  // Java 필드 이름은 CamelCase로 유지
    private String userPicUrl;
    private int age;
    private String role;
    private List<String> select3Style;
    private List<String> roles = List.of("ROLE_USER", "ROLE_ADMIN");

    private List<Double> Preference; // 벡터 데이터 (리스트로 저장)

   // private List<Recommendation> RemainingRecommendations; // 남은 추천 데이터

    private String ClosetId; // 옷장 id

    //private List<UserSave> User_save; // 사용자가 저장한 데이터 > 저장한 거를 다른 곳에

    @CreatedDate
    private LocalDateTime CreatedDate;  // 생성 시간 자동 기록

    @LastModifiedDate
    private LocalDateTime LastModifiedDate;  // 수정 시간 자동 기록

    @CreatedBy
    private String CreatedBy;  // 생성자 자동 기록

    @LastModifiedBy
    private String LastModifiedBy;  // 수정자 자동 기록

}
