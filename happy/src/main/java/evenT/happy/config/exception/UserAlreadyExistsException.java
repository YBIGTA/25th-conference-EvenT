package evenT.happy.config.exception;

import evenT.happy.domain.User;

public class UserAlreadyExistsException extends RuntimeException {
    public UserAlreadyExistsException(String message){
        super(message);
    }
}
