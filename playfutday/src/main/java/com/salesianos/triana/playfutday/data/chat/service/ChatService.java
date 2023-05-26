package com.salesianos.triana.playfutday.data.chat.service;

import com.salesianos.triana.playfutday.data.chat.dto.ChatResponse;
import com.salesianos.triana.playfutday.data.chat.model.Chat;
import com.salesianos.triana.playfutday.data.chat.repository.ChatRepository;
import com.salesianos.triana.playfutday.data.message.model.Message;
import com.salesianos.triana.playfutday.data.message.repository.MessageRepository;
import com.salesianos.triana.playfutday.data.user.dto.UserResponse;
import com.salesianos.triana.playfutday.data.user.model.User;
import com.salesianos.triana.playfutday.data.user.repository.UserRepository;
import com.salesianos.triana.playfutday.exception.GlobalEntityListNotFounException;
import com.salesianos.triana.playfutday.exception.GlobalEntityNotFounException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ChatService {

    private final ChatRepository repo;

    private final MessageRepository messageRepository;

    private final UserRepository userRepository;
    private final ChatRepository chatRepository;


    public List<ChatResponse> findAllChatByUser(User user) {
        if (userRepository.findChatsByUserId(user.getId()) == null || userRepository.findChatsByUserId(user.getId()).isEmpty()) {
            throw new GlobalEntityListNotFounException("You not have any chats!");
        }

        return userRepository.findChatsByUserId(user.getId()).stream().map(
                chats -> {

                    return ChatResponse.of(
                            chats,
                            chats.getMembers().stream().filter(user1 -> !user1.equals(user)).findFirst().get(),
                            messageRepository.findAllMessagesByChatId(chats.getId())
                                    .stream()
                                    .map(Message::getBody)
                                    .max(Comparator.naturalOrder())
                                    .orElse(null)
                    );
                }

        ).toList();


    }


}