package com.salesianos.triana.playfutday.data.interfaces.user;

import com.salesianos.triana.playfutday.data.interfaces.post.viewPost;
import com.salesianos.triana.playfutday.data.user.model.User;

public interface viewUser {

    static class UserResponse {

    }

    static class UserDetailsViewWeb extends UserResponse {

    }

    static class BanUserViewWeb extends UserResponse {
    }


    static class UserInfo extends UserResponse {

    }

    static class UserFollow {


    }

    static class UserDetailsByAdmin extends UserResponse {

    }


    static class editProfile {

    }


}
