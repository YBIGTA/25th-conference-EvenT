package evenT.happy.controller;


import evenT.happy.domain.Clothes;
import evenT.happy.repository.ClothesRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/clothes")
public class ClothesController {

    private final ClothesRepository clothesRepository;


    // URL 데이터를 저장하는 엔드포인트
    @PostMapping
    public ResponseEntity<Clothes> saveClothes(@RequestBody Clothes clothes) {
        Clothes savedClothes = clothesRepository.save(clothes);
        return ResponseEntity.ok(savedClothes);
    }

    // 모든 Clothes 데이터를 조회하는 엔드포인트
    @GetMapping
    public ResponseEntity<List<Clothes>> getAllClothes() {
        return ResponseEntity.ok(clothesRepository.findAll());
    }
}
