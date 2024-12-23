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

        // 새 UserSaveClothes 객체 생성 및 저장
        UserSaveClothes userSaveClothes = new UserSaveClothes(userId, List.of(clothesItem));

        // 저장 (중복 허용)
        userSaveClothesRepository.save(userSaveClothes);

        // user_action_save_comparison에 저장
        for (Category category : clothesItem.getCloset()) {
            for (Subcategory subcategory : category.getSubcategories()) {
                for (Item item : subcategory.getItems()) {
                    UserActionSaveComparison comparisonItem = new UserActionSaveComparison(
                            userId,
                            clothesId,
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

        List<String> s3Urls = new ArrayList<>();
        for (UserSaveClothes userSaveClothes : userSaveClothesList) {
            for (ClothesItem clothesItem : userSaveClothes.getUserSaveCloset()) {
                for (Category category : clothesItem.getCloset()) {
                    for (Subcategory subcategory : category.getSubcategories()) {
                        for (Item item : subcategory.getItems()) {
                            s3Urls.add(item.getS3Url()); // s3Url 추출
                        }
                    }
                }
            }
        }

        return s3Urls;
    }
}
