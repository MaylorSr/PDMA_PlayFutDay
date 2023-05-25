package com.salesianos.triana.playfutday.data.chat.controller;

import com.salesianos.triana.playfutday.data.chat.dto.ChatResponse;
import com.salesianos.triana.playfutday.data.chat.model.Chat;
import com.salesianos.triana.playfutday.data.chat.service.ChatService;
import com.salesianos.triana.playfutday.data.message.dto.MessageResponse;
import com.salesianos.triana.playfutday.data.message.service.MessageService;
import com.salesianos.triana.playfutday.data.user.model.User;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/chat")
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;

    private final MessageService messageService;


    @GetMapping("/")
    public List<String> findAllChatByUser(@AuthenticationPrincipal User user) {
        return chatService.findAllChatByUser(user);
    }


}

