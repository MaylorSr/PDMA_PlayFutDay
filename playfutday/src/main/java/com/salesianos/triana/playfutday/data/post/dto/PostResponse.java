package com.salesianos.triana.playfutday.data.post.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonView;
import com.salesianos.triana.playfutday.data.commentary.dto.CommentaryResponse;
import com.salesianos.triana.playfutday.data.interfaces.post.viewPost;
import com.salesianos.triana.playfutday.data.interfaces.user.viewUser;
import com.salesianos.triana.playfutday.data.post.model.Post;
import com.salesianos.triana.playfutday.data.post.repository.PostRepository;
import com.salesianos.triana.playfutday.data.user.dto.UserResponse;
import com.salesianos.triana.playfutday.data.user.model.User;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class PostResponse {

    private static PostRepository postRepository;

    @JsonView({viewPost.PostResponse.class})
    protected Long id;
    @JsonView({viewPost.PostResponse.class})

    protected String tag;
    @JsonView({viewPost.PostResponse.class})

    protected String description;
    @JsonView({viewPost.PostResponse.class, viewUser.UserInfo.class})

    protected String image;
    @JsonView({viewPost.PostResponse.class})
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy")
    protected LocalDateTime uploadDate;
    @JsonView({viewPost.PostResponse.class})
    protected String author;
    @JsonView({viewPost.PostResponse.class})

    protected UUID idAuthor;
    @JsonView({viewPost.PostViewMobile.class, viewPost.PostDetailsAngular.class})
    protected String authorFile;
    @JsonView({viewPost.PostViewMobile.class, viewPost.PostViewMobileLike.class})
    protected List<String> likesByAuthor;
    @JsonView({viewPost.PostViewMobile.class, viewPost.PostViewMobileLike.class, viewPost.PostDetailsAngular.class})
    protected int countLikes;
    @JsonView({viewPost.PostDetailsAngular.class})

    protected int countCommentaries;

    @JsonView({viewPost.PostViewMobile.class})
    protected List<CommentaryResponse> commentaries;

    public static PostResponse of(Post post) {
        return PostResponse.builder()
                .id(post.getId())
                .tag('#' + post.getTag())
                .description(post.getDescription())
                .image(post.getImage())
                .uploadDate(post.getUploadDate())
                .idAuthor(post.getAuthor().getId())
                .author(post.getAuthor().getUsername())
                .authorFile(post.getAuthor().getAvatar())
                .likesByAuthor(post.getLikes() == null ? null : post.getLikes().stream().map(User::getUsername).toList())
                .countLikes(post.getLikes() == null ? 0 : post.getLikes().size())
                .commentaries(post.getCommentaries() == null ? null : post.getCommentaries().stream().map(CommentaryResponse::of).toList())
                .countCommentaries(post.getCommentaries() == null ? 0 : post.getCommentaries().size())
                .build();
    }

}
