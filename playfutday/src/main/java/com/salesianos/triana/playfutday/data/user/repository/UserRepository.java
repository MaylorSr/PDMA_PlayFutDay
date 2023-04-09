package com.salesianos.triana.playfutday.data.user.repository;

import com.salesianos.triana.playfutday.data.post.model.Post;
import com.salesianos.triana.playfutday.data.user.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface UserRepository extends JpaRepository<User, UUID>, JpaSpecificationExecutor<User> {

    Optional<User> findFirstByUsername(String username);


    @EntityGraph(value = "user_with_posts", type = EntityGraph.EntityGraphType.FETCH)
    Optional<User> findByUsername(String username);

    @EntityGraph(value = "user_with_follows", type = EntityGraph.EntityGraphType.FETCH)
    Optional<User> findByPhone(String phone);

    @EntityGraph(value = "user_with_followers", type = EntityGraph.EntityGraphType.FETCH)
    Optional<User> findByEmail(String email);

    /**
     * Se pretende que devuelva true o false en caso de que el usuario que le da al follow ya se encuentra dentro de la lista de seguidores del usuario
     * destinatario
     *
     * @param user_log_id es el id del usuario que da el follow
     * @param userId      es el id del usuario que va a recibir el follow.
     * @return devuelve true en caso de que ya se encuentre dentro y false en caso de que no se encuentre adentro de la lista.
     */
    @Query("SELECT CASE WHEN COUNT(u) > 0 THEN true ELSE false END FROM User u JOIN u.follows f WHERE u.id = :user_log_id AND f.id = :userId")
    boolean existsUserByFollow(@Param("user_log_id") UUID user_log_id, @Param("userId") UUID userId);

    boolean existsByEmailIgnoreCase(String s);
    boolean existsByUsernameIgnoreCase(String s);

    boolean existsByPhoneIgnoreCase(String s);

    /**
     * Obtiene los followers del id del usuario pasado en cuestion
     *
     * @param id       id del usuario que seguido
     * @param pageable Los trae por paginación
     */
    @Query("SELECT f FROM User u JOIN u.followers f WHERE u.id = :id")
    Page<User> findAllFollowers(@Param("id") UUID id, Pageable pageable);

    /**
     * Obtiene los follows del id del usuario pasado en cuestion
     *
     * @param id       id del usuario que seguido
     * @param pageable Los trae por paginación
     */

    @Query("""
            SELECT f FROM User u JOIN u.follows f WHERE u.id = :id
            """)
    Page<User> findAllFollows(@Param("id") UUID id, Pageable pageable);


    @Query("""
            SELECT u FROM User u JOIN u.follows f WHERE f.id = :id 
            """)
    List<User> findWhoFollowsMe(@Param("id") UUID id);

}

