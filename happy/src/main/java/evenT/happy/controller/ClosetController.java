package evenT.happy.controller;

import evenT.happy.domain.closet.ClosetItem;
import evenT.happy.dto.closetDto.ClosetRequestDto;
import evenT.happy.dto.closetDto.ClosetResponseDto;
import evenT.happy.dto.closetDto.UserDto.ClosetRequestByUserDto;
import evenT.happy.service.clothes.ClosetService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
public class ClosetController {

    private final ClosetService closetService;


    // 옷장 데이터 저장 API
    @PostMapping("simpledb/add")
    public ResponseEntity<String> saveCloset(@RequestBody ClosetRequestDto requestDto) {
        try {
            closetService.saveCloset(requestDto);
            return ResponseEntity.ok("Closet saved successfully!");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to save closet: " + e.getMessage());
        }
    }
    @PostMapping("/simpledb/get")
    public ClosetResponseDto getCloset(@RequestBody ClosetRequestDto requestDto) {
        return closetService.getClosetByRequest(requestDto);
    }
    
    @PutMapping("/simpledb/update")
    public void updateCloset1(@RequestBody ClosetRequestDto requestDto) {
        closetService.updateCloset(requestDto);
    }

}