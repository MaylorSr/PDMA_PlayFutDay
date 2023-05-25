package com.salesianos.triana.playfutday.data.message.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.salesianos.triana.playfutday.data.chat.model.Chat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.UUID;


@Entity
@Table(name = "message_entity")
@Data
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
@EntityListeners(AuditingEntityListener.class)
public class Message implements Serializable {

    @Id
    @GeneratedValue()
    private Long id; //id del mensaje

    private UUID idUser;

    private String avatar;

    private String username;

    private String body; //cuerpo del mensaje

    @CreatedDate
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy HH:mm:ss")
    private LocalDateTime createdMessage = LocalDateTime.now();

    @ManyToOne
    @JoinColumn(name = "chat_id")
    private Chat chat;

}