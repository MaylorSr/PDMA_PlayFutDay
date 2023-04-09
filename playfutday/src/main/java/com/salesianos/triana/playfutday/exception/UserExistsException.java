package com.salesianos.triana.playfutday.exception;

public class UserExistsException extends RuntimeException {

    public UserExistsException(String content) {
        super(String.format(content));
    }


}
