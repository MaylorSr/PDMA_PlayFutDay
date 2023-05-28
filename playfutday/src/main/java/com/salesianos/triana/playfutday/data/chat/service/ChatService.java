package com.salesianos.triana.playfutday.data.chat.service;

import com.salesianos.triana.playfutday.data.chat.dto.ChatResponse;
import com.salesianos.triana.playfutday.data.chat.model.Chat;
import com.salesianos.triana.playfutday.data.chat.repository.ChatRepository;
import com.salesianos.triana.playfutday.data.message.model.Message;
import com.salesianos.triana.playfutday.data.message.repository.MessageRepository;
import com.salesianos.triana.playfutday.data.user.model.User;
import com.salesianos.triana.playfutday.data.user.repository.UserRepository;
import com.salesianos.triana.playfutday.exception.GlobalEntityListNotFounException;
import com.salesianos.triana.playfutday.exception.GlobalEntityNotFounException;
import com.salesianos.triana.playfutday.search.page.PageResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
@RequiredArgsConstructor
public class ChatService {

    private final ChatRepository repo;

    private final MessageRepository messageRepository;

    private final UserRepository userRepository;
    private final ChatRepository chatRepository;

    @Autowired
    private MessageSource messageSource;

    public PageResponse<ChatResponse> findAllChatByUser(User user, Pageable pageable) {
        PageResponse<ChatResponse> res = pageableChat(user, pageable);
        if (res.getContent().isEmpty()) {
            throw new GlobalEntityListNotFounException(
                    messageSource.getMessage(
                            "exception.chat.isEmpty", null, LocaleContextHolder.getLocale()
                    )
            );
        }
        return res;
    }

    public PageResponse<ChatResponse> pageableChat(User user, Pageable pageable) {
        Page<Chat> myChats = userRepository.findChatsByUserId(user.getId(), pageable);
        Page<ChatResponse> myChatsPage =
                new PageImpl<>
                        (myChats.stream().map(chat -> {
                            User otherUser = chatRepository.findOtherUserByChatId(chat.getId(), user.getId());

                            String otherUserName = otherUser != null ? otherUser.getUsername() : "Unknown";
                            String otherUserAvatar = otherUser != null ? otherUser.getAvatar() : "avatar.jpg";

                            String lastMessageBody = messageRepository.findAllMessagesByChatId(chat.getId())
                                    .stream()
                                    .map(Message::getBody)
                                    .reduce((first, second) -> second)
                                    .orElse(null);

                            return ChatResponse.of(chat, otherUserName, otherUserAvatar, lastMessageBody);
                        }).toList(), pageable, myChats == null || myChats.isEmpty() ? 0 : myChats.getTotalPages());
        return new PageResponse<>(myChatsPage);
    }


    /**
     * DEVOLVERÁ TRUE O FALSE SI EL USUARIO SE ENCUENTRA DENTRO DEL CHAT QUE SE HA ENCONTRADO.
     *
     * @param id
     * @param user usuario logeado
     */
    public boolean checkIfUserContainChat(Long id, User user) {
        boolean existsUser = false;
        Chat chat = chatRepository.findById(id).orElseThrow(() -> new GlobalEntityNotFounException(
                messageSource.getMessage(
                        "exception.chat.notExists.id", null, LocaleContextHolder.getLocale()
                )
        ));
        System.out.println(chat.getMembers().contains(user));
        for (User users : chat.getMembers()) {
            if (users.getUsername().equalsIgnoreCase(user.getUsername())) {
                existsUser = true;
            }
        }
        return existsUser;
    }

    public void deleteChat(Long id, User user) {
        Chat chat = chatRepository.findById(id).orElseThrow(() -> new GlobalEntityNotFounException(messageSource.getMessage(
                        "exception.chat.notExists.id", null, LocaleContextHolder.getLocale()
                )
                )
        );
//        for (User u: chat.getMembers()) {
//            u.getMyChats().remove(chat);
//        }
        deleteChatIfMembersNull();
    }


    /**
     * METODO DE BORRADO GENERAL DE UN CHAT, EN CASO DE QUE NO TENGA MIEMBROS PORQUE AMBOS SE HAN ELIMINADO LA CUENTA
     * O HAYAN DECIDIDO BORRAR SU CHAT, SE DEBERÁ ELIMINAR EL CHAT PARA NO CONSERVARLO EN LA BD.
     */
    public void deleteChatIfMembersNull() {
        List<Chat> allChats = chatRepository.findAll();
        for (Chat c : allChats) {
            if (c.getMembers().isEmpty() || c.getMembers() == null) {
                repo.deleteById(c.getId());
            }
        }

    }


}