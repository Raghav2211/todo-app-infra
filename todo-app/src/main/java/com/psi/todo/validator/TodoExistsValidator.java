package com.psi.todo.validator;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

import org.springframework.stereotype.Component;

import com.psi.todo.repository.TodoRepository;

@Component
public class TodoExistsValidator implements ConstraintValidator<TodoExists, Long> {

    private TodoRepository todoRepository;

    public TodoExistsValidator(TodoRepository todoRepository) {
        this.todoRepository = todoRepository;
    }

    public boolean isValid(Long id, ConstraintValidatorContext context) {
        return isTodoPresent(id);
    }

    private boolean isTodoPresent(Long id) {
        return todoRepository.findById(id).isPresent();
    }
}
