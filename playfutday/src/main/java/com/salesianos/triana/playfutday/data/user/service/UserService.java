package com.salesianos.triana.playfutday.data.user.service;


import com.salesianos.triana.playfutday.data.files.exception.StorageException;
import com.salesianos.triana.playfutday.data.files.service.FileSystemStorageService;
import com.salesianos.triana.playfutday.data.post.dto.PostResponse;
import com.salesianos.triana.playfutday.data.post.model.Post;
import com.salesianos.triana.playfutday.data.post.repository.PostRepository;
import com.salesianos.triana.playfutday.data.post.service.PostService;
import com.salesianos.triana.playfutday.data.user.dto.*;
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
import com.sun.tools.jconsole.JConsolePlugin;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.naming.AuthenticationException;
import javax.transaction.Transactional;
import java.time.LocalDateTime;
import java.util.EnumSet;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserService {

    private final PasswordEncoder passwordEncoder;
    private final UserRepository userRepository;
    private final PostRepository postRepository;

    private final PostService postService;

    private final FileSystemStorageService storageService;


    public User createUser(UserRequest createUserRequest, EnumSet<UserRole> roles) {
        User user = User.builder()
                .username(createUserRequest.getUsername())
                .avatar("avatar.png")
                .email(createUserRequest.getEmail())
                .password(passwordEncoder.encode(createUserRequest.getPassword()))
                .phone(createUserRequest.getPhone())
                .roles(roles)
                .build();
        return userRepository.save(user);
    }

    @Transactional
    public EditInfoUserRequest editProfileAvatar(User user, MultipartFile image) throws StorageException {
        String filename = storageService.store(image);
        user.setAvatar(filename);
        userRepository.save(user);
        return EditInfoUserRequest.builder()
                .avatar(filename)
                .build();
    }

    public EditInfoUserRequest editProfileBio(User user, EditInfoUserRequest request) {
        user.setBiography(request.getBiography());
        userRepository.save(user);
        return EditInfoUserRequest.builder()
                .biography(user.getBiography())
                .build();
    }


    public EditPhoneUserRequest editProfilePhone(User user, EditPhoneUserRequest request) {
        user.setPhone(request.getPhone());
        userRepository.save(user);
        return EditPhoneUserRequest.builder()
                .phone(user.getPhone())
                .build();
    }

    public EditInfoUserRequest editProfileBirthday(User user, EditInfoUserRequest request) {
        user.setBirthday(request.getBirthday());
        userRepository.save(user);
        return EditInfoUserRequest.builder()
                .birthday(request.getBirthday())
                .build();
    }

    public void deleteUser(UUID idU) {
        userRepository.findById(idU)
                .map(
                        oldUser -> {
                            List<Post> myLikes = postRepository.findOnIlikePost(oldUser.getId());
                            for (Post p : myLikes) {
                                postService.giveLikeByUser(p.getId(), oldUser);
                            }
                            userRepository.delete(oldUser);
                            return null;
                        }
                );
    }

    public User createUserWithUserRole(UserRequest createUserRequest) {
        return createUser(createUserRequest, EnumSet.of(UserRole.USER));
    }


    public PageResponse<UserResponse> findAll(String s, Pageable pageable) {
        List<SearchCriteria> params = SearchCriteriaExtractor.extractSearchCriteriaList(s);
        PageResponse<UserResponse> res = search(params, pageable);
        if (res.getContent().isEmpty()) {
            throw new GlobalEntityListNotFounException("In this page the list of users is empty");
        }
        return res;
    }

    public PageResponse<UserResponse> search(List<SearchCriteria> params, Pageable pageable) {
        GenericSpecificationBuilder genericSpecificationBuilder = new GenericSpecificationBuilder(params);
        Specification<User> spec = genericSpecificationBuilder.build();
        Page<UserResponse> userResponsePage = userRepository.findAll(spec, pageable).map(UserResponse::fromUser);
        return new PageResponse<>(userResponsePage);
    }


    public PageResponse<PostResponse> findMyFavPost(User user, Pageable pageable) {
        PageResponse<PostResponse> res = pageablePost(pageable, user);
        if (res.getContent().isEmpty()) {
            throw new GlobalEntityListNotFounException("The list of post is empty");
        }
        return res;
    }


    public PageResponse<PostResponse> pageablePost(Pageable pageable, User user) {
        Page<Post> postListFav = postRepository.findAllPostFavUser(user.getId(), pageable);
        Page<PostResponse> postResponsePage =
                new PageImpl<>
                        (postListFav.stream().toList(), pageable, postListFav.getTotalPages()).map(PostResponse::of);
        return new PageResponse<>(postResponsePage);
    }


    public UserResponse banUser(UUID id) {
        return userRepository.findById(id).map(oldUser -> {
            oldUser.setEnabled(!oldUser.isEnabled());
            return UserResponse.fromUser(
                    userRepository.save(oldUser)
            );
        }).orElseThrow(() -> new GlobalEntityNotFounException("Not found a user"));


    }

    public UserResponse addAdminRoleToUser(UUID id) {

        return userRepository.findById(id).map(old -> {
            if (old.getRoles().contains(UserRole.ADMIN)) {
                old.getRoles().remove(UserRole.ADMIN);
            } else {
                old.getRoles().add(UserRole.ADMIN);
            }
            userRepository.save(old);
            return UserResponse.fromUser(old);
        }).orElseThrow(() -> new GlobalEntityNotFounException("Not found a user"));
    }


    public Optional<User> findByUsername(String username) {
        return userRepository.findFirstByUsername(username);
    }

    public UserResponse editPassword(User user, ChangePasswordRequest changePasswordRequest) {
        if (passwordEncoder.matches(changePasswordRequest.getOldPassword(), user.getPassword())) {
            user.setPassword(passwordEncoder.encode(changePasswordRequest.getNewPassword()));
            user.setLastPasswordChangeAt(LocalDateTime.now());
            return UserResponse.fromUser(userRepository.save(user));
        }
        throw new NotPermission();
    }

    public boolean passwordMatch(User user, String clearPassword) {
        return passwordEncoder.matches(clearPassword, user.getPassword());
    }


    public boolean userExistsEmail(String s) {
        return userRepository.existsByEmailIgnoreCase(s);
    }

    public boolean userPhoneUnique(String s) {
        return userRepository.existsByPhoneIgnoreCase(s);
    }


    public Optional<User> findById(UUID id) {
        return userRepository.findById(id);
    }

    @Transactional()
    public Optional<User> addPostToUser(String username) {
        return userRepository.findByUsername(username);
    }

    public UserResponse findByIdInfoUser(UUID id) {
        return UserResponse.fromUser(userRepository.findById(id).orElseThrow(() -> new GlobalEntityNotFounException("User not found")));
    }


    public PageResponse<UserFollow> pageableUser(UUID id, Pageable pageable) {
        Page<User> followersOfOneUser = userRepository.findAllFollowers(id, pageable);
        Page<UserFollow> userFollowPage =
                new PageImpl<>
                        (followersOfOneUser.stream().toList(), pageable, followersOfOneUser.getTotalPages()).map(UserFollow::of);
        return new PageResponse<>(userFollowPage);
    }


    public PageResponse<UserFollow> getFollowers(UUID id, Pageable pageable) {
        userRepository.findById(id).orElseThrow(() -> new GlobalEntityNotFounException("The user not exists"));
        PageResponse<UserFollow> res = pageableUser(id, pageable);
        if (res.getContent().isEmpty()) {
            throw new GlobalEntityNotFounException("The list of followers is empty");
        }
        return res;
    }

    /**
     * PAGINACION AHORA DE LOS FOLLOWS
     *
     * @param id       id del usuario que vamos a obtener su lista
     * @param pageable Page
     */


    public PageResponse<UserFollow> pageableUserFollow(UUID id, Pageable pageable) {
        Page<User> followsOfOneUser = userRepository.findAllFollows(id, pageable);
        Page<UserFollow> userFollowPage =
                new PageImpl<>
                        (followsOfOneUser.stream().toList(), pageable, followsOfOneUser.getTotalPages()).map(UserFollow::of);
        return new PageResponse<>(userFollowPage);
    }


    public PageResponse<UserFollow> getFollows(UUID id, Pageable pageable) {
        userRepository.findById(id).orElseThrow(() -> new GlobalEntityNotFounException("The user not exists"));
        PageResponse<UserFollow> res = pageableUserFollow(id, pageable);
        if (res.getContent().isEmpty()) {
            throw new GlobalEntityNotFounException("The list of follows is empty");
        }
        return res;
    }

    public UserFollow updateFollowers(User user, UUID id) {
        return userRepository.findById(id)
                .map(userDestination -> {
                    boolean exists = userRepository.existsUserByFollow(user.getId(), id);
                    /**
                     * Siempre se va a encontrar el usuario ya que se requiere de Login y en el otro caso antes de entrar
                     * aqui se lanzará la excepción, por ello orElseThrow esta vacío.
                     */
                    User act = userRepository.findByPhone(user.getPhone()).orElseThrow();
                    User des = userRepository.findByEmail(userDestination.getEmail()).orElseThrow();

                    if (!exists) {
                        act.getFollows().add(des);
                        des.getFollowers().add(act);
                    } else {
                        act.getFollows().remove(des);
                        des.getFollowers().remove(act);
                    }
                    userRepository.save(des);
                    userRepository.save(act);

                    return UserFollow.of(userDestination);
                })
                .orElseThrow(() -> new GlobalEntityNotFounException("The user not found"));
    }

}
