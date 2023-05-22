@Entity
@Table(name = "chat_entity")
@EntityListeners(AuditingEntityListener.class)
@Data
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
public class Chat implements Serializable{

    @Id
    @GeneratedValue()
    private Long id;

    //**A CONFIGURAR MÁS TARDE DEPENDIENDO DE LA POLÍTICA DE BORRADO DESEADA */ @ManyToMany(fetch = FetchType.LAZY, cascade = CascadeType.PERSIST)
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "chat_members",
            joinColumns = @JoinColumn(name = "chat_id"),
            inverseJoinColumns = @JoinColumn(name = "user_id")
    )
    @Builder.Default
    /**CREO QUE DEBE SER LIST NO HASHSET, YA QUE AL BORRAR LA CUENTA DEL USUARIO, LOS MENSAJES DE ESTE EL USUARIO NO APARECERÁ Y SE PONDRÁ EN NULL */
    private HashSet<User> members;
 
    //** A CONFIGURAR MÁS TARDE DEPENDIENDO DE LA POLÍTICA DE BORRADO DESEADA */ @OneToMany(mappedBy = "chat", cascade = CascadeType.ALL, orphanRemoval = true)
    // @Order ORDENAMOS DIRECTAMENTE LA LISTA DE LOS ULTIMOS MENSAJES ENVIADOS
    @OnetToMany(mappedBy="chat")
    @Builder.Default
    private List<Messages> messages;
    
    /**ORDENAR LOS CHATS DE LOS ÚLTIMOS CREADOS */
    @CreatedDate
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy HH:mm:ss")
    private LocalDateTime createdChat = LocalDateTime.now();




}