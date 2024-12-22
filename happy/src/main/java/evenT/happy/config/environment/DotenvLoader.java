package evenT.happy.config.environment;

import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.context.annotation.Configuration;

@Configuration
public class DotenvLoader {
    static {
        String dotenvPath = System.getenv("DOTENV_PATH"); // Gradle에서 전달한 경로 읽기
        Dotenv dotenv = Dotenv.configure()
                .directory(dotenvPath != null ? dotenvPath : "./") // 루트 디렉토리 기본 설정
                .load();
        System.setProperty("AWS_ACCESS_KEY", dotenv.get("AWS_ACCESS_KEY"));
        System.setProperty("AWS_SECRET_KEY", dotenv.get("AWS_SECRET_KEY"));
//        System.setProperty("API_Key", dotenv.get("API_Key"));
//        System.setProperty("INDEX_URL", dotenv.get("INDEX_URL"));
    }
}