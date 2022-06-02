package com.psi.todo.validator;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

import org.springframework.stereotype.Component;

import com.psi.todo.service.ITodoService;

@Component
public class TodoExistsValidator implements ConstraintValidator<TodoExists, Long> {

    private ITodoService todoService;

    public TodoExistsValidator(ITodoService todoService) {
        this.todoService = todoService;
    }

    public boolean isValid(Long id, ConstraintValidatorContext context) {
        return isTodoPresent(id);
    }

    private boolean isTodoPresent(Long id) {
        return todoService.findById(id).isPresent();
    }
}
