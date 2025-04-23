package local.kafka.demo;

import org.apache.kafka.clients.consumer.Consumer;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.Duration;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/kafka")
public class KafkaController {

    @Autowired
    private KafkaConfig kafkaConfig;

    @Value("${kafka.topic}")
    private String topic;

    @PostMapping("/produce")
    public ResponseEntity<String> produce(@RequestBody Map<String, String> request) {
        try (Producer<String, String> producer = kafkaConfig.producer()) {
            String key = request.getOrDefault("key", null);
            String value = request.get("message");

            ProducerRecord<String, String> record = new ProducerRecord<>(topic, key, value);
            producer.send(record);
            return ResponseEntity.ok("Message sent successfully.");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error: " + e.getMessage());
        }
    }

    @GetMapping("/consume")
    public ResponseEntity<List<String>> consume() {
        List<String> messages = new ArrayList<>();
        try (Consumer<String, String> consumer = kafkaConfig.consumer("rest-api-group")) {
            consumer.subscribe(Collections.singletonList(topic));
            ConsumerRecords<String, String> records = consumer.poll(Duration.ofSeconds(20));
            for (ConsumerRecord<String, String> record : records) {
                messages.add(record.value());
            }
        } catch (Exception e) {
            return ResponseEntity.status(500).body(Collections.singletonList("Error: " + e.getMessage()));
        }
        return ResponseEntity.ok(messages);
    }
}
