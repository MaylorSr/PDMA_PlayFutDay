package com.salesianos.triana.playfutday.data.message.controller;

import com.salesianos.triana.playfutday.data.chat.service.ChatService;
import com.salesianos.triana.playfutday.data.message.dto.MessageRequest;
import com.salesianos.triana.playfutday.data.message.dto.MessageResponse;
import com.salesianos.triana.playfutday.data.message.service.MessageService;
import com.salesianos.triana.playfutday.data.user.dto.UserResponse;
import com.salesianos.triana.playfutday.data.user.model.User;
import io.swagger.v3.oas.annotations.Parameter;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import javax.transaction.Transactional;
import java.net.URI;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/message")
@RequiredArgsConstructor
public class MessageController {

    private final ChatService chatService;

    private final MessageService messageService;


    @PostMapping("/{id}")
    public ResponseEntity<MessageResponse> createNewChat(
            @RequestBody MessageRequest request,
            @AuthenticationPrincipal User user,
            @PathVariable UUID id
    ) {
        if (user == null) {
            throw new AccessDeniedException("");
        }
        MessageResponse response = messageService.createNewMessage(request, user, id);
        URI createdURI = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(response.getId()).toUri();
        return ResponseEntity
                .created(createdURI)
                .body(response);

    }
    @GetMapping("/{idChat}")
    public List<MessageResponse> getAllMessagesByIdChat(@PathVariable(name = "idChat") Long idChat) {
        return messageService.findAllMessagesByChatId(idChat);
    }
}
