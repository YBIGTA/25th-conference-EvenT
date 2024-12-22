package evenT.happy.repository;

import evenT.happy.domain.closet.ClosetItem;
import evenT.happy.domain.sampleclothes.ClothesItem;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

import java.util.Optional;

public interface SampleClothesRepository extends MongoRepository<ClothesItem,String> {

    Optional<ClothesItem> findByClothesId(int clothesId);
}
