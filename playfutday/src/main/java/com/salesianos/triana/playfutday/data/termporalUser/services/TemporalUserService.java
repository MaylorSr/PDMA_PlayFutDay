package com.salesianos.triana.playfutday.data.termporalUser.services;

import com.salesianos.triana.playfutday.data.files.service.StorageService;
import com.salesianos.triana.playfutday.data.termporalUser.model.TemporalUser;
import com.salesianos.triana.playfutday.data.termporalUser.repository.TemporalUserRepository;
import com.salesianos.triana.playfutday.data.user.dto.UserRequest;
import com.salesianos.triana.playfutday.exception.GlobalEntityNotFounException;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import javax.mail.internet.MimeMessage;
import java.io.File;
import java.util.Random;

@Service
@RequiredArgsConstructor
public class TemporalUserService {


    private final PasswordEncoder passwordEncoder;
    private final TemporalUserRepository temporalUserRepository;

    private final StorageService storageService;

    @Autowired
    JavaMailSender javaMailSender;

    @Value("${spring.mail.username}")
    private String email;

    /**
     * -Generar codigo aleatorio de verificación para crear la cuenta del usuario
     *
     * @return
     */
    public String generateCode() {
        int min = 100000;
        int max = 999999;
        Random random = new Random();
        int randomNumber = random.nextInt((max - min) + 1) + min;
        return Integer.toString(randomNumber);
    }


    public String SendCodeToEmail(UserRequest userRequest) {
        MimeMessage message = javaMailSender.createMimeMessage();
        TemporalUser userTemporal = temporalUserRepository.findByUsername(userRequest.getUsername());
        String code = generateCode();
        if (userTemporal != null) {
            userTemporal.setCode(code);
            temporalUserRepository.save(userTemporal);
        } else {
            temporalUserRepository.save(
                    TemporalUser.builder()
                            .username(userRequest.getUsername())
                            .email(userRequest.getEmail())
                            .phone(userRequest.getPhone())
                            .password(passwordEncoder.encode(userRequest.getPassword()))
                            .verifyPassword(passwordEncoder.encode(userRequest.getVerifyPassword()))
                            .code(code)
                            .build()
            );
        }

        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            File file = storageService.loadAsResource("logo_app-removebg.png").getFile();
            helper.setFrom(email);
            helper.setTo(userRequest.getEmail());
            helper.setSubject("-- VERIFY CODE --");
            // Cuerpo del mensaje para que no sea tan soso//
            String htmlMessage = String.format("<div style='background-color:#f5f5f5;padding:20px;font-family:Arial, sans-serif;'>" +
                    "<h2 style='color:#2d2d2d;text-align:center;margin-top:0;'>PlayFutDay Account Verification</h2>" +
                    "<p style='color:#2d2d2d;text-align:center;margin-bottom:40px;'>Hi, %s!</p>" +
                    "<p style='color:#2d2d2d;'>Thank you for signing up for PlayFutDay. Your verification code is:</p>" +
                    "<h1 style='color:#2d2d2d;text-align:center;margin-top:0;'>%s</h1>" +
                    "<p style='color:#2d2d2d;'>Please enter this code in the app to complete your account registration.</p>" +
                    "<p style='color:#2d2d2d;'>Thank you!</p>" +
                    "<div style='text-align:center;'>" +
                    "<img src='cid:logo' style='max-width:200px;margin-top:40px;'>" +
                    "</div>" +
                    "</div>", userRequest.getUsername(), code);
            helper.setText(htmlMessage, true);
            helper.addInline("logo", file);
            javaMailSender.send(message);

        } catch (Exception ex) {
            throw new GlobalEntityNotFounException("Please enter a correct email!");
        }
        return String.format("The code was send to email: %s. Please check your message email or spam folder.", userRequest.getEmail());
    }


    public UserRequest verifyCode(String code) {
        return temporalUserRepository.findByCode(code)
                .map(oldTemporalUser -> {
                    return UserRequest.builder()
                            .username(oldTemporalUser.getUsername())
                            .email(oldTemporalUser.getEmail())
                            .phone(oldTemporalUser.getPhone())
                            .password(oldTemporalUser.getPassword())
                            .verifyPassword(oldTemporalUser.getVerifyPassword())
                            .build();
                })
                .orElseThrow(() -> new GlobalEntityNotFounException("The code is invalid or any user have this code"));
    }

}
