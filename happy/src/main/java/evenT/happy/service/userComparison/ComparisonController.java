package evenT.happy.service.userComparison;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
public class ComparisonController {

    private final ComparisonService comparisonService;
    // userId로 데이터 비교
    @GetMapping("/compare/user/matched")
    public ResponseEntity<Map<String, List<String>>> compareUserClothes(@RequestParam(name = "userId") String userId) {
        Map<String, List<String>> groupedMatches = comparisonService.compareAndGroupMatches(userId);
        return ResponseEntity.ok(groupedMatches);
    }
    @GetMapping("/compare/user/unmatched")
    public ResponseEntity<Map<String, List<String>>> compareUnmatchedUserClothes(
            @RequestParam(name = "userId") String userId) {
        Map<String, List<String>> unmatchedResults = comparisonService.findUnmatchedComparisons(userId);
        return ResponseEntity.ok(unmatchedResults);
    }

}
