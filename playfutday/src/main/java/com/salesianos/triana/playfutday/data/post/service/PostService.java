package com.salesianos.triana.playfutday.data.post.service;

import com.salesianos.triana.playfutday.data.commentary.dto.CommentaryRequest;
import com.salesianos.triana.playfutday.data.commentary.dto.CommentaryResponse;
import com.salesianos.triana.playfutday.data.commentary.model.Commentary;
import com.salesianos.triana.playfutday.data.commentary.repository.CommentaryRepository;
import com.salesianos.triana.playfutday.data.files.service.FileSystemStorageService;
import com.salesianos.triana.playfutday.data.post.dto.PostRequest;
import com.salesianos.triana.playfutday.data.post.dto.PostResponse;
import com.salesianos.triana.playfutday.data.post.model.Post;
import com.salesianos.triana.playfutday.data.post.repository.PostRepository;
import com.salesianos.triana.playfutday.data.user.model.User;
import com.salesianos.triana.playfutday.data.user.model.UserRole;
import com.salesianos.triana.playfutday.data.user.repository.UserRepository;
import com.salesianos.triana.playfutday.exception.GlobalEntityListNotFounException;
import com.salesianos.triana.playfutday.exception.GlobalEntityNotFounException;
import com.salesianos.triana.playfutday.exception.NotPermission;
import com.salesianos.triana.playfutday.search.page.PageResponse;
import com.salesianos.triana.playfutday.search.spec.GenericSpecificationBuilder;
import com.salesianos.triana.playfutday.search.util.SearchCriteria;
import com.salesianos.triana.playfutday.search.util.SearchCriteriaExtractor;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.data.domain.*;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.transaction.Transactional;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PostService {
    private final PostRepository repo;
    private final CommentaryRepository repoCommentary;

    private final UserRepository userRepository;

    private final FileSystemStorageService storageService;

    @Autowired
    private MessageSource messageSource;


    public PostResponse findDetailsPostById(Long id) {
        return PostResponse.of(repo.findById(id).orElseThrow(
                () -> new GlobalEntityNotFounException(
                        messageSource.getMessage("exception.post.notExists.id", null, LocaleContextHolder.getLocale())
                )
        ));
    }

    public List<PostResponse> findAllPostGridByUserName(String username) {
        return userRepository.findFirstByUsername(username)
                .map(user -> {
                    if (user.getMyPost() == null) {
                        throw new GlobalEntityListNotFounException(messageSource.getMessage("exception.user.noPost", null, LocaleContextHolder.getLocale()));
                    }

                    List<Post> sortedPosts = user.getMyPost().stream()
                            .sorted(Comparator.comparing(Post::getUploadDate).reversed())
                            .collect(Collectors.toList());

                    return sortedPosts.stream().map(PostResponse::of).toList();
                })
                .orElseThrow(() -> new GlobalEntityNotFounException(messageSource.getMessage("exception.user.notExists", null, LocaleContextHolder.getLocale())));
    }



    public PageResponse<CommentaryResponse> pageableCommentary(Long id, Pageable pageable) {
        Page<Commentary> commentariesOfOnePostById = repo.findAllCommentariesByPostId(id, pageable);
        Page<CommentaryResponse> commentaryResponsePage =
                new PageImpl<>
                        (commentariesOfOnePostById.stream().toList(), pageable, commentariesOfOnePostById.getTotalPages()).map(CommentaryResponse::of);
        return new PageResponse<>(commentaryResponsePage);
    }

    public PageResponse<CommentaryResponse> findCommentariesByPostId(Pageable pageable, Long id) {
        Post post = repo.findById(id).orElseThrow(() -> new GlobalEntityNotFounException(
                        messageSource.getMessage("exception.post.notExists.id", null, LocaleContextHolder.getLocale())
                )
        );

        PageResponse<CommentaryResponse> res = pageableCommentary(post.getId(), pageable);
        if (res.getContent().isEmpty()) {
            throw new GlobalEntityNotFounException(
                    messageSource.getMessage("exception.post.notExists.comments", null, LocaleContextHolder.getLocale())
            );
        } else {
            return res;
        }
    }

    public PageResponse<CommentaryResponse> pageableAllCommentary(Pageable pageable) {
        Page<Commentary> listCommentaries = repoCommentary.findAll(pageable);

        Page<CommentaryResponse> commentaryResponsePage =
                new PageImpl<>
                        (listCommentaries.stream().toList(), pageable, repoCommentary.findAll().size()).map(CommentaryResponse::of);
        return new PageResponse<>(commentaryResponsePage);
    }

    public PageResponse<CommentaryResponse> findAllCommentaries(Pageable pageable) {
        PageResponse<CommentaryResponse> res = pageableAllCommentary(pageable);
        if (res.getContent().isEmpty()) {
            throw new GlobalEntityNotFounException(
                    messageSource.getMessage("exception.post.notExists.comments", null, LocaleContextHolder.getLocale())
            );
        } else {
            return res;
        }
    }


    public PageResponse<PostResponse> findAllPostByUserName(String username, Pageable pageable) {
        userRepository.findFirstByUsername(username).orElseThrow(() -> new GlobalEntityListNotFounException(
                messageSource.getMessage("exception.user.notExists", null, LocaleContextHolder.getLocale())));
        PageResponse<PostResponse> res = pageablePost(username, pageable);
        if (res.getContent().isEmpty()) {
            throw new GlobalEntityListNotFounException(
                    messageSource.getMessage("exception.post.isEmpty", null, LocaleContextHolder.getLocale())
            );
        }
        return res;
    }

    public PageResponse<PostResponse> pageablePost(String username, Pageable pageable) {
        Page<Post> postOfOneUserByUserName = repo.findAllPostOfOneUserByUserName(username, pageable);

        Page<PostResponse> postResponsePage = new PageImpl<>
                (postOfOneUserByUserName.stream().toList(), pageable, postOfOneUserByUserName.getTotalPages()).map(PostResponse::of);
        return new PageResponse<>(postResponsePage);
    }


    public PageResponse<PostResponse> findAllPost(String s, Pageable pageable) {
        List<SearchCriteria> params = SearchCriteriaExtractor.extractSearchCriteriaList(s);

        Sort sort = Sort.by(Sort.Direction.DESC, "uploadDate");
        Pageable pageableWithSort = PageRequest.of(pageable.getPageNumber(), pageable.getPageSize(), sort);

        PageResponse<PostResponse> res = search(params, pageableWithSort);

        if (res.getContent().isEmpty()) {
            throw new GlobalEntityListNotFounException(
                    messageSource.getMessage("exception.post.isEmpty", null, LocaleContextHolder.getLocale())
            );
        }

        return res;
    }


    public PageResponse<PostResponse> search(List<SearchCriteria> params, Pageable pageable) {
        GenericSpecificationBuilder genericSpecificationBuilder = new GenericSpecificationBuilder(params);
        Specification<Post> spec = genericSpecificationBuilder.build();
//        Page<PostResponse> postResponsePage = repo.findAll(spec, pageable).map(PostResponse::of);
        Sort sort = Sort.by(Sort.Direction.DESC, "uploadDate");
        Page<PostResponse> postResponsePage = repo.findAll(spec, PageRequest.of(pageable.getPageNumber(), pageable.getPageSize(), sort)).map(PostResponse::of);
        return new PageResponse<>(postResponsePage);
    }

    public PostResponse createPostByUser(PostRequest postRequest, MultipartFile image, User user) {
        String filename = storageService.store(image);

        return PostResponse.of(
                repo.save(Post.builder()
                        .tag(postRequest.getTag())
                        .image(filename)
                        .author(user)
                        .description(postRequest.getDescription())
                        .build())
        );
    }


    public PostResponse giveCommentByUser(Long id, User user, CommentaryRequest request) {
        return repo.findById(id).map(
                post -> {
                    post.getCommentaries().add(
                            Commentary.builder()
                                    .message(request.getMessage())
                                    .post(post)
                                    .author(user.getUsername())
                                    .id_author(user.getId().toString())
                                    .authorFile(user.getAvatar())
                                    /**
                                     * Se explica en la entidad comentary el porque el LocalDate.now
                                     */
                                    .updateCommentary(LocalDate.now())
                                    .build());
                    repo.save(post);
                    return PostResponse.of(post);
                }
        ).orElseThrow(() -> new GlobalEntityNotFounException(
                        messageSource.getMessage("exception.post.notExists.id", null, LocaleContextHolder.getLocale())
                )
        );
    }


    public int getTotalPostOfMonth(int month) {
        if (month == 0) {
            return repo.getTotalPost();
        } else if (month > 12 || month < 0) {
            throw new GlobalEntityNotFounException(
                    messageSource.getMessage("exception.post.select.month", null, LocaleContextHolder.getLocale())
            );
        }
        return repo.getTotalPostByMonth(month);
    }


    public PostResponse giveLikeByUser(Long id, User user) {
        return repo.findById(id).map(
                post -> {
                    List<User> likes = post.getLikes();
                    boolean exists = repo.existsLikeByUser(id, user.getId());
                    if (!exists) {
                        User userToAdd = userRepository.findById(user.getId()).orElseThrow(() -> new GlobalEntityNotFounException(""));
                        likes.add(userToAdd);
                    } else {
                        User userToRemove = userRepository.findById(user.getId()).orElseThrow(() -> new GlobalEntityNotFounException(""));
                        likes.removeIf(u -> u.getId().equals(userToRemove.getId()));
                        repo.save(post);
                    }
                    return PostResponse.of(repo.save(post));
                }
        ).orElseThrow(() -> new GlobalEntityNotFounException(
                        messageSource.getMessage("exception.post.notExists.id", null, LocaleContextHolder.getLocale())
                )
        );
    }


    /**
     * Metodo que se encarga de eliminar el post de un usuario, es necesario devolver un booleano para que no continue y devuelva la excepción,
     * ya que al borrarlo intenta seguir buscando y devolvera la excepción "GlobalEntityNotFound"
     *
     * @param id  Es el id del post que vamos a eliminar
     * @param idU Es el id del usuario en cuestion al que se le va a eliminar el post
     * @return Devolverá un booleano en caso de que la ejecución haya sido completada y con exito sin ningún tipo de excepción.
     */
    public boolean deletePostByUser(Long id, UUID idU) {
        repo.findById(id)
                .map(
                        oldPost -> {
                            return userRepository.findById(idU)
                                    .map(
                                            user -> {
                                                user.getMyPost().remove(oldPost);
                                                try {
                                                    storageService.deleteFile(oldPost.getImage());
                                                } catch (Exception ex) {
                                                }

                                                repo.delete(oldPost);
                                                userRepository.save(user);
                                                return true;
                                            }
                                    )
                                    .orElseThrow(() -> new GlobalEntityNotFounException(
                                            messageSource.getMessage("exception.post.notExists.in.user.id", null, LocaleContextHolder.getLocale())
                                    ));
                        }
                )
                .orElseThrow(() -> new GlobalEntityNotFounException(
                        messageSource.getMessage("exception.post.notExists.id", null, LocaleContextHolder.getLocale())
                ));
        return false;
    }

    public UUID findIdOfUserPost(Long id) {
        return repo.findById(id)
                .map(
                        uuid -> {
                            return repo.findIdOfUserPost(id);
                        }
                )
                .orElseThrow(() -> new GlobalEntityNotFounException(
                        messageSource.getMessage("exception.post.user.notExists", null, LocaleContextHolder.getLocale())
                ));
    }

    public void deleteCommentary(Long id) {
        Commentary commentaryOptional = repoCommentary
                .findById(id)
                .orElseThrow(() -> new GlobalEntityNotFounException(
                        messageSource.getMessage("exception.comment.notExists.id", null, LocaleContextHolder.getLocale())
                ));
        repoCommentary.delete(commentaryOptional);
    }


}
