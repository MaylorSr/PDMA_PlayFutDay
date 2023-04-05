package com.salesianos.triana.playfutday.data.user.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonView;
import com.salesianos.triana.playfutday.data.interfaces.user.viewUser;
import com.salesianos.triana.playfutday.data.user.model.User;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class UserFollow {
    @JsonView({viewUser.UserFollow.class})
    protected UUID id;
    @JsonView({viewUser.UserFollow.class})
    protected String username;
    @JsonView({viewUser.UserFollow.class})
    protected String avatar;

    public static UserFollow of(User user) {
        return UserFollow.builder()
                .id(user.getId())
                .username(user.getUsername())
                .avatar(user.getAvatar())
                .build();
    }

}
