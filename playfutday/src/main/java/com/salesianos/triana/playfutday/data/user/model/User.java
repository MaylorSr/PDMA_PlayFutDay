package com.salesianos.triana.playfutday.data.user.model;

import ch.qos.logback.core.boolex.EvaluationException;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.salesianos.triana.playfutday.data.chat.model.Chat;
import com.salesianos.triana.playfutday.data.post.model.Post;
import com.salesianos.triana.playfutday.data.user.database.EnumSetUserRoleConverter;
import jdk.jfr.Name;
import lombok.*;
import org.hibernate.annotations.GenericGenerator;
import org.hibernate.annotations.NaturalId;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;


@Entity
@Table(name = "user_entity")
@EntityListeners(AuditingEntityListener.class)
//@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@NamedEntityGraph(
        name = "user_with_posts",
        attributeNodes = @NamedAttributeNode(value = "myPost")
)
@NamedEntityGraph(
        name = "user_with_follows",
        attributeNodes = @NamedAttributeNode(value = "follows"))

@NamedEntityGraph(
        name = "user_with_followers",
        attributeNodes = @NamedAttributeNode(value = "followers"))

@NamedEntityGraph(
        name = "user_with_chats"
        ,attributeNodes = @NamedAttributeNode(value = "myChats")
)
public class User implements UserDetails {
    @Id
    @GeneratedValue(generator = "UUID")
    @GenericGenerator(
            name = "UUID",
            strategy = "org.hibernate.id.UUIDGenerator",
            parameters = {
                    @org.hibernate.annotations.Parameter(
                            name = "uuid_gen_strategy_class",
                            value = "org.hibernate.id.uuid.CustomVersionOneStrategy"
                    )
            }
    )
    @Column(columnDefinition = "uuid")
    private UUID id;
    @NaturalId
    @Column(unique = true, updatable = false)
    private String username;

    private String email;
    private String password;

    private String avatar;

    private String biography;

    private String phone;

    @OneToMany(mappedBy = "author", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<Post> myPost = new ArrayList<>();

//    @OneToMany(mappedBy = "members", cascade = CascadeType.ALL, orphanRemoval = true)
//    @Builder.Default
//    private List<Chat> myChats = new ArrayList<>();

    @ManyToMany(fetch = FetchType.LAZY, cascade = CascadeType.MERGE)
    @JoinTable(
            name = "user_chats",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "chat_id")
    )
    @Builder.Default
    private Set<Chat> myChats = new HashSet<>();

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy")
    private LocalDate birthday;

    /**
     * Con esto evitamos que se cree una tabla adicional en H2, ya que followers usará la de follows
     */
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "user_follows",
            joinColumns = @JoinColumn(name = "user_id_followed"),
            inverseJoinColumns = @JoinColumn(name = "follower_user_id"))
    @Builder.Default
    private List<User> follows = new ArrayList<>();

    @ManyToMany(mappedBy = "follows")
    @Builder.Default
    private List<User> followers = new ArrayList<>();


    @Builder.Default
    private boolean accountNonExpired = true;
    @Builder.Default
    private boolean accountNonLocked = true;
    @Builder.Default
    private boolean credentialsNonExpired = true;

    @Builder.Default
    private boolean enabled = true;

    @Convert(converter = EnumSetUserRoleConverter.class)
    private Set<UserRole> roles;

    @CreatedDate
    private LocalDateTime createdAt;

    @Builder.Default
    private LocalDateTime lastPasswordChangeAt = LocalDateTime.now();


    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return roles.stream()
                .map(role -> "ROLE_" + role)
                .map(SimpleGrantedAuthority::new)
                .collect(Collectors.toList());
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return username;
    }

    @Override
    public boolean isAccountNonExpired() {
        return accountNonExpired;
    }

    @Override
    public boolean isAccountNonLocked() {
        return accountNonLocked;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return credentialsNonExpired;
    }

    @Override
    public boolean isEnabled() {
        return enabled;
    }

    /**
     * QUITAMOS AL USUARIO DE TODAS LAS LISTAS RELACIONADAS CON ESTE
     */
    @PreRemove
    public void deleteUser() {
        this.follows.forEach(f -> {
            f.followers.remove(this);
        });
        this.followers.forEach(f -> {
            f.follows.remove(this);
        });
    }

}
