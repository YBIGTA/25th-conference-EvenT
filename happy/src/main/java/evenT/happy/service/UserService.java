package evenT.happy.service;
import evenT.happy.config.JwtUtil;
import evenT.happy.domain.User;
import evenT.happy.dto.LoginDto;
import evenT.happy.dto.UserSignupDto;
import evenT.happy.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    public Optional<User> findByUserId(String userId){
        return userRepository.findByUserName(userId);
    }

    public String SignUp(UserSignupDto userSignupDto){
        if (userRepository.findByUserName(userSignupDto.getUserName()).isPresent()){
            throw new RuntimeException("이미 있는 ID 입니다");
        }
        if (userRepository.findByNickName(userSignupDto.getNickName()).isPresent()){
            throw new RuntimeException("이미 있는 닉네임 입니다");
        }
        User user = new User();
        user.setRoles(List.of("ROLE_USER")); // 기본 권한
       // admin.setRoles(List.of("ROLE_USER", "ROLE_ADMIN")); // 관리자 권한 포함

        user.setUserName(userSignupDto.getUserName());
        user.setPassword(passwordEncoder.encode(userSignupDto.getPassword())); // 비밀번호 해싱
        user.setGender(userSignupDto.getGender());
        user.setNickName(userSignupDto.getNickName());
        user.setUserPicUrl(userSignupDto.getUserPicUrl());
        user.setAge(userSignupDto.getAge());
        user.setSelect3Style(userSignupDto.getSelect3Style());
        userRepository.save(user);
        // JWT 생성
        String token = jwtUtil.generateToken(user.getUserName(), user.getRoles());

// SecurityContext에 인증 정보 저장
        UsernamePasswordAuthenticationToken authentication =
                new UsernamePasswordAuthenticationToken(
                        user.getUserName(), // principal: 사용자 식별자 (userName)
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
        User user = userRepository.findByUserName(loginDto.getUserName())
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));

        // 비밀번호 검증
        if (!passwordEncoder.matches(loginDto.getPassword(), user.getPassword())) {
            throw new RuntimeException("비밀번호가 일치하지 않습니다.");
        }

        // JWT 생성
        String token = jwtUtil.generateToken(user.getUserName(), user.getRoles());

        // SecurityContext에 인증 정보 저장
        UsernamePasswordAuthenticationToken authentication =
                new UsernamePasswordAuthenticationToken(
                        user.getUserName(), // principal
                        null, // credentials
                        user.getRoles().stream()
                                .map(SimpleGrantedAuthority::new) // 권한 변환
                                .collect(Collectors.toList())
                );
        SecurityContextHolder.getContext().setAuthentication(authentication);

        // JWT 반환
        return token;
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public Optional<User> getUserById(String id) {
        return userRepository.findById(id);
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
