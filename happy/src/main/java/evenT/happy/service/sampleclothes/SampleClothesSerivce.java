package evenT.happy.service.sampleclothes;

import evenT.happy.domain.Clothes;
import evenT.happy.domain.sampleclothes.Category;
import evenT.happy.domain.closet.ClosetItem;
import evenT.happy.domain.sampleclothes.Item;
import evenT.happy.domain.sampleclothes.Subcategory;
import evenT.happy.domain.sampleclothes.ClothesItem;
import evenT.happy.domain.user_action_save_comparison.UserActionSaveComparison;
import evenT.happy.dto.closetDto.ClosetRequestDto;
import evenT.happy.dto.clothesDto.ItemDto;
import evenT.happy.dto.clothesDto.CategoryDto;
import evenT.happy.dto.clothesDto.ClothesRequestDto;
import evenT.happy.dto.clothesDto.SubcategoryDto;
import evenT.happy.repository.SampleClothesRepository;
import evenT.happy.repository.UserActionSaveComparisonRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class SampleClothesSerivce {
    private final SampleClothesRepository sampleClothesRepository;
    private final UserActionSaveComparisonRepository userActionSaveComparisonRepository;


    public void saveCloset(ClothesRequestDto requestDto) {
        // Retrieve or create ClothesItem
        ClothesItem clothesItem = sampleClothesRepository.findByClothesId(requestDto.getClothesId())
                .orElse(new ClothesItem(requestDto.getClothesId(), new ArrayList<>()));

        // Set fulls3url and other fields at the ClothesItem level
        clothesItem.setClothesId(requestDto.getClothesId());
        clothesItem.setFulls3url(requestDto.getFulls3url());
        clothesItem.setVector(requestDto.getVector());

        // Add categories and subcategories
        for (CategoryDto categoryDto : requestDto.getCategories()) {
            Optional<Category> existingCategory = clothesItem.getCloset().stream()
                    .filter(category -> category.getCategoryName().equals(categoryDto.getCategoryName()))
                    .findFirst();

            Category category = existingCategory.orElseGet(() -> {
                Category newCategory = new Category();
                newCategory.setCategoryName(categoryDto.getCategoryName());
                newCategory.setSubcategories(new ArrayList<>());
                clothesItem.getCloset().add(newCategory);
                return newCategory;
            });

            for (SubcategoryDto subcategoryDto : categoryDto.getSubcategories()) {
                Optional<Subcategory> existingSubcategory = category.getSubcategories().stream()
                        .filter(sub -> sub.getName().equals(subcategoryDto.getName()))
                        .findFirst();

                Subcategory subcategory = existingSubcategory.orElseGet(() -> {
                    Subcategory newSubcategory = new Subcategory();
                    newSubcategory.setName(subcategoryDto.getName());
                    newSubcategory.setItems(new ArrayList<>());
                    category.getSubcategories().add(newSubcategory);
                    return newSubcategory;
                });

                for (ItemDto itemDto : subcategoryDto.getItems()) {
                    Optional<Item> existingItem = subcategory.getItems().stream()
                            .filter(item -> item.getAttributes().equals(itemDto.getAttributes())
                                    && item.getCustomName().equals(itemDto.getCustomName())
                                    && item.getS3Url().equals(itemDto.getS3Url()))
                            .findFirst();

                    if (existingItem.isPresent()) {
                        Item item = existingItem.get();
                        item.setQuantity(item.getQuantity() + itemDto.getQuantity());
                    } else {
                        Item newItem = new Item();
                        newItem.setAttributes(itemDto.getAttributes());
                        newItem.setCustomName(itemDto.getCustomName());
                        newItem.setS3Url(itemDto.getS3Url());
                        newItem.setQuantity(itemDto.getQuantity());
                        newItem.setStatus(itemDto.getStatus());
                        newItem.setVector(itemDto.getVector());
                        subcategory.getItems().add(newItem);
                    }

                    // Save comparison data
                    UserActionSaveComparison comparisonItem = new UserActionSaveComparison(
                            requestDto.getUserId(),
                            requestDto.getClothesId(),
                            requestDto.getFulls3url(),
                            categoryDto.getCategoryName(),
                            subcategoryDto.getName(),
                            itemDto.getAttributes().getColor(),
                            itemDto.getAttributes().getLength(),
                            itemDto.getS3Url()
                    );

                    userActionSaveComparisonRepository.save(comparisonItem);
                }
            }
        }

        // Save updated ClothesItem
        sampleClothesRepository.save(clothesItem);
    }}
