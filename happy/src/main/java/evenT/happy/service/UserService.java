package evenT.happy.service;
import evenT.happy.config.JwtUtil;
import evenT.happy.config.exception.LoginFailedException;
import evenT.happy.config.exception.UserAlreadyExistsException;
import evenT.happy.service.que.RecommendedItem;
import evenT.happy.domain.User;
import evenT.happy.dto.LoginDto;
import evenT.happy.dto.UserSignupDto;
import evenT.happy.repository.UserRepository;
import evenT.happy.service.pinecone.PineconeService;
import evenT.happy.service.que.RecommendationQueue;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

import java.util.List;
import java.util.Optional;
import java.util.Queue;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

@Service
@Transactional
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;
    private final RecommendationQueue recommendationQueue;
    public Optional<User> findByUserId(String userId){
        return userRepository.findByUserId(userId);
    }

    public String SignUp(UserSignupDto userSignupDto){
        if (userRepository.findByUserId(userSignupDto.getUserId()).isPresent()){
            throw new UserAlreadyExistsException("이미 있는 ID 입니다");
        }
        if (userRepository.findByName(userSignupDto.getUserId()).isPresent()){
            throw new UserAlreadyExistsException("이미 있는 닉네임 입니다");
        }
        User user = new User();
        user.setRoles(List.of("ROLE_USER")); // 기본 권한
       // admin.setRoles(List.of("ROLE_USER", "ROLE_ADMIN")); // 관리자 권한 포함

        user.setUserId(userSignupDto.getUserId());
        user.setPassword(passwordEncoder.encode(userSignupDto.getPassword())); // 비밀번호 해싱
        user.setGender(userSignupDto.getGender());
        user.setName(userSignupDto.getName());
        user.setAge(userSignupDto.getAge());
        user.setSelect3Styles(userSignupDto.getSelect3Styles());
        // Preference 벡터 생성 및 저장
        List<Double> preferenceVector = calculatePreferenceVector(userSignupDto.getSelect3Styles());
        user.setPreference(preferenceVector);
        userRepository.save(user);




        // JWT 생성
        String token = jwtUtil.generateToken(user.getUserId(), user.getRoles());

// SecurityContext에 인증 정보 저장
        UsernamePasswordAuthenticationToken authentication =
                new UsernamePasswordAuthenticationToken(
                        user.getUserId(), // principal: 사용자 식별자 (userName)
                        null,               // credentials: 인증 이후 필요하지 않으므로 null
                        user.getRoles().stream() // 권한 정보 변환
                                .map(SimpleGrantedAuthority::new) // String -> SimpleGrantedAuthority
                                .collect(Collectors.toList())
                );
        SecurityContextHolder.getContext().setAuthentication(authentication);

// 클라이언트에 JWT 반환
        return token;


    }


    public String login(LoginDto loginDto) {
        // 사용자 조회
        User user = userRepository.findByUserId(loginDto.getUserId())
                .orElseThrow(() -> new LoginFailedException("사용자를 찾을 수 없습니다."));

        // 비밀번호 검증
        if (!passwordEncoder.matches(loginDto.getPassword(), user.getPassword())) {
            throw new LoginFailedException("비밀번호가 일치하지 않습니다.");
        }

        // JWT 생성
        String token = jwtUtil.generateToken(user.getUserId(), user.getRoles());

        // SecurityContext에 인증 정보 저장
        UsernamePasswordAuthenticationToken authentication =
                new UsernamePasswordAuthenticationToken(
                        user.getUserId(), // principal
                        null, // credentials
                        user.getRoles().stream()
                                .map(SimpleGrantedAuthority::new) // 권한 변환
                                .collect(Collectors.toList())
                );
        SecurityContextHolder.getContext().setAuthentication(authentication);

        // JWT 반환
        return token;
    }
    private List<Double> calculatePreferenceVector(List<String> select3Styles) {
        // Pinecone용 벡터 값 생성 로직
        return select3Styles.stream()
                .map(style -> style.hashCode() % 1000 / 1000.0) // float -> double로 변경
                .collect(Collectors.toList());
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public Optional<User> getUserById(String id) {
        return userRepository.findById(id);
    }
    public void addRecommendationForUser(String userId, RecommendedItem item) {
        recommendationQueue.addRecommendation(userId, item);
        System.out.println("Added recommendation for user " + userId + ": " + item);
    }

    public RecommendedItem consumeRecommendationForUser(String userId) {
        RecommendedItem item = recommendationQueue.consumeRecommendation(userId);
        if (item != null) {
            System.out.println("Consumed recommendation for user " + userId + ": " + item);
        } else {
            System.out.println("No recommendations available for user " + userId);
        }
        return item;
    }

    public Queue<RecommendedItem> getRecommendationsForUser(String userId) {
        return recommendationQueue.getRecommendations(userId);
    }
    public void updateUserPreference(String userId) {
        Optional<User> optionalUser = userRepository.findByUserId(userId);

        if (optionalUser.isPresent()) {
            User user = optionalUser.get();

            // Preference 값 업데이트 (예: 0.1씩 더하기)
            List<Double> preferences = user.getPreference();
            for (int i = 0; i < preferences.size(); i++) {
                preferences.set(i, preferences.get(i) + 0.1);
            }

            user.setPreference(preferences);
            userRepository.save(user);

            System.out.println("Updated preferences for userId " + userId + ": " + preferences);
        } else {
            System.out.println("User not found with userId: " + userId);
        }
    }

//    public User updateUser(String id, User updatedUser) {
//        return userRepository.findById(id)
//                .map(user -> {
//                    user.setName(updatedUser.getName());
//                    user.setAge(updatedUser.getAge());
//                    return userRepository.save(user);
//                })
//                .orElseThrow(() -> new RuntimeException("User not found"));
//    }
//    public void deleteUser(String id) {
//        userRepository.deleteById(id);
//    }


}