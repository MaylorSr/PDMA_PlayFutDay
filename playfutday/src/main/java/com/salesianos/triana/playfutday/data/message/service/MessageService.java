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

import javax.transaction.Transactional;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class MessageService {

    private final MessageRepository repo;

    private final ChatRepository chatRepo;

    private final UserRepository userRepository;




    @Transactional
    public MessageResponse createNewMessage(MessageRequest messageRequest,
                                            User user, UUID id) {

        User userWhoReceiveMessage = userRepository.findAllChatsByIdUser(id)
                .orElseThrow(
                        () -> new GlobalEntityNotFounException("User not found with that id")
                );
        User userWhoSend = userRepository.findAllChatsByIdUser(user.getId()).orElseThrow(() -> new GlobalEntityNotFounException(""));
        Chat exitsChat = chatRepo.findChatByUserIds(userWhoSend.getId(), userWhoReceiveMessage.getId());

        Message message = Message.builder()
                .idUser(user.getId())
                .avatar(user.getAvatar())
                .username(user.getUsername())
                .body(messageRequest.getBodyMessage())
                .build();

        Chat chat = exitsChat == null ? chatRepo.save(
                Chat.builder()
                        .members(new HashSet<>(Set.of(user, userWhoReceiveMessage)))
                        .messages(List.of(message))
                        .build()
        ) : exitsChat;

        message.setChat(chat);

        return MessageResponse.of(repo.save(message));
    }


    public List<MessageResponse> findAllMessagesByChatId(Long idChat) {

        return repo.findAllMessagesByChatId(idChat).stream().map(MessageResponse::of).toList();
    }

}