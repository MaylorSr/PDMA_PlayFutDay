package com.salesianos.triana.playfutday.validation.annotation;

import com.salesianos.triana.playfutday.validation.validator.UniqueUserNameValidator;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.*;

@Target({ElementType.METHOD, ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = UniqueUserNameValidator.class)
@Documented
public @interface UniqueUserName {
    String message() default "The username of the user exist";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
