package evenT.happy.repository;

import evenT.happy.domain.userClothesComparsion.UserClothesComparison;
import evenT.happy.domain.user_action_save_comparison.UserActionSaveComparison;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface UserClothesComparisonRepository extends MongoRepository <UserClothesComparison, String>{
    List<UserClothesComparison> findAllByUserId(String userId);

}
