//package evenT.happy.service;
//
//import evenT.happy.repository.UserRepository;
//import lombok.RequiredArgsConstructor;
//import org.springframework.security.core.userdetails.User;
//import org.springframework.security.core.userdetails.UserDetails;
//import org.springframework.security.core.userdetails.UserDetailsService;
//import org.springframework.security.core.userdetails.UsernameNotFoundException;
//import org.springframework.stereotype.Service;
//
//@Service
//@RequiredArgsConstructor
//public class CustomUserDetailsService implements UserDetailsService {
//    private final UserRepository userRepository;
//
//    @Override
//    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
//        return userRepository.findByUserName(username)
//                .map(user -> User.builder()
//                        .username(user.getUserName())
//                        .password(user.getPassword())
//                        .roles(user.getRole()) // 사용자 역할 설정
//                        .build())
//                .orElseThrow(() -> new UsernameNotFoundException("User not found with username: " + username));
//    }
//}
