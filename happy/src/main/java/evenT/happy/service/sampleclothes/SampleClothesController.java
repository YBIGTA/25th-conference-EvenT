package evenT.happy.service.sampleclothes;

import evenT.happy.dto.clothesDto.ClothesRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/sampleclothes")
public class SampleClothesController {
    private final SampleClothesSerivce sampleClothesSerivce;

    @PostMapping("/add")
    public String addClothes(@RequestBody ClothesRequestDto requestDto) {
        sampleClothesSerivce.saveCloset(requestDto);
        return "Clothes Item Added Successfully";
    }
}
