package evenT.happy.repository;

import evenT.happy.domain.userClothesComparsion.UserClothesComparison;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface UserClothesComparisonRepository extends MongoRepository <UserClothesComparison, String>{

}
