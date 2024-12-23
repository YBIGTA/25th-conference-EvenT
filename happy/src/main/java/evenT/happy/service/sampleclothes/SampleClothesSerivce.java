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
        // MongoDB에서 clothesId로 ClothesItem 조회 또는 생성
        ClothesItem clothesItem = sampleClothesRepository.findByClothesId(requestDto.getClothesId())
                .orElse(new ClothesItem(requestDto.getClothesId(), new ArrayList<>()));

        // 각 카테고리별로 데이터 추가
        for (CategoryDto categoryDto : requestDto.getCategories()) {
            Optional<evenT.happy.domain.sampleclothes.Category> existingCategory = clothesItem.getCloset().stream()
                    .filter(category -> category.getCategoryName().equals(categoryDto.getCategoryName()))
                    .findFirst();

            Category category = existingCategory.orElseGet(() -> {
                Category newCategory = new Category();
                newCategory.setCategoryName(categoryDto.getCategoryName());
                newCategory.setSubcategories(new ArrayList<>()); // 초기화
                clothesItem.getCloset().add(newCategory);
                return newCategory;
            });

            // 서브카테고리 병합
            for (SubcategoryDto subcategoryDto : categoryDto.getSubcategories()) {
                Optional<Subcategory> existingSubcategory = category.getSubcategories().stream()
                        .filter(sub -> sub.getName().equals(subcategoryDto.getName()))
                        .findFirst();

                Subcategory subcategory = existingSubcategory.orElseGet(() -> {
                    Subcategory newSubcategory = new Subcategory();
                    newSubcategory.setName(subcategoryDto.getName());
                    newSubcategory.setItems(new ArrayList<>()); // 초기화
                    category.getSubcategories().add(newSubcategory);
                    return newSubcategory;
                });

                // items 병합
                for (ItemDto itemDto : subcategoryDto.getItems()) {
                    Optional<Item> existingItem = subcategory.getItems().stream()
                            .filter(item -> item.getAttributes().equals(itemDto.getAttributes())
                                    && item.getCustomName().equals(itemDto.getCustomName())
                                    && item.getS3Url().equals(itemDto.getS3Url()))

                            .findFirst();

                    if (existingItem.isPresent()) {
                        // 기존 item의 수량 업데이트
                        Item item = existingItem.get();
                        item.setQuantity(item.getQuantity() + itemDto.getQuantity());
                    } else {
                        // 새 item 추가
                        Item newItem = new Item();
                        newItem.setAttributes(itemDto.getAttributes());
                        newItem.setCustomName(itemDto.getCustomName());
                        newItem.setS3Url(itemDto.getS3Url());
                        newItem.setQuantity(itemDto.getQuantity());
                        newItem.setStatus(itemDto.getStatus());
                        newItem.setVector(itemDto.getVector());
                        subcategory.getItems().add(newItem);
                    }
                    // 추출된 데이터를 user_action_save_comparison에 저장
                    UserActionSaveComparison comparisonItem = new UserActionSaveComparison(
                            requestDto.getUserId(),                // userId 추가
                            requestDto.getClothesId(),             // clothesId (int 타입 그대로 전달)
                            categoryDto.getCategoryName(),             // categoryName
                            subcategoryDto.getName(),                  // name
                            itemDto.getAttributes().getColor(),        // color
                            itemDto.getAttributes().getLength(),        // print
                            itemDto.getS3Url()                         // s3Url
                    );

                    userActionSaveComparisonRepository.save(comparisonItem);
                }
            }
        }

        // MongoDB 저장
        sampleClothesRepository.save(clothesItem);
    }
}
