package com.salesianos.triana.playfutday.data.files.exception;

import org.springframework.http.HttpStatus;

public class StorageException extends RuntimeException{

    public StorageException(String msg) {
        super(msg);
    }

    public StorageException(String msg, Exception e) {
        super(msg, e);
    }
}