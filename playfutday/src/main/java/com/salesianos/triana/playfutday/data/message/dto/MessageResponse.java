@Data
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public MessageResponse {

    /**ID DEL MENSAJE */
    protected Long id;

    // protected Long idChat;

    protected String usernameWhoSendMessage;

    protected String avatarWhoSendMessage;

    protected String bodyMessage;

    // protected UUID idUserWhoSendMessage;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy HH:mm")
    protected LocalDateTime timeWhoSendMessage

    public static MessageResponse(Message message){
        return MessageResponse.builder()
                .id(message.id)
                // .idChat()   
                .usernameWhoSendMessage(message.username)
                .avatarWhoSendMessage(message.avatar)
                .bodyMessage(message.body)
                // .idUserWhoSendMessage(message.idUser)
        
        .build();
    }
}