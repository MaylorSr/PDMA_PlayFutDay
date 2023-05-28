package com.salesianos.triana.playfutday.data.chat.controller;

import com.salesianos.triana.playfutday.data.chat.dto.ChatResponse;
import com.salesianos.triana.playfutday.data.chat.service.ChatService;
import com.salesianos.triana.playfutday.data.message.service.MessageService;
import com.salesianos.triana.playfutday.data.post.dto.PostResponse;
import com.salesianos.triana.playfutday.data.user.model.User;
import com.salesianos.triana.playfutday.search.page.PageResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/chat")
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;


    @Operation(summary = "Este método obtiene todos los chats de un usuario")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Sa han devuelto los datos correctamente de todos chats del usuario",
                    content = {@Content(mediaType = "application/json",
                            array = @ArraySchema(schema = @Schema(implementation = ChatResponse.class)),
                            examples = {@ExampleObject(
                                    value = """
                                            [
                                             {
                                                 "content": [
                                                      {
                                                        "id": 1000,
                                                        "avatarUserDestinity": "avatar.jpg",
                                                        "usernameUserDestinity": "Unknown",
                                                        "lastMessage": "mensaje no borrar"
                                                      },
                                                      {
                                                        "id": 1003,
                                                         "avatarUserDestinity": "david.jpg",
                                                         "usernameUserDestinity": "david",
                                                         "lastMessage": "mensaje no borrar"
                                                      }
                                                 ],
                                                 "totalPages": 8
                                             }
                                            ]
                                             """
                            )}
                    )}),
            @ApiResponse(responseCode = "405",
                    description = "Estas intentado hacer la petición de GET a otra distinta, ejemplo POST",
                    content = @Content),
            @ApiResponse(responseCode = "400", description = "Estas intentando pasar cuerpo a la petición que no lo requiere", content = @Content),
            @ApiResponse(responseCode = "404", description = "La lista está vacía", content = @Content),
            @ApiResponse(responseCode = "401", description = "No estas logeado", content = @Content)

    })
    @GetMapping("/")
    public PageResponse<ChatResponse> findAllChatByUser(
            @AuthenticationPrincipal User user,
            @PageableDefault(size = 20, page = 0) Pageable pageable) {
        return chatService.findAllChatByUser(user, pageable);
    }


    @Operation(summary = "Este método elmina el chat de un usuario")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204",
                    description = "Se ha eliminado el chat correctamente"),
            @ApiResponse(responseCode = "404",
                    description = "El chat no existe",
                    content = @Content),
            @ApiResponse(responseCode = "401",
                    description = "No estas logeado",
                    content = @Content),
            @ApiResponse(responseCode = "405",
                    description = "Estas intentado hacer la petición de DELETE a otra distinta, ejemplo GET",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "No tienes permisos para realizar esta petición porque no te encuentras dentro del chat",
                    content = @Content)
    })
    @DeleteMapping("/{id}")
    @PreAuthorize("@chatService.checkIfUserContainChat(#id, authentication.principal)")
    public ResponseEntity<?> deleteChat(@PathVariable Long id, @AuthenticationPrincipal User user) {

        chatService.deleteChat(id, user);
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }


}

