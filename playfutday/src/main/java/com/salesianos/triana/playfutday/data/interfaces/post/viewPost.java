package com.salesianos.triana.playfutday.data.interfaces.post;

public interface viewPost {
    static class PostResponse {
    }

    /**
     * VISTA MÓVIL
     **/
    static class PostViewMobile extends PostResponse {

    }

    static class PostViewMobileLike extends PostResponse {

    }


    /**
     * VISTA WEB
     */
    static class PostDetailsAngular extends PostResponse {

    }


}
