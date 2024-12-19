package evenT.happy.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "clothes")
@AllArgsConstructor
@NoArgsConstructor
@Data
public class Clothes {

    @Id
    private String id;
    private String style;
    private String gender;
    private String s3Url;
    private int vectorId;
}
