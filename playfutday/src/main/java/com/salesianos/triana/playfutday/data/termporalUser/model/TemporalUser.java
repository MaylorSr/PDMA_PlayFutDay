package com.salesianos.triana.playfutday.data.termporalUser.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;

@Entity

@Table(name = "temporal_user_entity")
@EntityListeners(AuditingEntityListener.class)
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TemporalUser {
    @Id
    @GeneratedValue
    private Long id;

    /**
     * Como no """podemos""" / buena practica tener de atributo un DTO, ponemos sus atributos para almacenarlos de manera temporal.
     */
    private String username;

    private String email;

    private String phone;

    private String password;

    private String verifyPassword;

    private String code;


}
