package com.salesianos.triana.playfutday.data.user.controller;

import com.fasterxml.jackson.annotation.JsonView;
import com.salesianos.triana.playfutday.data.commentary.dto.CommentaryResponse;
import com.salesianos.triana.playfutday.data.files.exception.StorageException;
import com.salesianos.triana.playfutday.data.interfaces.commentary.viewCommentary;
import com.salesianos.triana.playfutday.data.interfaces.post.viewPost;
import com.salesianos.triana.playfutday.data.interfaces.user.viewUser;
import com.salesianos.triana.playfutday.data.post.dto.PostResponse;
import com.salesianos.triana.playfutday.data.termporalUser.services.TemporalUserService;
import com.salesianos.triana.playfutday.data.user.dto.*;
import com.salesianos.triana.playfutday.data.user.interfaces.IUserResponseCreated;
import com.salesianos.triana.playfutday.data.user.interfaces.IUserResponseEnabled;
import com.salesianos.triana.playfutday.data.user.model.User;
import com.salesianos.triana.playfutday.data.user.service.UserService;
import com.salesianos.triana.playfutday.search.page.PageResponse;
import com.salesianos.triana.playfutday.security.jwt.access.JwtProvider;

import com.salesianos.triana.playfutday.security.refresh.RefreshToken;
import com.salesianos.triana.playfutday.security.refresh.RefreshTokenException;
import com.salesianos.triana.playfutday.security.refresh.RefreshTokenRequest;
import com.salesianos.triana.playfutday.security.refresh.RefreshTokenService;
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
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import javax.validation.Valid;
import java.net.URI;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final AuthenticationManager authManager;
    private final JwtProvider jwtProvider;

    private final RefreshTokenService refreshTokenService;

    private final TemporalUserService temporalUserService;


    @Operation(summary = "Este método crea envia un código de verificación al email del usuario para poder crear su cuenta")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha enviado correctamente el código de verifiación",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = UserRequest.class),
                            examples = @ExampleObject(value = """
                                    {
                                      "The code was send to email: maylorbustamante2001@gmail.com, please review your email or spam email."
                                    }
                                    """))}),
            @ApiResponse(responseCode = "400",
                    description = "No se han introducidos los datos correctamente o el email no existe. Observa la lista de errores",
                    content = @Content),
            @ApiResponse(responseCode = "401",
                    description = "Haz intentado realizar la petición borrando un atributo del post",
                    content = @Content),
            @ApiResponse(responseCode = "405",
                    description = "Estas intentado hacer la petición de POST a otra distinta, ejemplo GET",
                    content = @Content),
    })
    @PostMapping("/auth/register")
    public ResponseEntity<String> createUserWithCode(@Valid @RequestBody @Parameter(name = "UserRequest",
            description = "La información del usuario que se va a crear")
                                                     UserRequest createUserRequest) {

        return ResponseEntity.status(HttpStatus.OK).body(temporalUserService.SendCodeToEmail(createUserRequest));
    }

    @Operation(summary = "Este método crea la cuenta de un usuario")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se ha creado un nuevo usuario",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = UserRequest.class),
                            examples = @ExampleObject(value = """
                                    {
                                        "username": "maylor",
                                        "email": "maylor@gmail.com",
                                        "phone": "609835692",
                                        "password":"Maylor15",
                                        "verifyPassword":"Maylor15"
                                    }
                                    """))}),
            @ApiResponse(responseCode = "400",
                    description = "El código introducido no pertenece a ningún usuario o es incorrecto",
                    content = @Content),
            @ApiResponse(responseCode = "401",
                    description = "Haz intentado realizar la petición borrando un atributo del post",
                    content = @Content),
            @ApiResponse(responseCode = "405",
                    description = "Estas intentado hacer la petición de POST a otra distinta, ejemplo GET",
                    content = @Content),
    })

    @PostMapping("/auth/verifyCode/{code}")
    @JsonView(viewUser.UserResponse.class)
    public ResponseEntity<UserResponse> createUserWithUserRole(
            @Parameter(name = "CODE", description = "Se debe proporcionar el código que se le ha enviado a la email del usuario para crear la cuenta",
                    allowEmptyValue = true
            ) @PathVariable String code) {

        User user = userService.createUserWithUserRole(temporalUserService.verifyCode(code));

        return ResponseEntity.status(HttpStatus.CREATED).body(UserResponse.fromUser(user));
    }

    @Operation(summary = "Este método obtiene los posts favoritos del usuario logeado")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Sa han devuelto los posts que el usuario le ha dado a favoritos",
                    content = {@Content(mediaType = "application/json",
                            array = @ArraySchema(schema = @Schema(implementation = viewPost.PostViewMobile.class)),
                            examples = {@ExampleObject(
                                    value = """
                                            [
                                             {
                                                         "id": 1,
                                                         "tag": "#pacheco",
                                                         "description": "RCD ESPANYOL",
                                                         "image": "PACHECO.jpg",
                                                         "uploadDate": "15/07/1998",
                                                         "author": "alejandro",
                                                         "idAuthor": "7495ac21-9cef-4655-a816-29a1eee80841",
                                                         "authorFile": "alejandro.jpg",
                                                         "likesByAuthor": [
                                                             "marta"
                                                         ],
                                                         "countLikes": 1,
                                                         "commentaries": [
                                                             {
                                                                 "message": "Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.",
                                                                 "authorName": "alejandro",
                                                                 "authorFile": "alejandro.jpg",
                                                                 "uploadCommentary": "23/04/2023"
                                                             },
                                                         ]
                                                     }
                                            ]
                                             """
                            )}
                    )}),
            @ApiResponse(responseCode = "405",
                    description = "Estas intentado hacer la petición de GET a otra distinta, ejemplo POST",
                    content = @Content),
            @ApiResponse(responseCode = "401", description = "No estas logeado", content = @Content),
            @ApiResponse(responseCode = "404", description = "La lista se encuentra vacía", content = @Content)
    })
    @GetMapping("/fav")
    @JsonView({viewPost.PostViewMobile.class})
    public PageResponse<PostResponse> findAll(@PageableDefault(size = 5, page = 0) Pageable pageable,
                                              @Parameter(name = "Usuario", description = "Se pasa el token del usuario logeado",
                                                      content = @Content, allowEmptyValue = true)
                                              @AuthenticationPrincipal User user) {
        return userService.findMyFavPost(user, pageable);
    }


    @Operation(summary = "Este método elmina o da de baja a un usuario")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204",
                    description = "El usuario se ha eliminado correctamente"),
            @ApiResponse(responseCode = "404",
                    description = "No se ha encontrado el usuario",
                    content = @Content),
            @ApiResponse(responseCode = "401",
                    description = "No estas logeado",
                    content = @Content),
            @ApiResponse(responseCode = "405",
                    description = "Estas intentado hacer la petición de DELETE a otra distinta, ejemplo GET",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "No tienes permisos para realizar esta petición",
                    content = @Content)
    })
    @DeleteMapping("/user/{idU}")
    @PreAuthorize("#idU == authentication.principal.id or hasRole('ADMIN')")
    public ResponseEntity<?> deleteUser(@Parameter(name = "idU", description = "Id del usuario a eliminar")
                                        @PathVariable UUID idU) {
        userService.deleteUser(idU);
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }

    @Operation(summary = "Este método sirve para realizar el token de refresco al usuario logeado")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "El token se ha refrescadi correctamente",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = LoginRequest.class),
                            examples = {@ExampleObject(
                                    value = """
                                            {
                                                 "id": "7495ac21-9cef-4655-a816-29a1eee80841",
                                                 "username": "alejandro",
                                                 "email": "alejandro@gmail.com",
                                                 "avatar": "alejandro.jpg",
                                                 "biography": "I am Alejandro, a software engineer passionate about coding and hiking in my free time.",
                                                 "phone": "170304671",
                                                 "birthday": "17/12/2002",
                                                 "myPost": [
                                                     {
                                                         "image": "PACHECO.jpg"
                                                     },
                                                     {
                                                         "image": "POZO.jpg"
                                                     },
                                                     {
                                                         "image": "tec_lampard.png"
                                                     },
                                                     {
                                                         "image": "insigne.jpg"
                                                     }
                                                 ],
                                                 "roles": [
                                                     "USER"
                                                 ],
                                                 "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI3NDk1YWMyMS05Y2VmLTQ2NTUtYTgxNi0yOWExZWVlODA4NDEiLCJpYXQiOjE2ODI3MDQ1ODYsImV4cCI6MTY4MjcwNDg4Nn0.7BSW-Zavbwre62s8e4nkM51BZLo69j0tLmKsateJiIDESDf_HTUFM8zXg9Yfz-L1OZw0ZDvksldlDYFS-MYnTA",
                                                 "refreshToken": "894f0d98-773c-4843-9ac2-03b40dab8dbb"
                                             }
                                             """
                            )}
                    )}),
            @ApiResponse(responseCode = "401",
                    description = "No estas logeado u autenticado o el token de refresco ha expirado",
                    content = @Content),
    })
    @PostMapping("/refresh/token")
    @JsonView(viewUser.UserInfo.class)
    public ResponseEntity<UserResponse> refreshToken(@RequestBody RefreshTokenRequest request) {
        String refreshToken = request.getRefreshToken();

        return refreshTokenService.findByToken(refreshToken)
                .map(refreshTokenService::verifyRefreshToken)
                .map(RefreshToken::getUser)
                .map(user -> {
                    String token = jwtProvider.generateToken(user);
                    refreshTokenService.deleteByUser(user);
                    RefreshToken newRefreshToken = refreshTokenService.createRefreshToken(user);
                    UserResponse userP = UserResponse.fromUser((user));
                    userP.setToken(token);
                    userP.setRefreshToken(newRefreshToken.getToken());
                    return ResponseEntity.status(HttpStatus.CREATED).body(userP);
                }).
                orElseThrow(
                        () -> new RefreshTokenException("Not found the refresh token")
                );
    }

    @Operation(summary = "Este método sirve para logear a un usuario ya creado")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "El usuario se ha logeado correctamente y devuelto sus datos",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = LoginRequest.class),
                            examples = {@ExampleObject(
                                    value = """
                                            {
                                                 "id": "7495ac21-9cef-4655-a816-29a1eee80841",
                                                 "username": "alejandro",
                                                 "email": "alejandro@gmail.com",
                                                 "avatar": "alejandro.jpg",
                                                 "biography": "I am Alejandro, a software engineer passionate about coding and hiking in my free time.",
                                                 "phone": "170304671",
                                                 "birthday": "17/12/2002",
                                                 "myPost": [
                                                     {
                                                         "image": "PACHECO.jpg"
                                                     },
                                                     {
                                                         "image": "POZO.jpg"
                                                     },
                                                     {
                                                         "image": "tec_lampard.png"
                                                     },
                                                     {
                                                         "image": "insigne.jpg"
                                                     }
                                                 ],
                                                 "roles": [
                                                     "USER"
                                                 ],
                                                 "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI3NDk1YWMyMS05Y2VmLTQ2NTUtYTgxNi0yOWExZWVlODA4NDEiLCJpYXQiOjE2ODI3MDQ1ODYsImV4cCI6MTY4MjcwNDg4Nn0.7BSW-Zavbwre62s8e4nkM51BZLo69j0tLmKsateJiIDESDf_HTUFM8zXg9Yfz-L1OZw0ZDvksldlDYFS-MYnTA",
                                                 "refreshToken": "894f0d98-773c-4843-9ac2-03b40dab8dbb"
                                             }
                                             """
                            )}
                    )}),
            @ApiResponse(responseCode = "401",
                    description = "No estas logeado u autenticado",
                    content = @Content)
    })
    @PostMapping("/auth/login")
    @JsonView(viewUser.UserInfo.class)
    public ResponseEntity<UserResponse> login(@Parameter(name = "Usuario",
            description = "Se debe proporcionar el usuario y contraseña respectivamente para poder logearse", allowEmptyValue = true, content = @Content)
                                              @RequestBody LoginRequest loginRequest) {
        Authentication authentication =
                authManager.authenticate(new UsernamePasswordAuthenticationToken(loginRequest.getUsername(), loginRequest.getPassword()));

        SecurityContextHolder.getContext().setAuthentication(authentication);

        String token = jwtProvider.generateToken(authentication);
        refreshTokenService.deleteByUser((User) authentication.getPrincipal());
        RefreshToken refreshToken = refreshTokenService.createRefreshToken((User) authentication.getPrincipal());
        UserResponse userP = UserResponse.fromUser((User) authentication.getPrincipal());
        userP.setToken(token);
        userP.setRefreshToken(refreshToken.getToken());
        return ResponseEntity.status(HttpStatus.CREATED).body(userP);
    }

    @Operation(summary = "Este método implementa seguir a un usuario o dejar de seguirlo")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se ha dado/quitado el follow al usuario destinatario",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(),
                            examples = @ExampleObject(value = """
                                    {
                                        "Now, you follow at @username"
                                    }
                                    """))}),
            @ApiResponse(responseCode = "401",
                    description = "No estas logeado",
                    content = @Content),
            @ApiResponse(responseCode = "405",
                    description = "Estas intentado hacer la petición de POST a otra distinta, ejemplo GET",
                    content = @Content),
            @ApiResponse(responseCode = "404",
                    description = "El id del usuario destinatario a darle follow / unfollow no existe",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "No puedes seguirte a ti mismo",
                    content = @Content)
    })
    @PostMapping("/user/follow/{id}")
    @PreAuthorize("authentication.principal.id != #id")
    public String updateFollowers(@PathVariable UUID id, @AuthenticationPrincipal User user) {
        return userService.updateFollowers(user, id);
    }


    @Operation(summary = "Este método obtiene una lista paginada de los followers de un determinado usuario")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha obtenido la lista paginada correctamente",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = UserFollow.class),
                            examples = @ExampleObject(value = """
                                    {
                                        {
                                            "content": [
                                                {
                                                    "id": "d8825758-d02a-4bcc-8146-95fb6fa3ded7",
                                                    "username": "bmacalester1",
                                                    "avatar": "avatar.png"
                                                }
                                            ],
                                            "totalPages": 1
                                        }
                                    }
                                    """))}),
            @ApiResponse(responseCode = "401",
                    description = "No estas logeado",
                    content = @Content),
            @ApiResponse(responseCode = "405",
                    description = "Estas intentado hacer la petición de POST a otra distinta, ejemplo GET",
                    content = @Content),
            @ApiResponse(responseCode = "404",
                    description = "El id del usuario al que quieres ver los followers no existe",
                    content = @Content),
            @ApiResponse(responseCode = "404",
                    description = "No tienes ningún seguidor en esta página o el usuario no existe ",
                    content = @Content)
    })
    @GetMapping("/user/followers/{id}")
    @JsonView(viewUser.UserFollow.class)
    public PageResponse<UserFollow> getFollowers(@PathVariable UUID id,
                                                 @PageableDefault(size = 10, page = 0) Pageable pageable) {
        return userService.getFollowers(id, pageable);
    }


    @Operation(summary = "Este método obtiene una lista paginada de los follows de un determinado usuario")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha obtenido la lista paginada correctamente",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(),
                            examples = @ExampleObject(value = """
                                    {
                                        {
                                            "content": [
                                                {
                                                    "id": "d8825758-d02a-4bcc-8146-95fb6fa3ded7",
                                                    "username": "bmacalester1",
                                                    "avatar": "avatar.png"
                                                }
                                            ],
                                            "totalPages": 1
                                        }
                                    }
                                    """))}),
            @ApiResponse(responseCode = "401",
                    description = "No estas logeado",
                    content = @Content),
            @ApiResponse(responseCode = "405",
                    description = "Estas intentado hacer la petición de POST a otra distinta, ejemplo GET",
                    content = @Content),
            @ApiResponse(responseCode = "404",
                    description = "El id del usuario al que quieres ver los follows no existe",
                    content = @Content),
            @ApiResponse(responseCode = "404",
                    description = "No sigues a nadie en esta página o el usuario no existe ",
                    content = @Content)
    })
    @GetMapping("/user/follows/{id}")
    @JsonView(viewUser.UserFollow.class)
    public PageResponse<UserFollow> getFollows(@PathVariable UUID id,
                                               @PageableDefault(size = 10, page = 0) Pageable pageable) {
        return userService.getFollows(id, pageable);
    }


    /**
     * REQUESTS VIEW WEB
     */
    @Operation(summary = "Este método obtiene todos los datos de los usuarios creados")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Sa han devuelto los datos correctamente de todos los usuarios sólo para el administrador",
                    content = {@Content(mediaType = "application/json",
                            array = @ArraySchema(schema = @Schema(implementation = UserResponse.class)),
                            examples = {@ExampleObject(
                                    value = """
                                            [
                                             {
                                                 "content": [
                                                     {
                                                         "id": "abb9feac-f0ec-45cf-91a9-5d21c789da2d",
                                                         "username": "ccliss6",
                                                         "createdAt": "22/02/2023 21:43:35",
                                                         "avatar": "avatar.png",
                                                         "birthday": "06/12/1997",
                                                         "enabled": true,
                                                         "roles": [
                                                             "USER"
                                                         ]
                                                     },
                                                     {
                                                         "id": "6e245baa-4865-45be-99f0-33d548b16887",
                                                         "username": "mdeverell7",
                                                         "createdAt": "22/02/2023 21:43:35",
                                                         "avatar": "avatar.png",
                                                         "birthday": "15/12/1991",
                                                         "enabled": true,
                                                         "roles": [
                                                             "USER"
                                                         ]
                                                     },
                                                     {
                                                         "id": "563d2700-0c3c-4276-a4c4-55f861ebe90a",
                                                         "username": "nchoppen8",
                                                         "createdAt": "22/02/2023 21:43:35",
                                                         "avatar": "avatar.png",
                                                         "birthday": "12/10/1988",
                                                         "enabled": true,
                                                         "roles": [
                                                             "USER"
                                                         ]
                                                     }
                                                 ],
                                                 "totalPages": 4,
                                                 "totalElements" : 3
                                             }
                                            ]
                                             """
                            )}
                    )}),
            @ApiResponse(responseCode = "403",
                    description = "No tienes permisos para acceder a esta petición",
                    content = @Content),
            @ApiResponse(responseCode = "405",
                    description = "Estas intentado hacer la petición de GET a otra distinta, ejemplo POST",
                    content = @Content),
            @ApiResponse(responseCode = "400", description = "Estas intentando pasar cuerpo a la petición que no lo requiere", content = @Content),
            @ApiResponse(responseCode = "404", description = "La lista está vacía", content = @Content),
            @ApiResponse(responseCode = "401", description = "No estas logeado", content = @Content)
    })
    @GetMapping("/user")
    @JsonView(viewUser.UserDetailsViewWeb.class)
    public PageResponse<UserResponse> findAllUsers(@RequestParam(value = "s", defaultValue = "") String s,
                                                   @PageableDefault(size = 20, page = 0) Pageable pageable) {
        return userService.findAll(s, pageable);
    }


    @Operation(summary = "Este método banea o quita el ban a un usuario de la aplicación")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "El usuario se ha baneado/desbaneado correctamente",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = viewUser.UserResponse.class),
                            examples = @ExampleObject(value = """
                                    {
                                        "id": "7495ac21-9cef-4655-a816-29a1eee80841",
                                        "username": "alejandro",
                                        "avatar": "alejandro.jpg",
                                        "enabled": true,
                                        "roles": [
                                            "USER"
                                        ]
                                    }
                                    """))}),
            @ApiResponse(responseCode = "404",
                    description = "No se ha encontrado el usuario",
                    content = @Content),
            @ApiResponse(responseCode = "401",
                    description = "No estas logeado",
                    content = @Content),
            @ApiResponse(responseCode = "405",
                    description = "Estas intentado hacer la petición de POST a otra distinta, ejemplo GET",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "No tienes permisos para realizar esta petición",
                    content = @Content)
    })
    @PostMapping("/banUserByAdmin/{id}")
    @JsonView(viewUser.BanUserViewWeb.class)
    public ResponseEntity<UserResponse> banUserById(@Parameter(name = "ID", description = "Se debe proporcionar el id del usuario a banear", allowEmptyValue = true)
                                                    @PathVariable UUID id) {
        return ResponseEntity.status(HttpStatus.CREATED).body(userService.banUser(id));
    }


    @Operation(summary = "Este método añade o elmina el rol de ADMIN a un usuario")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Al usuario se le ha añadido o quitado el rol de ADMIN",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = UserResponse.class),
                            examples = {@ExampleObject(
                                    value = """
                                            [
                                            {
                                                "id": "7495ac21-9cef-4655-a816-29a1eee80841",
                                                "username": "alejandro",
                                                "avatar": "alejandro.jpg",
                                                "enabled": true,
                                                "roles": [
                                                    "USER"
                                                ]
                                            }
                                            ]
                                             """
                            )}
                    )}),
            @ApiResponse(responseCode = "404",
                    description = "No se ha encontrado el usuario",
                    content = @Content),
            @ApiResponse(responseCode = "401",
                    description = "No estas logeado",
                    content = @Content),
            @ApiResponse(responseCode = "405",
                    description = "Estas intentado hacer la petición de Post a otra distinta, ejemplo GET",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "No tienes permisos para realizar esta petición",
                    content = @Content)
    })
    @PostMapping("/changeRole/{id}")
    @JsonView(viewUser.BanUserViewWeb.class)
    public ResponseEntity<UserResponse> addRoleAdminToUser(@Parameter(name = "id",
            description = "Se debe ingresar el ID del usuario a cambiar el rol")
                                                           @PathVariable UUID id) {
        return ResponseEntity.status(HttpStatus.CREATED).body(userService.addAdminRoleToUser(id));
    }


    @Operation(summary = "Este método lo que hace es cambiar tu contraseña")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "{Se ha cambiado la contraseña con éxito}",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = ChangePasswordRequest.class),
                            examples = {@ExampleObject(
                                    value = """
                                            [
                                                {
                                                  "username": "wbeetham0",
                                                  "avatar": "avatar.png",
                                                  "enabled": true,
                                                  "roles": [
                                                      "ADMIN",
                                                      "USER"
                                                  ]
                                                }
                                            ]
                                             """
                            )}
                    )}),
            @ApiResponse(responseCode = "401",
                    description = "No estas logeado",
                    content = @Content),
            @ApiResponse(responseCode = "400",
                    description = "Estas otorgando datos erróneos",
                    content = @Content)
    })
    @PutMapping("/user/changePassword")
    @JsonView(viewUser.UserResponse.class)
    public UserResponse changePassword(@Parameter(name = "ChangePasswordRequest",
            description = "Se debe proporcionar la contraseña antigua y las dos nuevas respectivamente", content = @Content, allowEmptyValue = true)
                                       @Valid @RequestBody ChangePasswordRequest changePasswordRequest, @AuthenticationPrincipal User user) {
        return userService.editPassword(user, changePasswordRequest);
    }


