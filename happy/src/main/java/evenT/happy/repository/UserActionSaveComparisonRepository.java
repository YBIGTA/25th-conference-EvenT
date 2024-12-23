package evenT.happy.repository;

import evenT.happy.domain.user_action_save_comparison.UserActionSaveComparison;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface UserActionSaveComparisonRepository extends MongoRepository<UserActionSaveComparison, String> {
    boolean existsByUserIdAndClothesId(String userId, int clothesId);
    List<UserActionSaveComparison> findAllByUserId(String userId);


}
