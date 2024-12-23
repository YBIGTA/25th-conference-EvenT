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
        // userId로 UserSaveClothes 조회 또는 생성
        UserSaveClothes userSaveClothes = userSaveClothesRepository.findByUserId(userId)
                .orElse(new UserSaveClothes(userId, new ArrayList<>()));

        // clothesId로 ClothesItem 조회
        evenT.happy.domain.sampleclothes.ClothesItem clothesItem = sampleClothesRepository.findByClothesId(clothesId)
                .orElseThrow(() -> new IllegalArgumentException("ClothesItem not found for clothesId: " + clothesId));

        // 중복 여부 확인 후 추가
        boolean isAlreadyAdded = userSaveClothes.getUserSaveCloset().stream()
                .anyMatch(item -> item.getClothesId() == clothesId);

        if (!isAlreadyAdded) {
            userSaveClothes.getUserSaveCloset().add(clothesItem);
        }
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
                            item.getAttributes().getPrint(),
                            item.getS3Url()
                    );

                    // 저장
                    userActionSaveComparisonRepository.save(comparisonItem);
                }
            }
        }

        // 저장
        userSaveClothesRepository.save(userSaveClothes);
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
}
