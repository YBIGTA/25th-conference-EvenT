package evenT.happy.config.exception;



public class LoginFailedException extends RuntimeException{
    public LoginFailedException(String message) {
        super(message); // RuntimeException의 생성자를 호출
    }
}
