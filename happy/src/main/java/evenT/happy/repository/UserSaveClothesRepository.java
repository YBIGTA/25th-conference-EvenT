package evenT.happy.repository;

import evenT.happy.domain.usersaveclothes.UserSaveClothes;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.Optional;

public interface UserSaveClothesRepository extends MongoRepository <UserSaveClothes,String>{
    Optional<UserSaveClothes> findByUserId(String userId);

}
