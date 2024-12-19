package evenT.happy;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.mongodb.config.EnableMongoAuditing;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;

@EnableMongoRepositories
@SpringBootApplication
@EnableMongoAuditing
public class HappyApplication {

	public static void main(String[] args) {
		SpringApplication.run(HappyApplication.class, args);
	}

}
