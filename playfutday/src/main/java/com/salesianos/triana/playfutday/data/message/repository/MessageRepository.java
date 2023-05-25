package com.salesianos.triana.playfutday.data.message.repository;

import com.salesianos.triana.playfutday.data.message.model.Message;
import com.salesianos.triana.playfutday.data.user.model.User;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface MessageRepository extends JpaRepository<Message, Long>, JpaSpecificationExecutor<Message> {


    @Query("SELECT m FROM Message m WHERE m.chat.id = :chatId")
    List<Message> findAllMessagesByChatId(@Param("chatId") Long chatId);


}