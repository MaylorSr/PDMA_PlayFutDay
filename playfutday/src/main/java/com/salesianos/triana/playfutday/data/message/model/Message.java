public class Message implements Serializable{

    @id
    @GenerateValue()
    private Long id;

    private UUID idUser;
    
    private String avatar;

    private String username;
     
    private String body;


    @CreatedDate
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy HH:mm:ss")
    private LocalDateTime createdMessage = LocalDateTime.now();


}