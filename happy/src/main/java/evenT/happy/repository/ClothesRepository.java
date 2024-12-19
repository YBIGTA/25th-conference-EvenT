package evenT.happy.repository;

import evenT.happy.domain.Clothes;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface ClothesRepository extends MongoRepository<Clothes, String> {
}
