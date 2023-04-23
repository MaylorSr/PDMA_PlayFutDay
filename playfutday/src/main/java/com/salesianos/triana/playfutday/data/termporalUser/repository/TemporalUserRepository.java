package com.salesianos.triana.playfutday.data.termporalUser.repository;

import com.salesianos.triana.playfutday.data.termporalUser.model.TemporalUser;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;


public interface TemporalUserRepository extends JpaRepository<TemporalUser, Long> {

    TemporalUser findByUsername(String username);


    Optional<TemporalUser> findByCode(String code);


}
