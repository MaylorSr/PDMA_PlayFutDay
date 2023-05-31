package com.salesianos.triana.playfutday.data.message.controller;

import com.salesianos.triana.playfutday.data.chat.dto.ChatResponse;
import com.salesianos.triana.playfutday.data.chat.service.ChatService;
import com.salesianos.triana.playfutday.data.message.dto.MessageRequest;
import com.salesianos.triana.playfutday.data.message.dto.MessageResponse;
import com.salesianos.triana.playfutday.data.message.service.MessageService;
import com.salesianos.triana.playfutday.data.user.dto.LoginRequest;
import com.salesianos.triana.playfutday.data.user.dto.UserResponse;
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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import javax.validation.Valid;
import java.net.URI;
import java.util.UUID;

@RestController
@RequestMapping("/message")
@RequiredArgsConstructor
public class MessageController {
    private final MessageService messageService;


    @Operation(summary = "Este método enviar un mensaje a otro usuario")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se ha enviado el mensaje correctamente",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = MessageResponse.class),
                            examples = {@ExampleObject(
                                    value = """
                                            {
                                                "id": 1004,
                                                "idUserWhoSendMessage": "681903b4-dc43-43c2-942c-86b81b15d1fc",
                                                "usernameWhoSendMessage": "marta",
                                                "avatarWhoSendMessage": "marta.jpg",
                                                "bodyMessage": "Hola buenas",
                                                "timeWhoSendMessage": "28/05/2023 00:56"
                                            }
                                             """
                            )}
                    )}),
            @ApiResponse(responseCode = "401",
                    description = "No estas logeado u autenticado",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "No puedes mandarte mensajes a ti mismo",
                    content = @Content),
            @ApiResponse(responseCode = "404",
                    description = "No existe el usuario destinatario",
                    content = @Content)
    })
    @PostMapping("/{id}")
    @PreAuthorize("#id != authentication.principal.id")
    public ResponseEntity<MessageResponse> createNewChat(
            @Valid @RequestBody MessageRequest request,
            @AuthenticationPrincipal User user,
            @PathVariable(name = "id") UUID id
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


    @Operation(summary = "Este método obtiene todos los mensajes de un chat")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Sa han devuelto los datos correctamente de todos mensajes de un chat",
                    content = {@Content(mediaType = "application/json",
                            array = @ArraySchema(schema = @Schema(implementation = MessageResponse.class)),
                            examples = {@ExampleObject(
                                    value = """
                                            [
                                             {
                                                 "content": [
                                                       {
                                                              "id": 1001,
                                                              "idUserWhoSendMessage": "7495ac21-9cef-4655-a816-29a1eee80841",
                                                              "usernameWhoSendMessage": "alejandro",
                                                              "avatarWhoSendMessage": "alejandro.jpg",
                                                              "bodyMessage": "Hola buenas, segunda mensaje",
                                                              "timeWhoSendMessage": "26/05/2023 21:46"
                                                          },
                                                          {
                                                              "id": 1002,
                                                              "idUserWhoSendMessage": "681903b4-dc43-43c2-942c-86b81b15d1fc",
                                                              "usernameWhoSendMessage": "marta",
                                                              "avatarWhoSendMessage": "marta.jpg",
                                                              "bodyMessage": "Hola buenas, segunda mensaje",
                                                              "timeWhoSendMessage": "26/05/2023 21:46"
                                                          }
                                                 ],
                                                 "totalPages": 8,
                                                 "totalElements":20
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
    @GetMapping("/{idUser}")
    public PageResponse<MessageResponse> getAllMessagesByIdChat(@PathVariable(name = "idUser") UUID idUser,
                                                                @AuthenticationPrincipal User user,
                                                                @PageableDefault(size = 30, page = 0)
                                                                Pageable pageable
    ) {

        return messageService.findAllMessagesByChatId(idUser, user, pageable);
    }

    @Operation(summary = "Este método elmina el mensaje de un chat")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204",
                    description = "Se ha eliminado el mensaje correctamente"),
            @ApiResponse(responseCode = "404",
                    description = "El mensaje no existe",
                    content = @Content),
            @ApiResponse(responseCode = "401",
                    description = "No estas logeado",
                    content = @Content),
            @ApiResponse(responseCode = "405",
                    description = "Estas intentado hacer la petición de DELETE a otra distinta, ejemplo GET",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "No tienes permisos para realizar esta petición porque no se encuentra el mensaje dentro del chat",
                    content = @Content)
    })
    @DeleteMapping("/{id}")
    @PreAuthorize("@messageService.checkIfMessageContainChat(#id, authentication.principal)")
    public ResponseEntity<?> deleteMessage(@PathVariable Long id, @AuthenticationPrincipal User user) {

        messageService.deleteMessage(id);
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }

}
