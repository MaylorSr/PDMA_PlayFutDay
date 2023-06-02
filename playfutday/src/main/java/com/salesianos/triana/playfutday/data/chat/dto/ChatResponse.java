package com.salesianos.triana.playfutday.data.chat.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.salesianos.triana.playfutday.data.chat.model.Chat;
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
public class ChatResponse {
    /**
     * ID DEL CHAT PARA IR A LA PANTALLA DE TODOS LOS MENSAJES DE ESE CHAT (find all messages by id chat)
     */
    private Long id;

    /**
     * EL DESTINITY HACE REFERENCIA A LOS USUARIOS DESTINATARIOS
     */
    private String avatarUserDestinity;

    private String usernameUserDestinity;

    private String lastMessage; // ÚLTIMO MENSAJE ENVIADO O RECIBIDO

    private UUID idUserDestiny;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy HH:mm:ss")
    private LocalDateTime createdChat = LocalDateTime.now();



    // /**ULTIMO MENSAJE ENVIADO EN EL CHAT, DA IGUAL EL REMITENTE */
    // private String lastMessage;

    /**
     * SERVIRÁ PARA MARCAR EL CHAT COMO QUE TIENE MENSAJES SIN ABRIR
     */
//     private bool isReaded;
    public static ChatResponse of(Chat chat, String username, String avatar, String message, UUID idUserDestiny) {
        return ChatResponse.builder()
                .id(chat.getId())
                /**AVERIGUAR COMO SE LE PASARÁ EL USUARIO DESTINATARIO */
                .avatarUserDestinity(avatar)
                .usernameUserDestinity(username)
                .lastMessage(message)
                .idUserDestiny(idUserDestiny)
                .createdChat(chat.getCreatedChat())
                .build();
    }


}