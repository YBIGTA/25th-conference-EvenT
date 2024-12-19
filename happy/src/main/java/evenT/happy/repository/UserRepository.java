package evenT.happy.repository;

import evenT.happy.domain.User;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.Optional;

public interface UserRepository extends MongoRepository<User,String> {
    Optional<User> findByUserName(String userId);
    Optional<User> findByNickName(String nickname);
}
