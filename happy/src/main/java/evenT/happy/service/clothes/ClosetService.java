package evenT.happy.service.clothes;

import evenT.happy.domain.closet.Category;
import evenT.happy.domain.closet.ClosetItem;
import evenT.happy.domain.closet.Item;
import evenT.happy.domain.closet.Subcategory;
import evenT.happy.domain.userClothesComparsion.UserClothesComparison;
import evenT.happy.dto.closetDto.*;
import evenT.happy.repository.ClosetRepository;
import evenT.happy.repository.UserClothesComparisonRepository;
import evenT.happy.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ClosetService {
    private final ClosetRepository closetRepository;
    private final UserRepository userRepository;
    private final UserClothesComparisonRepository userClothesComparisonRepository;

    // SimpleDbDto를 ClosetItem으로 변환 후 저장

    // 간접 db로 들어올 떄 이런식으로 들어오면 됨
    public void saveCloset(ClosetRequestDto requestDto) {
        // MongoDB에서 userId로 ClosetItem 조회 또는 생성
        ClosetItem closetItem = closetRepository.findByUserId(requestDto.getUserId())
                .orElse(new ClosetItem(requestDto.getUserId(), new ArrayList<>()));

        // userId 레벨의 fulls3url과 vector 추가
        closetItem.setFulls3url(requestDto.getFulls3url());
        closetItem.setVector(requestDto.getVector());

        // 이후 로직은 동일
        for (CategoryDto categoryDto : requestDto.getCategories()) {
            Optional<Category> existingCategory = closetItem.getCloset().stream()
                    .filter(category -> category.getCategoryName().equals(categoryDto.getCategoryName()))
                    .findFirst();

            Category category = existingCategory.orElseGet(() -> {
                Category newCategory = new Category();
                newCategory.setCategoryName(categoryDto.getCategoryName());
                newCategory.setSubcategories(new ArrayList<>());
                closetItem.getCloset().add(newCategory);
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
                        subcategory.getItems().add(newItem);
                    }

                    UserClothesComparison comparisonItem = new UserClothesComparison(
                            requestDto.getUserId(),
                            categoryDto.getCategoryName(),
                            subcategoryDto.getName(),
                            itemDto.getAttributes().getColor(),
                            itemDto.getAttributes().getLength(),
                            itemDto.getS3Url()
                    );

                    userClothesComparisonRepository.save(comparisonItem);
                }
            }
        }

        closetRepository.save(closetItem);
    }
    // 사용자 ID로 옷장 조회
    public ClosetResponseDto getClosetByRequest(ClosetRequestDto requestDto) {
        ClosetItem closetItem = closetRepository.findByUserId(requestDto.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("해당 User ID의 옷장이 없습니다."));

        return convertToResponseDto(closetItem);
    }

    private ClosetResponseDto convertToResponseDto(ClosetItem closetItem) {
        ClosetResponseDto responseDto = new ClosetResponseDto();
        responseDto.setUserId(closetItem.getUserId());
        responseDto.setCategories(closetItem.getCloset().stream()
                .map(category -> {
                    CategoryResponseDto categoryDto = new CategoryResponseDto();
                    categoryDto.setCategoryName(category.getCategoryName());
                    categoryDto.setSubcategories(category.getSubcategories());
                    return categoryDto;
                })
                .collect(Collectors.toList()));
        return responseDto;
    }

    @Transactional
    public void updateCloset(ClosetRequestDto requestDto) {
        // 기존 데이터 가져오기
        ClosetItem closetItem = closetRepository.findByUserId(requestDto.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("해당 User ID의 옷장이 없습니다."));

        try {
            // 기존 데이터를 모두 초기화 (초기화는 이후 새로운 데이터를 추가하기 전에 진행)
            List<Category> updatedCategories = new ArrayList<>();

            // 요청 데이터 처리
            for (CategoryDto categoryDto : requestDto.getCategories()) {
                // 새로운 카테고리 생성
                Category newCategory = new Category();
                newCategory.setCategoryName(categoryDto.getCategoryName());
                newCategory.setSubcategories(new ArrayList<>());

                for (SubcategoryDto subcategoryDto : categoryDto.getSubcategories()) {
                    // 새로운 서브카테고리 생성
                    Subcategory newSubcategory = new Subcategory();
                    newSubcategory.setName(subcategoryDto.getName());
                    newSubcategory.setItems(new ArrayList<>());

                    for (ItemDto itemDto : subcategoryDto.getItems()) {
                        // 새로운 아이템 생성
                        Item newItem = new Item();
                        newItem.setCustomName(itemDto.getCustomName());
                        newItem.setAttributes(itemDto.getAttributes());
                        newItem.setS3Url(itemDto.getS3Url());
                        newItem.setQuantity(itemDto.getQuantity());
                        newItem.setStatus(itemDto.getStatus());

                        newSubcategory.getItems().add(newItem);
                    }
                    newCategory.getSubcategories().add(newSubcategory);
                }
                updatedCategories.add(newCategory);
            }

            // 새로운 데이터로 카테고리를 교체
            closetItem.setCloset(updatedCategories);

            // 저장
            closetRepository.save(closetItem);

        } catch (Exception e) {
            // 예외 발생 시 트랜잭션 롤백
            throw new RuntimeException("업데이트 중 오류가 발생했습니다: " + e.getMessage(), e);
        }
    }

}


