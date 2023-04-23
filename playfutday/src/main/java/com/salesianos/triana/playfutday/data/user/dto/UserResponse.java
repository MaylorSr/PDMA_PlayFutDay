package com.salesianos.triana.playfutday.data.user.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonView;
import com.salesianos.triana.playfutday.data.interfaces.user.viewUser;
import com.salesianos.triana.playfutday.data.post.dto.PostResponse;
import com.salesianos.triana.playfutday.data.user.model.User;
import com.salesianos.triana.playfutday.data.user.model.UserRole;
import com.salesianos.triana.playfutday.security.jwt.access.JwtProvider;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class UserResponse {

    @JsonView({viewUser.UserResponse.class})
    protected UUID id;
    @JsonView({viewUser.UserResponse.class, viewUser.editProfile.class})

    protected String username;
    @JsonView({viewUser.UserDetailsViewWeb.class})

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy")
    protected LocalDateTime createdAt;
    @JsonView({viewUser.editProfile.class, viewUser.UserInfo.class})

    protected String email;
    @JsonView({viewUser.UserResponse.class, viewUser.editProfile.class})

    protected String avatar;
    @JsonView({viewUser.editProfile.class, viewUser.UserInfo.class})

    protected String biography;
    @JsonView({viewUser.editProfile.class, viewUser.UserInfo.class})

    protected String phone;
    @JsonView({viewUser.editProfile.class, viewUser.UserInfo.class})

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy")
    protected LocalDate birthday;
    @JsonView({viewUser.UserDetailsViewWeb.class, viewUser.BanUserViewWeb.class})

    protected boolean enabled;
    protected List<PostResponse> myPost;
    @JsonView({viewUser.UserResponse.class, viewUser.BanUserViewWeb.class})

    protected Set<UserRole> roles;

    @JsonView({viewUser.UserResponse.class})
    protected String token;


    public static UserResponse fromUser(User user) {
        return UserResponse
                .builder()
                .id(user.getId())
                .username(user.getUsername())
                .email(user.getEmail())
                .avatar(user.getAvatar())
                .biography(user.getBiography())
                .birthday(user.getBirthday())
                .phone(user.getPhone())
                .createdAt(user.getCreatedAt())
                .enabled(user.isEnabled())
                .myPost(user.getMyPost().isEmpty() ? null : user.getMyPost().stream().map(PostResponse::of).toList())
                .roles(user.getRoles())
                .token("")
                .build();
    }


}
