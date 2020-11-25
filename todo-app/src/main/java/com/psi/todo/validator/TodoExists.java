package com.psi.todo.validator;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import javax.validation.Constraint;
import javax.validation.Payload;
import static java.lang.annotation.ElementType.*;

@Constraint(validatedBy = TodoExistsValidator.class)
@Target({ METHOD, FIELD, ANNOTATION_TYPE, CONSTRUCTOR, PARAMETER, TYPE_USE })
@Retention(RetentionPolicy.RUNTIME)
public @interface TodoExists {
    
    String message() default "Todo record doesn't exist";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

}
