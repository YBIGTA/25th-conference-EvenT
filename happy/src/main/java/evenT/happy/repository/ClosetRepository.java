package evenT.happy.repository;

import evenT.happy.domain.closet.ClosetItem;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

import java.util.Optional;

public interface ClosetRepository extends MongoRepository<ClosetItem, String> {
    @Query("{ 'userId' : ?0 }")
    Optional<ClosetItem> findByUserId(String userId);
}
