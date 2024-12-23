package evenT.happy.service.userComparison;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ComparisonResult {
    private String actionSaveS3Url; // 비교당하는 값의 s3Url
    private String comparisonS3Url; // 비교하는 값의 s3Url
}
