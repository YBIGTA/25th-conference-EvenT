package evenT.happy.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;

import java.util.ArrayList;
import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Getter @Setter
public class UserSignupDto {

    @Id
    private String userId;  // MongoDB 기본 ID
    private String password;
    private String gender;
    private String name;  // Java 필드 이름은 CamelCase로 유지
    private int age;
    private List<String> select3Styles;

}
