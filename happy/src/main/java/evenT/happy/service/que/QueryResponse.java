package evenT.happy.service.que;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class QueryResponse {

    private List<Match> matches;

    // Getters and Setters

    public List<Match> getMatches() {
        return matches;
    }

    public void setMatches(List<Match> matches) {
        this.matches = matches;
    }
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Match {
        private String id;
        private Double score;
        private Map<String, Object> metadata;

    }
}

