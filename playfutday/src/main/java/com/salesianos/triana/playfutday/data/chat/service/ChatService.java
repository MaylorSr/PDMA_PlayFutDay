package com.salesianos.triana.playfutday.data.chat.service;

import com.salesianos.triana.playfutday.data.chat.dto.ChatResponse;
import com.salesianos.triana.playfutday.data.chat.model.Chat;
import com.salesianos.triana.playfutday.data.chat.repository.ChatRepository;
import com.salesianos.triana.playfutday.data.message.repository.MessageRepository;
import com.salesianos.triana.playfutday.data.user.model.User;
import com.salesianos.triana.playfutday.data.user.repository.UserRepository;
import com.salesianos.triana.playfutday.exception.GlobalEntityListNotFounException;
import com.salesianos.triana.playfutday.exception.GlobalEntityNotFounException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ChatService {

    private final ChatRepository repo;

    private final MessageRepository messageRepository;

    private final UserRepository userRepository;


//    public List<Chat> findAllChatByUser(User user) {
//        return userRepository.findById(user.getId())
//                .map(
//                        userR -> {
//                            return userR.getMyChats();
//                        }
//                )
//
//                .orElseThrow(() -> new GlobalEntityNotFounException("The user was not found"));
//    }



    public List<String> findAllChatByUser(User user) {
        List<String> campo = new ArrayList<>();
        return userRepository.findById(user.getId())
                .map(
                        userR -> {
                            if (userR.getMyChats() == null || userR.getMyChats().isEmpty()) {
                                throw new GlobalEntityListNotFounException("The user not have any chats");
                            } else {
                                for (Chat c : user.getMyChats()) {
                                    campo.add(c.getId().toString());
                                }
                                return campo;
                            }
                        }
                )

                .orElseThrow(() -> new GlobalEntityNotFounException("The user was not found"));
    }
}