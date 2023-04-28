package com.salesianos.triana.playfutday.security.refresh;

import com.salesianos.triana.playfutday.data.user.model.User;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.time.Instant;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class RefreshTokenService {
    private final RefreshTokenRepository repo;

    @Value("${jwt.refresh.duration}")
    private int durationInMinutes;


    public Optional<RefreshToken> findByToken(String token) {
        return repo.findByToken(token);
    }

    @Transactional
    public int deleteByUser(User user) {
        return repo.deleteByUser(user);
    }

    /**
     * METHOD CREATE REFRESH TOKEN OF USER
     */

    public RefreshToken createRefreshToken(User user) {
        RefreshToken refreshToken = RefreshToken.builder()
                .user(user)
                /**GENERA UN RANDOM UUID, SE PASA A STRING AL GAURDARLO EN STRING **/
                .token(UUID.randomUUID().toString())
                .expiryDate(Instant.now().plusSeconds(durationInMinutes * 60))
                .build();
        return repo.save(refreshToken);
    }


    public RefreshToken verifyRefreshToken(RefreshToken refreshToken) {

        if (refreshToken.getExpiryDate().compareTo(Instant.now()) < 0) {
            // el token de refresco a caducado ya que es menor que 0
            repo.delete(refreshToken);
            throw new RefreshTokenException("The refresh token has expired");
        }
        /**NOS HACE QUE LA API VAYA MUCHO MÁS FLUIDA**/
        return refreshToken;
    }

}
