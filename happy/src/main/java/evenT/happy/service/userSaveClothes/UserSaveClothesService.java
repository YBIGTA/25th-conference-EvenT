package evenT.happy.service.userSaveClothes;

import evenT.happy.domain.user_action_save_comparison.UserActionSaveComparison;
import evenT.happy.domain.sampleclothes.Category;
import evenT.happy.domain.sampleclothes.Subcategory;
import evenT.happy.domain.sampleclothes.Item;
import evenT.happy.domain.usersaveclothes.UserSaveClothes;
import evenT.happy.dto.userSaveClothesDto.*;
import evenT.happy.domain.sampleclothes.ClothesItem;

import evenT.happy.repository.SampleClothesRepository;
import evenT.happy.repository.UserActionSaveComparisonRepository;
import evenT.happy.repository.UserRepository;
import evenT.happy.repository.UserSaveClothesRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserSaveClothesService {

    private final UserSaveClothesRepository userSaveClothesRepository;
    private final SampleClothesRepository sampleClothesRepository;
    private final UserActionSaveComparisonRepository userActionSaveComparisonRepository;


    public void saveUserClothes(String userId, int clothesId) {
        // clothesId로 ClothesItem 조회
        ClothesItem clothesItem = sampleClothesRepository.findByClothesId(clothesId)
                .orElseThrow(() -> new IllegalArgumentException("ClothesItem not found for clothesId: " + clothesId));
        String fulls3url = clothesItem.getFulls3url(); // ClothesItem에서 fulls3url 가져옴
        List<Double> vector = List.of(0.1, 0.2, 0.3, 0.4); // 예시 벡터 값

        // 새 UserSaveClothes 객체 생성 및 저장
// 새 UserSaveClothes 객체 생성 및 저장
        UserSaveClothes userSaveClothes = new UserSaveClothes(
                userId,
                List.of(),
                fulls3url,
                vector
        );
        // 저장 (중복 허용)
        userSaveClothesRepository.save(userSaveClothes);

        // user_action_save_comparison에 저장
        for (Category category : clothesItem.getCloset()) {
            for (Subcategory subcategory : category.getSubcategories()) {
                for (Item item : subcategory.getItems()) {
                    UserActionSaveComparison comparisonItem = new UserActionSaveComparison(
                            userId,
                            clothesId,
                            clothesItem.getFulls3url(),
                            category.getCategoryName(),
                            subcategory.getName(),
                            item.getAttributes().getColor(),
                            item.getAttributes().getLength(),
                            item.getS3Url()
                    );

                    // 중복 저장 허용
                    userActionSaveComparisonRepository.save(comparisonItem);
                }
            }
        }
    }

    private void mergeCategories(ClothesItem clothesItem, List<Category> categories) {
        for (Category category : categories) {
            Optional<Category> existingCategory = clothesItem.getCloset().stream()
                    .filter(cat -> cat.getCategoryName().equals(category.getCategoryName()))
                    .findFirst();

            Category categoryToUpdate = existingCategory.orElseGet(() -> {
                Category newCategory = new Category(category.getCategoryName(), new ArrayList<>());
                clothesItem.getCloset().add(newCategory);
                return newCategory;
            });

            mergeSubcategories(categoryToUpdate, category.getSubcategories());
        }
    }

    private void mergeSubcategories(Category category, List<Subcategory> subcategories) {
        for (Subcategory subcategory : subcategories) {
            Optional<Subcategory> existingSubcategory = category.getSubcategories().stream()
                    .filter(sub -> sub.getName().equals(subcategory.getName()))
                    .findFirst();

            Subcategory subcategoryToUpdate = existingSubcategory.orElseGet(() -> {
                Subcategory newSubcategory = new Subcategory(subcategory.getName(), new ArrayList<>());
                category.getSubcategories().add(newSubcategory);
                return newSubcategory;
            });

            mergeItems(subcategoryToUpdate, subcategory.getItems());
        }
    }

    private void mergeItems(Subcategory subcategory, List<Item> items) {
        for (Item item : items) {
            Optional<Item> existingItem = subcategory.getItems().stream()
                    .filter(existing -> existing.getCustomName().equals(item.getCustomName())
                            && existing.getS3Url().equals(item.getS3Url()))
                    .findFirst();

            if (existingItem.isPresent()) {
                existingItem.get().setQuantity(existingItem.get().getQuantity() + item.getQuantity());
            } else {
                subcategory.getItems().add(item);
            }
        }
    }
    public List<String> getUserS3Urls(String userId) {
        List<UserSaveClothes> userSaveClothesList = userSaveClothesRepository.findAllByUserId(userId);

        // fulls3url 값 추출
        List<String> fulls3urlList = new ArrayList<>();
        for (UserSaveClothes userSaveClothes : userSaveClothesList) {
            if (userSaveClothes.getFulls3url() != null) { // null 체크
                fulls3urlList.add(userSaveClothes.getFulls3url());
            }
        }

        return fulls3urlList; // fulls3url 리스트 반환
    }
}
