package com.salesianos.triana.playfutday.data.chat.model;


import com.fasterxml.jackson.annotation.JsonFormat;
import com.salesianos.triana.playfutday.data.message.model.Message;
import com.salesianos.triana.playfutday.data.user.model.User;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
@Table(name = "chat_entity")
@Data
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
@EntityListeners(AuditingEntityListener.class)
public class Chat implements Serializable {

    @Id
    @GeneratedValue()
    private Long id;

    //**A CONFIGURAR MÁS TARDE DEPENDIENDO DE LA POLÍTICA DE BORRADO DESEADA */ @ManyToMany(fetch = FetchType.LAZY, cascade = CascadeType.PERSIST)
//    @ManyToMany(fetch = FetchType.LAZY)
//    @JoinTable(
//            name = "chat_members",
//            joinColumns = @JoinColumn(name = "chat_id"),
//            inverseJoinColumns = @JoinColumn(name = "user_id")
//    )
//    private Set<User> members = new HashSet<>();

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "user_chats",
            joinColumns = @JoinColumn(name = "chat_id"),
            inverseJoinColumns = @JoinColumn(name = "user_id")
    )
    private Set<User> members;
    /**
     * CREO QUE DEBE SER LIST NO HASHSET, YA QUE AL BORRAR LA CUENTA DEL USUARIO, LOS MENSAJES DE ESTE EL USUARIO NO APARECERÁ Y SE PONDRÁ EN NULL
     */

    //** A CONFIGURAR MÁS TARDE DEPENDIENDO DE LA POLÍTICA DE BORRADO DESEADA */ @OneToMany(mappedBy = "chat", cascade = CascadeType.ALL, orphanRemoval = true)
    // @Order ORDENAMOS DIRECTAMENTE LA LISTA DE LOS ULTIMOS MENSAJES ENVIADOS
    @OneToMany(mappedBy = "chat")
    private List<Message> messages;

    /**
     * ORDENAR LOS CHATS DE LOS ÚLTIMOS CREADOS
     */
    @CreatedDate
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy HH:mm:ss")
    private LocalDateTime createdChat = LocalDateTime.now();


}