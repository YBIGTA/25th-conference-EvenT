package evenT.happy.service.userComparison;

import evenT.happy.domain.userClothesComparsion.UserClothesComparison;
import evenT.happy.domain.user_action_save_comparison.UserActionSaveComparison;
import evenT.happy.repository.UserActionSaveComparisonRepository;
import evenT.happy.repository.UserClothesComparisonRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class ComparisonService {

    private final UserActionSaveComparisonRepository userActionSaveRepository;
    private final UserClothesComparisonRepository userClothesComparisonRepository;



    // user_action_save와 user_clothes_comparison 데이터를 비교
    public Map<String, List<String>> compareAndGroupMatches(String userId) {
        // 두 컬렉션에서 userId로 데이터 가져오기
        List<UserActionSaveComparison> userActionSaves = userActionSaveRepository.findAllByUserId(userId);
        List<UserClothesComparison> userClothesComparisons = userClothesComparisonRepository.findAllByUserId(userId);

        Map<String, List<String>> groupedMatches = new HashMap<>();

        for (UserActionSaveComparison actionSave : userActionSaves) {
            // 비교당하는 값의 첫 번째 s3Url만 사용
            String actionSaveS3Url = actionSave.getS3Url();
            if (actionSaveS3Url == null) continue; // s3Url이 null인 경우 건너뛰기

            List<String> matchingComparisonUrls = new ArrayList<>();
            for (UserClothesComparison comparison : userClothesComparisons) {
                if (Objects.equals(actionSave.getCategoryName(), comparison.getCategoryName()) &&
                        Objects.equals(actionSave.getName(), comparison.getName()) &&
                        Objects.equals(actionSave.getColor(), comparison.getColor()) &&
                        Objects.equals(actionSave.getLength(), comparison.getLength())) {

                    if (comparison.getS3Url() != null) {
                        matchingComparisonUrls.add(comparison.getS3Url());
                    }
                    // 비교하는 값의 s3Url 추가
                    matchingComparisonUrls.add(comparison.getS3Url());
                }
            }
            // 빈 배열이 아닌 경우만 추가

            if (!matchingComparisonUrls.isEmpty()) {
                groupedMatches.put(actionSaveS3Url, matchingComparisonUrls);
            }
        }

        return groupedMatches; // 그룹화된 결과 반환
    }
}
