package evenT.happy.repository;

import evenT.happy.domain.User;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface TestRepository  extends MongoRepository <User, String> {
}
