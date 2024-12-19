package evenT.happy.config;

import org.springframework.data.domain.AuditorAware;
import org.springframework.stereotype.Component;

import java.util.Optional;
import java.util.UUID;

@Component
public class MongoAuditorAware implements AuditorAware<String> {

    @Override
    public Optional<String> getCurrentAuditor(){
        return Optional.of(UUID.randomUUID().toString());
    }
}
