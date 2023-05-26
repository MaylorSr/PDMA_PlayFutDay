package com.salesianos.triana.playfutday.data.message.service;

import com.salesianos.triana.playfutday.data.chat.dto.ChatResponse;
import com.salesianos.triana.playfutday.data.chat.model.Chat;
import com.salesianos.triana.playfutday.data.chat.repository.ChatRepository;
import com.salesianos.triana.playfutday.data.message.dto.MessageRequest;
import com.salesianos.triana.playfutday.data.message.dto.MessageResponse;
import com.salesianos.triana.playfutday.data.message.model.Message;
import com.salesianos.triana.playfutday.data.message.repository.MessageRepository;
import com.salesianos.triana.playfutday.data.user.model.User;
import com.salesianos.triana.playfutday.data.user.repository.UserRepository;
import com.salesianos.triana.playfutday.exception.GlobalEntityNotFounException;
import lombok.RequiredArgsConstructor;
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




    @Transactional
    public MessageResponse createNewMessage(MessageRequest messageRequest,
                                            User user, UUID id) {
//        User userWhoReceiveMessage = userRepository.findUserWithCommonChats(id.toString()).get();
        User userWhoReceiveMessage = userRepository.findById(id).orElseThrow(() -> new GlobalEntityNotFounException("User not found with that id"));
//                .orElseThrow(
//                        () -> new GlobalEntityNotFounException("User not found with that id")
//                );

//        User userWhoReceiveMessage = userRepository.findById(id).orElseThrow(() -> new EntityNotFoundException(""));
//        User userWhoSend = userRepository.findAllChatsByIdUser(user.getId()).orElseThrow(() -> new GlobalEntityNotFounException(""));
        Chat exitsChat = chatRepo.findChatByUserIds(user.getId(), userWhoReceiveMessage.getId());

        Message message = Message.builder()
                .idUser(user.getId())
                .avatar(user.getAvatar())
                .username(user.getUsername())
                .body(messageRequest.getBodyMessage())
                .build();

        Chat chat = exitsChat == null ? chatRepo.save(
                Chat.builder()
                        .members(new ArrayList<>(List.of(user, userWhoReceiveMessage)))
                        .messages(List.of(message))
                        .build()
        ) : exitsChat;

//        user.getMyChats().add(chat);

        message.setChat(chat);

        return MessageResponse.of(repo.save(message));
    }


    public List<MessageResponse> findAllMessagesByChatId(Long idChat) {

        return repo.findAllMessagesByChatId(idChat).stream().map(MessageResponse::of).toList();
    }

}