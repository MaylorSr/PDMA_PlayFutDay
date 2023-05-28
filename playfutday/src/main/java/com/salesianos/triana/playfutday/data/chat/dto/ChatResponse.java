package com.salesianos.triana.playfutday.data.chat.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.salesianos.triana.playfutday.data.chat.model.Chat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

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

    // /**ULTIMO MENSAJE ENVIADO EN EL CHAT, DA IGUAL EL REMITENTE */
    // private String lastMessage;

    /**
     * SERVIRÁ PARA MARCAR EL CHAT COMO QUE TIENE MENSAJES SIN ABRIR
     */
//     private bool isReaded;
    public static ChatResponse of(Chat chat, String username, String avatar, String message) {
        return ChatResponse.builder()
                .id(chat.getId())
                /**AVERIGUAR COMO SE LE PASARÁ EL USUARIO DESTINATARIO */
                .avatarUserDestinity(avatar)
                .usernameUserDestinity(username)
                .lastMessage(message)
                .build();
    }


}