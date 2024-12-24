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
            // 비교당하는 값의 첫 번째 fulls3url 사용
            String actionSaveFulls3Url = actionSave.getFulls3url(); // fulls3url 사용
            if (actionSaveFulls3Url == null) continue; // fulls3url이 null인 경우 건너뛰기

            List<String> matchingComparisonUrls = new ArrayList<>();
            for (UserClothesComparison comparison : userClothesComparisons) {
                if (Objects.equals(actionSave.getCategoryName(), comparison.getCategoryName()) &&
                        Objects.equals(actionSave.getName(), comparison.getName()) &&
                        Objects.equals(actionSave.getColor(), comparison.getColor()) &&
                        Objects.equals(actionSave.getLength(), comparison.getLength())) {

                    if (comparison.getS3Url() != null) {
                        matchingComparisonUrls.add(comparison.getS3Url()); // 비교하는 값의 s3Url 추가
                    }
                }
            }

            // 빈 배열이 아닌 경우만 추가
            if (!matchingComparisonUrls.isEmpty()) {
                groupedMatches.put(actionSaveFulls3Url, matchingComparisonUrls); // fulls3url을 키로 사용
            }
        }

        return groupedMatches; // 그룹화된 결과 반환
    }
    public Map<String, List<String>> findUnmatchedComparisons(String userId) {
        // 두 컬렉션에서 userId로 데이터 가져오기
        List<UserActionSaveComparison> userActionSaves = userActionSaveRepository.findAllByUserId(userId);
        List<UserClothesComparison> userClothesComparisons = userClothesComparisonRepository.findAllByUserId(userId);

        Map<String, List<String>> unmatchedResults = new HashMap<>();

        for (UserClothesComparison comparison : userClothesComparisons) {
            String comparisonS3Url = comparison.getS3Url(); // 비교하는 값의 s3Url
            if (comparisonS3Url == null) continue; // s3Url이 null인 경우 건너뛰기

            boolean isMatched = false;

            for (UserActionSaveComparison actionSave : userActionSaves) {
                if (Objects.equals(actionSave.getCategoryName(), comparison.getCategoryName()) &&
                        Objects.equals(actionSave.getName(), comparison.getName()) &&
                        Objects.equals(actionSave.getColor(), comparison.getColor()) &&
                        Objects.equals(actionSave.getLength(), comparison.getLength())) {
                    isMatched = true; // 매칭 성공
                    break;
                }
            }

            // 매칭되지 않은 경우 fulls3url을 키로, s3Url을 값으로 추가
            if (!isMatched) {
                String fulls3Url = comparison.getFulls3url(); // 비교 대상 값의 fulls3url
                unmatchedResults.computeIfAbsent(fulls3Url, k -> new ArrayList<>()).add(comparisonS3Url);
            }
        }

        return unmatchedResults; // 매칭되지 않은 결과 반환
    }
}
