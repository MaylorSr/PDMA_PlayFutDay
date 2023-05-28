package com.salesianos.triana.playfutday.data.message.service;

import com.salesianos.triana.playfutday.data.chat.dto.ChatResponse;
import com.salesianos.triana.playfutday.data.chat.model.Chat;
import com.salesianos.triana.playfutday.data.chat.repository.ChatRepository;
import com.salesianos.triana.playfutday.data.message.dto.MessageRequest;
import com.salesianos.triana.playfutday.data.message.dto.MessageResponse;
import com.salesianos.triana.playfutday.data.message.model.Message;
import com.salesianos.triana.playfutday.data.message.repository.MessageRepository;
import com.salesianos.triana.playfutday.data.user.dto.UserFollow;
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

import javax.persistence.EntityNotFoundException;
import javax.transaction.Transactional;
import java.time.LocalDateTime;
import java.util.*;

@Service
@RequiredArgsConstructor
public class MessageService {

    private final MessageRepository repo;

    private final ChatRepository chatRepo;

    private final UserRepository userRepository;

    @Autowired
    private MessageSource messageSource;

    @Transactional
    public MessageResponse createNewMessage(MessageRequest messageRequest,
                                            User user, UUID id) {
        /** BUSCAMOS EL USUARIO POR SU ID EN **/
        User userWhoReceiveMessage = userRepository.findById(UUID.fromString(id.toString()))
                .orElseThrow(() -> new GlobalEntityNotFounException(
                                messageSource.getMessage(
                                        "exception.user.notExists.id", null, LocaleContextHolder.getLocale()
                                )
                        )
                );


        /** CREAMOS EL MENSAJE **/
        Message message = Message.builder()
                .idUser(user.getId().toString())
                .avatar(user.getAvatar())
                .username(user.getUsername())
                .body(messageRequest.getBodyMessage())
                .build();

        /** COMPROBAMOS SI EXISTE UN CHAT CON ESOS DOS USUARIOS **/
        Chat exitsChat = chatRepo.findChatByUserIds(user.getId(), userWhoReceiveMessage.getId());

        Chat chat = exitsChat == null ? chatRepo.save(
                Chat.builder()
                        .members(new ArrayList<>(List.of(user, userWhoReceiveMessage)))
                        .messages(List.of(message))
                        .build()
        ) : exitsChat;

        message.setChat(chat);
        message.getChat().setCreatedChat(LocalDateTime.now());

        return MessageResponse.of(repo.save(message));
    }


    public PageResponse<MessageResponse> pageableUser(Long id, Pageable pageable) {
        chatRepo.findById(id).orElseThrow(() -> new GlobalEntityListNotFounException(
                        messageSource.getMessage("exception.chat.notExists.id", null, LocaleContextHolder.getLocale()
                        )
                )
        );
        Page<Message> messagesOfChat = repo.findAllMessagesByChatIdPage(id, pageable);
        Page<MessageResponse> userFollowPage =
                new PageImpl<>
                        (messagesOfChat.stream().toList(), pageable, messagesOfChat == null ? 0 : messagesOfChat.getTotalPages()).map(MessageResponse::of);
        return new PageResponse<>(userFollowPage);
    }


    public PageResponse<MessageResponse> findAllMessagesByChatId(Long id, Pageable pageable) {
        chatRepo.findById(id).orElseThrow(() -> new GlobalEntityListNotFounException(
                messageSource.getMessage("exception.chat.notExists.id", null, LocaleContextHolder.getLocale()
                )));
        PageResponse<MessageResponse> res = pageableUser(id, pageable);
        if (res.getContent().isEmpty()) {
            throw new GlobalEntityListNotFounException(
                    messageSource.getMessage("exception.chat.isEmpty", null, LocaleContextHolder.getLocale()

                    ));
        }
        return res;
    }


    public boolean checkIfMessageContainChat(Long id, User user) {
        Message m = repo.findById(id).orElseThrow(() -> new GlobalEntityNotFounException(
                        messageSource.getMessage("exception.message.notExists.id", null, LocaleContextHolder.getLocale()
                        )
                )
        );
        return m.getUsername().equalsIgnoreCase(user.getUsername());
    }

    public void deleteMessage(Long id) {
        repo.deleteById(id);
    }
}