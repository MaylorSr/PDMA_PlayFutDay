package com.salesianos.triana.playfutday.data.message.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.salesianos.triana.playfutday.data.message.model.Message;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class MessageResponse {

    /**
     * ID DEL MENSAJE
     */
    protected Long id;

    // protected Long idChat;


    /***
     * ID DEL USUARIO QUE ENVÍA EL MENSAJE
     */
    protected String idUserWhoSendMessage;

    protected String usernameWhoSendMessage;

    protected String avatarWhoSendMessage;

    protected String bodyMessage;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy HH:mm")
    protected LocalDateTime timeWhoSendMessage;

    public static MessageResponse of(Message message) {
        return MessageResponse.builder()
                .id(message.getId())
                // .idChat() // DE MOMENTO NO HACE FALTA
                .idUserWhoSendMessage(message.getIdUser() == null ? "" : message.getIdUser()) // ID DEL USUARIO QUE ENVÍA EL MENSAJE PARA PODER NAVEGAR A LA PANTALLA DE DICHO USUARIO
                .usernameWhoSendMessage(message.getUsername() == null ? "Unknown" : message.getUsername())
                .avatarWhoSendMessage(message.getAvatar() == null ? "avatar.jpg" : message.getAvatar())
                .bodyMessage(message.getBody())
                .timeWhoSendMessage(message.getCreatedMessage())
                .build();
    }


}