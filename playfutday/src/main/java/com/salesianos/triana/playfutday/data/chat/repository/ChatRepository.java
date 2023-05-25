package com.salesianos.triana.playfutday.data.chat.repository;

import com.salesianos.triana.playfutday.data.chat.model.Chat;
import com.salesianos.triana.playfutday.data.user.model.User;
import io.swagger.v3.oas.annotations.Parameter;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;
import java.util.UUID;

public interface ChatRepository extends JpaRepository<Chat, Long>, JpaSpecificationExecutor<Chat> {


    /*
    @Query("""
            SELECT c From Chat c JOIN c.members WHERE 
            """)
    Optional<Chat> getChatIfExistsByUsers(@Parameter UUID idUserWhoSendMessage,
                                          @Parameter UUID idUserWhoReceiveMessage);
     */

    @Query("""
            SELECT c FROM Chat c JOIN c.members m1 JOIN c.members m2 WHERE (m1.id = :userId1 AND m2.id = :userId2) OR (m1.id = :userId2 AND m2.id = :userId1)
            """)
    Chat findChatByUserIds(@Param("userId1") UUID userId1, @Param("userId2") UUID userId2);





}