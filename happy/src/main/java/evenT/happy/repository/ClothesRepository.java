package evenT.happy.repository;

import evenT.happy.domain.sampleclothes.ClothesItem;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.Optional;

public interface ClothesRepository extends MongoRepository<ClothesItem,String > {
    Optional<ClothesItem> findByClothesId(int clothesId);

}
