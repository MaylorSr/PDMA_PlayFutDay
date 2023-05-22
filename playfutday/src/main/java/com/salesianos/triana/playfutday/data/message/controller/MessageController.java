
@RestController
@RequestMapping("/message")
@RequiredArgsConstructor
public class MessageController {

    private ChatService chatService;

    private MessageService messageService;

}
