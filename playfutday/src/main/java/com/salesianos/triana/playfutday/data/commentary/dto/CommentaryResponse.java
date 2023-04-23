package com.salesianos.triana.playfutday.data.commentary.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonView;
import com.salesianos.triana.playfutday.data.commentary.model.Commentary;
import com.salesianos.triana.playfutday.data.interfaces.commentary.viewCommentary;
import com.salesianos.triana.playfutday.data.interfaces.post.viewPost;
import com.salesianos.triana.playfutday.data.interfaces.user.viewUser;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class CommentaryResponse {

    @JsonView({viewPost.PostDetailsAngular.class, viewCommentary.CommentaryResponse.class})
    private Long id;

    @JsonView({viewPost.PostViewMobile.class, viewPost.PostDetailsAngular.class, viewCommentary.CommentaryResponse.class})
    protected String message;

    @JsonView({viewPost.PostDetailsAngular.class})
    protected String id_author;

    @JsonView({viewPost.PostViewMobile.class, viewPost.PostDetailsAngular.class, viewCommentary.CommentaryResponse.class})
    protected String authorName;
    @JsonView({viewPost.PostDetailsAngular.class})
    protected Long post_id;

    @JsonView({viewPost.PostViewMobile.class, viewCommentary.CommentaryResponse.class})
    protected String authorFile;

    @JsonView({viewPost.PostViewMobile.class, viewPost.PostDetailsAngular.class, viewCommentary.CommentaryResponse.class})
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy")
    protected LocalDate uploadCommentary;

    public static CommentaryResponse of(Commentary commentary) {
        return CommentaryResponse.builder()
                .id(commentary.getId())
                .message(commentary.getMessage())
                .id_author(commentary.getId_author())
                .authorName(commentary.getAuthor())
                .post_id(commentary.getPost().getId())
                .authorFile(commentary.getAuthorFile())
                .uploadCommentary(commentary.getUpdateCommentary())
                .build();
    }


}
