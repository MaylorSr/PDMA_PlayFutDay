
@Data
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class ChatResponse{
    /**ID DEL CHAT PARA IR A LA PANTALLA DE TODOS LOS MENSAJES DE ESE CHAT (find all messages by id chat) */
    private Long idChat;
    
    /**EL DESTINITY HACE REFERENCIA A LOS USUARIOS DESTINATARIOS */
    private String avatarUserDestinity;

    private String usernameUserDestinity;

    private String lastMessage;

    // /**ULTIMO MENSAJE ENVIADO EN EL CHAT, DA IGUAL EL REMITENTE */
    // private String lastMessage;

    /**SERVIRÁ PARA MARCAR EL CHAT COMO QUE TIENE MENSAJES SIN ABRIR */
    // private bool isReaded;

    // public static ChatResponse of(Chat chat){
    //     return ChatResponse.builder()
    //             .id(chat.id)
    //             /**AVERIGUAR COMO SE LE PASARÁ EL USUARIO DESTINATARIO */
    //             .avatarUserDestinity(null)

    //             .usernameUserDestinity(null)
    //     .build();
    // }






}