//    @Operation(summary = "Este sirve para logear a un usuario administrador ya creado")
//    @ApiResponses(value = {
//            @ApiResponse(responseCode = "201",
//                    description = "El usuario se ha logeado correctamente y devuelto sus datos",
//                    content = {@Content(mediaType = "application/json",
//                            schema = @Schema(implementation = LoginRequest.class),
//                            examples = {@ExampleObject(
//                                    value = """
//                                            [
//                                            {
//                                                 "id": "d8825758-d02a-4bcc-8146-95fb6fa3ded7",
//                                                 "username": "bmacalester1",
//                                                 "email": "bmacalester1@hotmail.com",
//                                                 "avatar": "avatar.png",
//                                                 "phone": "3011096944",
//                                                 "birthday": "02/04/2002",
//                                                 "myPost": [
//                                                     {
//                                                         "id": 3,
//                                                         "tag": "#CR7",
//                                                         "image": "cr7.jpg",
//                                                         "uploadDate": "22/02/2023",
//                                                         "author": "bmacalester1",
//                                                         "idAuthor": "d8825758-d02a-4bcc-8146-95fb6fa3ded7",
//                                                         "authorFile": "avatar.png",
//                                                         "countLikes": 0,
//                                                         "commentaries": [
//                                                             {
//                                                                 "message": "engineer rich schemas",
//                                                                 "authorName": "cc1692e1-f031-4675-a0b1-96aeeada21aa",
//                                                                 "uploadCommentary": "22/02/2023"
//                                                             },
//                                                             {
//                                                                 "message": "monetize best-of-breed eyeballs",
//                                                                 "authorName": "abb9feac-f0ec-45cf-91a9-5d21c789da2d",
//                                                                 "uploadCommentary": "22/02/2023"
//                                                             },
//                                                             {
//                                                                 "message": "strategize cross-media deliverables",
//                                                                 "authorName": "abb9feac-f0ec-45cf-91a9-5d21c789da2d",
//                                                                 "uploadCommentary": "22/02/2023"
//                                                             }
//                                                         ]
//                                                     }
//                                                 ],
//                                                 "roles": [
//                                                     "ADMIN",
//                                                     "USER"
//                                                 ],
//                                                 "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJkODgyNTc1OC1kMDJhLTRiY2MtODE0Ni05NWZiNmZhM2RlZDciLCJpYXQiOjE2NzcxMDQ2MDYsImV4cCI6MTY3NzcwOTQwNn0.rp4d6AUuMwAZC8gomYwxrEufKr_-_liNuciUo1foFlqcPwBwlHRTp3CNO7ilZtXAEpgK8UuXuqHvFpRCN7Y8_A"
//                                             }
//                                            ]
//                                             """
//                            )}
//                    )}),
//            @ApiResponse(responseCode = "401",
//                    description = "No estas logeado u autenticado",
//                    content = @Content)
//    })
//    @PostMapping("/auth/login/admin")
//    @JsonView(viewUser.UserInfo.class)
//    public ResponseEntity<UserResponse> loginAdmin(@Parameter(name = "Usuario",
//            description = "Se debe proporcionar el usuario y contraseña respectivamente para poder logearse como administrador",
//            allowEmptyValue = true, content = @Content)
//                                                   @RequestBody LoginRequest loginRequest) {
//        Authentication authentication =
//                authManager.authenticate(new UsernamePasswordAuthenticationToken(loginRequest.getUsername(), loginRequest.getPassword()));
//        SecurityContextHolder.getContext().setAuthentication(authentication);
//
//        String token = jwtProvider.generateToken(authentication);
//        User user = (User) authentication.getPrincipal();
//        UserResponse userP = UserResponse.fromUser(user);
//        userP.setToken(token);
//        return ResponseEntity.status(HttpStatus.CREATED).body(userP);
//    }

    @Operation(summary = "Este método lo que hace es cambiar tu avatar")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se ha cambiado el avatar con éxito",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = EditInfoUserRequest.class),
                            examples = {@ExampleObject(
                                    value = """
                                            [
                                                {
                                                    "avatar": "5842fe0ea6515b1e0ad75b3c.png"
                                                }
                                            ]
                                             """
                            )}
                    )}),
            @ApiResponse(responseCode = "401",
                    description = "No estas logeado",
                    content = @Content),
            @ApiResponse(responseCode = "400",
                    description = "No has proporcionado la imagen nueva",
                    content = @Content)
    })
    @PostMapping("/edit/avatar")
    @JsonView(viewUser.editProfile.class)
    public ResponseEntity<EditInfoUserRequest> editProfile(@Parameter(name = "Imagen del nuevo avatar", description = "Se debe proporcionar una imágen para el nuevo avatar")
                                                           @RequestPart("image") MultipartFile image, @AuthenticationPrincipal User user) throws StorageException {

        EditInfoUserRequest newPost = userService.editProfileAvatar(user, image);
        URI createdURI = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(user.getId()).toUri();
        return ResponseEntity
                .created(createdURI)
                .body(newPost);
    }

    @Operation(summary = "Este método lo que hace es editar tu biografía")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se ha cambiado la biografía con éxito",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = EditInfoUserRequest.class),
                            examples = {@ExampleObject(
                                    value = """
                                            [
                                                {
                                                  "descripcion":"este es mi nueva descripcion"
                                                }
                                            ]
                                             """
                            )}
                    )}),
            @ApiResponse(responseCode = "401",
                    description = "No estas logeado",
                    content = @Content),
            @ApiResponse(responseCode = "400",
                    description = "Estas otorgando datos erróneos",
                    content = @Content)
    })
    @PutMapping("/edit/bio")
    @JsonView(viewUser.editProfile.class)
    public EditInfoUserRequest editProfileBio(@Parameter(name = "usuario logeado", description = "Se debe proporcionar el token del usuario logeado")
                                              @AuthenticationPrincipal User user, @Parameter(name = "Cuerpo de la petición", description = "Se debe proporcionar el cuerpo con su respectivo nuevo valor para la descripción")
                                              @RequestBody EditInfoUserRequest request) {
        return userService.editProfileBio(user, request);
    }


    @Operation(summary = "Este método devuelve true en caso de que el usuario logeado siga al usuario pasado el id o false en caso de que no")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se obtiene una respuesta correcta",
                    content = {@Content(mediaType = "application/json",
                            examples = {@ExampleObject(
                                    value = """
                                            true
                                             """
                            )}
                    )}),
            @ApiResponse(responseCode = "401",
                    description = "No estas logeado",
                    content = @Content),
            @ApiResponse(responseCode = "400",
                    description = "El usuario pasado por id no existe",
                    content = @Content)
            , @ApiResponse(responseCode = "403",
            description = "No puedes consultar si te sigues a ti mismo ya que no es posible",
            content = @Content)
    })
    @GetMapping("/state/follow/user/{id}")
    @PreAuthorize("#id != authentication.principal.id")
    public boolean getStateFollowUserByMeFollows(@AuthenticationPrincipal User user, @PathVariable UUID id) {
        return userService.getStateFollowUserByMeFollows(user, id);
    }


    @Operation(summary = "Este método lo que hace es editar tu número de teléfono")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se ha cambiado el número de teléfono con éxito",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = LoginRequest.class),
                            examples = {@ExampleObject(
                                    value = """
                                            [
                                                {
                                                  "phone":"609835694"
                                                }
                                            ]
                                             """
                            )}
                    )}),
            @ApiResponse(responseCode = "401",
                    description = "No estas logeado",
                    content = @Content),
            @ApiResponse(responseCode = "400",
                    description = "Estas otorgando datos erróneos",
                    content = @Content)
    })
    @PutMapping("/edit/phone")
    @JsonView(viewUser.editProfile.class)
    public EditPhoneUserRequest editPhone(@Parameter(name = "usuario logeado", description = "Se debe proporcionar el token del usuario logeado")
                                          @AuthenticationPrincipal User user,
                                          @Parameter(name = "Cuerpo de la petición", description = "Se debe proporcionar el número de teléfono nuevo")
                                          @Valid @RequestBody EditPhoneUserRequest request) {
        return userService.editProfilePhone(user, request);
    }


    @Operation(summary = "Este método lo que hace es editar tu fecha de cumpleaños")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se ha cambiado la fecha de cumpleaños con éxito",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = EditInfoUserRequest.class),
                            examples = {@ExampleObject(
                                    value = """
                                            [
                                                {
                                                  "birthday":"17/12/2001"
                                                }
                                            ]
                                             """
                            )}
                    )}),
            @ApiResponse(responseCode = "401",
                    description = "No estas logeado",
                    content = @Content),
            @ApiResponse(responseCode = "400",
                    description = "Estas otorgando datos erróneos",
                    content = @Content)
    })
    @PutMapping("/edit/birthday")
    @JsonView(viewUser.editProfile.class)
    public EditInfoUserRequest editBirthday(@Parameter(name = "Usuario logeado",
            description = "Se debe proporcionar el token del usuario logeado")
                                            @AuthenticationPrincipal User user,
                                            @Parameter(name = "", description = "")
                                            @Valid
                                            @RequestBody EditInfoUserRequest request) {
        return userService.editProfileBirthday(user, request);
    }

    @Operation(summary = "Este método obtiene todos los datos del usuario logeado, id, nombre,posts, comentarios de posts...")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Sa han devuelto los datos correctamente del usurio logeado",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = UserResponse.class),
                            examples = {@ExampleObject(
                                    value = """
                                            [
                                             {
                                                 "id": "d8825758-d02a-4bcc-8146-95fb6fa3ded7",
                                                 "username": "bmacalester1",
                                                 "createdAt": "22/02/2023 19:36:30",
                                                 "email": "bmacalester1@hotmail.com",
                                                 "avatar": "avatar.png",
                                                 "phone": "3011096944",
                                                 "birthday": "02/04/2002",
                                                 "enabled": true,
                                                 "myPost": [
                                                     {
                                                         "id": 3,
                                                         "tag": "#CR7",
                                                         "image": "cr7.jpg",
                                                         "uploadDate": "22/02/2023",
                                                         "author": "bmacalester1",
                                                         "idAuthor": "d8825758-d02a-4bcc-8146-95fb6fa3ded7",
                                                         "authorFile": "avatar.png",
                                                         "countLikes": 0,
                                                         "commentaries": [
                                                             {
                                                                 "id": 46,
                                                                 "message": "engineer rich schemas",
                                                                 "authorName": "cc1692e1-f031-4675-a0b1-96aeeada21aa",
                                                                 "uploadCommentary": "22/02/2023"
                                                             }
                                                         ]
                                                     },
                                                     {
                                                         "id": 4,
                                                         "tag": "#CR7",
                                                         "image": "cr7.jpg",
                                                         "uploadDate": "22/02/2023",
                                                         "author": "bmacalester1",
                                                         "idAuthor": "d8825758-d02a-4bcc-8146-95fb6fa3ded7",
                                                         "authorFile": "avatar.png",
                                                         "countLikes": 0,
                                                         "commentaries": [
                                                             {
                                                                 "id": 50,
                                                                 "message": "engage 24/7 users",
                                                                 "authorName": "cc1692e1-f031-4675-a0b1-96aeeada21aa",
                                                                 "uploadCommentary": "22/02/2023"
                                                             }
                                                         ]
                                                     }
                                                 ],
                                                 "roles": [
                                                     "USER"
                                                 ],
                                                 "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.
                                                 eyJzdWIiOiJkODgyNTc1OC1kMDJhLTRiY2MtODE0Ni05NWZiNmZhM2RlZDciLCJpYXQiOjE2NzcwOTEwMDgsImV4cCI6MTY3NzY5NTgwOH0.
                                                 XJofqqY6kDfku9wWjK4r4Xfa1wN8QdTsF8_fXn6tDxOlNoCrZueh_6xVry1vybjmUYDvbrdNmHPc6-X_-PDK8g"
                                             }
                                            ]
                                             """
                            )}
                    )}),
            @ApiResponse(responseCode = "403",
                    description = "No puedes acceder a esta petición",
                    content = @Content),
            @ApiResponse(responseCode = "405",
                    description = "Estas intentado hacer la petición de GET a otra distinta, ejemplo POST",
                    content = @Content),
            @ApiResponse(responseCode = "400", description = "Estas intentando pasar cuerpo a la petición", content = @Content)
    })
    @GetMapping("/me")
    public UserResponse getMyProfile(@Parameter(description = "Se pasa el token del usuario logeado", name = "user", required = true, content = @Content)
                                     @AuthenticationPrincipal User user) {
        if (user == null) {
            throw new AccessDeniedException("");
        }
        String token = jwtProvider.generateToken(user);
        Optional<User> u = userService.addPostToUser(user.getUsername());
        UserResponse userResponse = UserResponse.fromUser(u.get());
        userResponse.setToken(token);
        return userResponse;
    }


    @Operation(summary = "Este método trae el perfil con los datos de un usuario")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha obtenido los datos correctamente",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = UserResponse.class),
                            examples = {@ExampleObject(
                                    value = """
                                            [
                                                {
                                                    "id": "51057cde-9852-4cd5-be5e-091979495656",
                                                    "username": "wbeetham0",
                                                    "createdAt": "23/02/2023 19:47:32",
                                                    "email": "wbeetham0@gmail.com",
                                                    "avatar": "avatar.png",
                                                    "biography": "Hi i am a new in that!",
                                                    "phone": "3908006159",
                                                    "birthday": "29/12/2004",
                                                    "enabled": true,
                                                    "myPost": [
                                                        {
                                                            "id": 1,
                                                            "tag": "#CR7",
                                                            "image": "cr7.jpg",
                                                            "uploadDate": "23/02/2023",
                                                            "author": "wbeetham0",
                                                            "idAuthor": "51057cde-9852-4cd5-be5e-091979495656",
                                                            "authorFile": "avatar.png",
                                                            "countLikes": 0,
                                                            "commentaries": [
                                                                {
                                                                    "id": 41,
                                                                    "message": "innovate intuitive models",
                                                                    "authorName": "abb9feac-f0ec-45cf-91a9-5d21c789da2d",
                                                                    "authorFile":"wbeetham0.jpg"
                                                                    "uploadCommentary": "23/02/2023"
                                                                    
                                                                },
                                                                
                                                            ]
                                                        },
                                                        {
                                                            "id": 2,
                                                            "tag": "#CR7",
                                                            "image": "cr7.jpg",
                                                            "uploadDate": "23/02/2023",
                                                            "author": "wbeetham0",
                                                            "idAuthor": "51057cde-9852-4cd5-be5e-091979495656",
                                                            "authorFile": "avatar.png",
                                                            "countLikes": 0,
                                                            "commentaries": [
                                                                {
                                                                    "id": 45,
                                                                    "message": "morph web-enabled initiatives",
                                                                    "authorName": "abb9feac-f0ec-45cf-91a9-5d21c789da2d",
                                                                    "uploadCommentary": "23/02/2023"
                                                                },
                                                                {
                                                                    "id": 70,
                                                                    "message": "harness transparent platforms",
                                                                    "authorName": "cc1692e1-f031-4675-a0b1-96aeeada21aa",
                                                                    "uploadCommentary": "23/02/2023"
                                                                }
                                                            ]
                                                        },
                                                        {
                                                            "id": 11,
                                                            "tag": "#MESSI",
                                                            "image": "messi.jpg",
                                                            "uploadDate": "23/02/2023",
                                                            "author": "wbeetham0",
                                                            "idAuthor": "51057cde-9852-4cd5-be5e-091979495656",
                                                            "authorFile": "avatar.png",
                                                            "countLikes": 0
                                                        },
                                                    ],
                                                    "roles": [
                                                        "ADMIN",
                                                        "USER"
                                                    ],
                                                    "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI1MTA1N2NkZS05ODUyLTRjZDUtYmU1ZS0wOTE5Nzk0OTU2NTYiLCJpYXQiOjE2NzcxNzgwNjAsImV4cCI6MTY3Nzc4Mjg2MH0.5sIXNb0iYbzJveejC_3tFEafTK9vHiUOMF5Bnt5JYDXXNhyLs9aideyfvv8SltTljkHSdTCQ0Zl-wrwt1ww79Q"
                                                }
                                            ]
                                             """
                            )}
                    )}),
            @ApiResponse(responseCode = "401",
                    description = "No estas logeado",
                    content = @Content),
            @ApiResponse(responseCode = "400",
                    description = "Estas otorgando datos erróneos",
                    content = @Content),
            @ApiResponse(responseCode = "404",
                    description = "Usuario no encontrado",
                    content = @Content)
    })
    @JsonView(viewUser.UserInfo.class)
    @GetMapping("/info/user/{id}")
    public UserResponse getInfoUser(@Parameter(name = "ID", description = "Id del usuario a tener info")
                                    @PathVariable UUID id,
                                    @AuthenticationPrincipal User user) {
        return userService.findByIdInfoUser(id);
    }


    @Operation(summary = "Este método obtiene una lista de los 3 últimos comentarios realizados por un usuario determinado")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha obtenido la lista correctamente",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = CommentaryResponse.class),
                            examples = @ExampleObject(value = """
                                    {
                                        [
                                            {
                                                "id": 49,
                                                "message": "Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.",
                                                "authorName": "marta",
                                                "authorFile": "marta.jpg",
                                                "uploadCommentary": "23/04/2023"
                                            },
                                            {
                                                "id": 50,
                                                "message": "Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.",
                                                "authorName": "marta",
                                                "authorFile": "marta.jpg",
                                                "uploadCommentary": "23/04/2023"
                                            },
                                            {
                                                "id": 51,
                                                "message": "Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.",
                                                "authorName": "marta",
                                                "authorFile": "marta.jpg",
                                                "uploadCommentary": "23/04/2023"
                                            }
                                        ]
                                    }
                                    """))}),
            @ApiResponse(responseCode = "401",
                    description = "No estas logeado",
                    content = @Content),
            @ApiResponse(responseCode = "405",
                    description = "Estas intentado hacer la petición de POST a otra distinta, ejemplo GET",
                    content = @Content),
            @ApiResponse(responseCode = "404",
                    description = "El id del usuario al que quieres ver los comentarios recientes no existe",
                    content = @Content),
            @ApiResponse(responseCode = "404",
                    description = "El usuario no ha realizado ningún comentario aún ",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "No tienes permiso para realizar esta petición"),
    })

    @GetMapping("/user/list/comments/{id}")
    @JsonView(viewCommentary.CommentaryResponse.class)
    public List<CommentaryResponse> getLastThreeCommentariesByUser(@PathVariable("id") String id) {
        return userService.getLast3CommentariesOfUser(id);
    }

    @Operation(summary = "Este método obtiene una lista con la cantidad de usuarios baneados y no baneados")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha obtenido la lista correctamente",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = IUserResponseEnabled.class),
                            examples = @ExampleObject(value = """
                                    {
                                        [
                                            {
                                                "state": "active",
                                                "value":5
                                            },
                                            {
                                                "state": "inactive/ban",
                                                "value":5
                                            },
                                        ]
                                    }
                                    """))}),
            @ApiResponse(responseCode = "401",
                    description = "No estas logeado",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "No tienes permiso para realizar esta petición",
                    content = @Content),
            @ApiResponse(responseCode = "405",
                    description = "Estas intentado hacer la petición de POST a otra distinta, ejemplo GET",
                    content = @Content),
            @ApiResponse(responseCode = "404",
                    description = "No hay usuarios en la base de datos",
                    content = @Content)
    })
    @GetMapping("/user/list/state/now")
    public List<IUserResponseEnabled> getAllUserState() {
        return userService.getAllUserState();
    }


    @Operation(summary = "Este método obtiene una lista de los meses en la que se ha creado la cuenta de usuarios por el año que indiquemos")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha obtenido la lista correctamente",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = IUserResponseCreated.class),
                            examples = @ExampleObject(value = """
                                    {
                                        [
                                            {
                                                "month": 4,
                                                "total":10
                                            }
                                        ]
                                    }
                                    """))}),
            @ApiResponse(responseCode = "401",
                    description = "No estas logeado",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "No tienes permiso para realizar esta petición",
                    content = @Content),
            @ApiResponse(responseCode = "405",
                    description = "Estas intentado hacer la petición de POST a otra distinta, ejemplo GET",
                    content = @Content),
            @ApiResponse(responseCode = "404",
                    description = "No hay usuarios en la base de datos",
                    content = @Content)
    })
    @GetMapping("/user/create/year/{year}")
    public List<IUserResponseCreated> getListUsersByYear(@PathVariable("year") int year) {
        return userService.getListUsersByYear(year);
    }


}