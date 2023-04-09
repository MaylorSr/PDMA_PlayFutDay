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
        /**
         * NO LANZAMOS EXCEPCIÓN POR LA LÓGICA, EN CASO DE ENCONTRARSE, SETEA EL CODIGO PARA ASÍ NO ALMACENAR UNO NUEVO
         * YA QUE NUNCA DEBE DE HABER DOS USUARIOS CON TODO IGUAL AL NO TENER VALIDACIÓN, SOLO SIRVE PARA PODER REENVIAR EL
         * CODIGO DE VERIFICACIÓN, EN CASO DE NO EXISTIR LO GUARDA EN LA BD.
         */
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


        /**
         * PARA ENVIAR EL CORREO JUNTO CON EL CODIGO
         */

        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            File file = storageService.loadAsResource("logo_app.png").getFile();
            helper.setFrom(email);
            helper.setTo(userRequest.getEmail());
            helper.setSubject("-- VERIFY CODE --");
            helper.setText(String.format("Hi! %s, your code for creating your account in PlayFutDay is: %s", userRequest.getUsername(), code));
            helper.addAttachment("PlayFutDay", file);
            javaMailSender.send(message);

        } catch (Exception ex) {
            throw new GlobalEntityNotFounException("Please enter a correct email!");
        }
        return String.format("The code was send to email: %s, please review your email or spam email.", userRequest.getEmail());
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
