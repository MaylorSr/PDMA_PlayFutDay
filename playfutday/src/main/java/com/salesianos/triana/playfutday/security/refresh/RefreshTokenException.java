package com.salesianos.triana.playfutday.security.refresh;

import com.salesianos.triana.playfutday.security.errorhandling.JwtTokenException;

public class RefreshTokenException extends JwtTokenException {

    public RefreshTokenException(String msg) {
        super(msg);
    }
}
