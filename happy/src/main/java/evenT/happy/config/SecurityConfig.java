package evenT.happy.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@RequiredArgsConstructor
public class SecurityConfig {

    @Lazy
    private final JwtRequestFilter jwtRequestFilter;


    @Bean // 이 부분이 어떤 url 에서는 jwt 필요 없는지? 일단 무슨 코드 인지 봐야 할 듯
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http.csrf(AbstractHttpConfigurer::disable) // 최신 DSL 방식으로 CSRF 비활성화
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/users/login","/users/signup").permitAll() // 로그인은 인증 없이 허용
                        .anyRequest().authenticated() // 나머지는 인증 필요
                )
                .addFilterBefore(jwtRequestFilter, UsernamePasswordAuthenticationFilter.class); // JWT 필터 등록

        return http.build();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authenticationConfiguration) throws Exception {
        return authenticationConfiguration.getAuthenticationManager();
    }



    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

}
