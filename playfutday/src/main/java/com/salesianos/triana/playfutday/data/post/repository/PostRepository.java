package com.salesianos.triana.playfutday.data.post.repository;

import com.salesianos.triana.playfutday.data.commentary.model.Commentary;
import com.salesianos.triana.playfutday.data.post.model.Post;
import com.salesianos.triana.playfutday.data.user.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.UUID;

public interface PostRepository extends JpaRepository<Post, Long>, JpaSpecificationExecutor<Post> {

    @Query("""
            SELECT p FROM Post p JOIN User u ON (p.author.id  = u.id) where u.username =:username order by p.uploadDate desc
            """)
    Page<Post> findAllPostOfOneUserByUserName(@Param("username") String username, Pageable pageable);

    @Query("""
            SELECT p.author.id FROM Post p where p.id = :postId
            """)
    UUID findIdOfUserPost(@Param("postId") Long postId);

    @Query("SELECT CASE WHEN COUNT(p) > 0 THEN true ELSE false END FROM Post p JOIN p.likes l WHERE p.id = :postId AND l.id = :userId")
    boolean existsLikeByUser(@Param("postId") Long postId, @Param("userId") UUID userId);

    @Query("""
            SELECT p FROM Post p JOIN p.likes l WHERE l.id =:id order by p.uploadDate desc
            """)
    Page<Post> findAllPostFavUser(@Param("id") UUID id, Pageable pageable);

    @Query("""
            SELECT p FROM Post p JOIN p.likes l WHERE l.id =:id
            """)
    List<Post> findOnIlikePost(@Param("id") UUID id);

    @Query("""
            SELECT c FROM Post p JOIN p.commentaries c WHERE p.id =:id
            """)
    Page<Commentary> findAllCommentariesByPostId(@Param("id") Long id, Pageable pageable);

//    @Query("""
//            SELECT c FROM Commentary c order by c.updateCommentary asc
//            """)
//    Page<Commentary> findAllCommentaries(Pageable pageable);


    @Query("""
            SELECT COUNT(p) FROM Post p  WHERE EXTRACT(MONTH FROM p.uploadDate) = :month        
            """)
    int getTotalPostByMonth(@Param("month") int month);


    @Query("""
            SELECT COUNT(p) FROM Post p
            """)
    int getTotalPost();

}




