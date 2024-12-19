package evenT.happy.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;

import java.util.ArrayList;
import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Getter
public class UserSignupDto {

    @Id
    private String id;  // MongoDB 기본 ID
    private String userName;
    private String password;
    private String gender;
    private String nickName;  // Java 필드 이름은 CamelCase로 유지
    private String userPicUrl;
    private int age;
    private List<String> select3Style;

}
