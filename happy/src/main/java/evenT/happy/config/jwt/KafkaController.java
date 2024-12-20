package evenT.happy.config.jwt;

import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/kafka")
public class KafkaController {
    private final KafkaTemplate<String, Object> kafkaTemplate;

    public KafkaController(KafkaTemplate<String, Object> kafkaTemplate) {
        this.kafkaTemplate = kafkaTemplate;
    }

    @PostMapping("/send")
    public String sendStringMessage(@RequestParam String key, @RequestBody String message) {
        kafkaTemplate.send("example-topic", key, message); // String 메시지 전송
        return "String message sent to Kafka with key: " + key;
    }

    @PostMapping("/sendObject")
    public String sendObjectMessage(@RequestParam String key, @RequestBody Object message) {
        kafkaTemplate.send("example-topic", key, message); // Object 메시지 전송
        return "Object message sent to Kafka with key: " + key;
    }
}
