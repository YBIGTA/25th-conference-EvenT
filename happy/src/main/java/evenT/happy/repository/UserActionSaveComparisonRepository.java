package evenT.happy.repository;

import evenT.happy.domain.user_action_save_comparison.UserActionSaveComparison;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface UserActionSaveComparisonRepository extends MongoRepository<UserActionSaveComparison, String> {
}
