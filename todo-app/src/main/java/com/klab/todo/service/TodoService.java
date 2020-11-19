package com.klab.todo.service;

import java.util.Optional;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.klab.todo.entity.Todo;
import com.klab.todo.repository.TodoRepository;

@Service
@Transactional
public class TodoService implements ITodoService {

    private TodoRepository todoRepository;

    public TodoService(TodoRepository todoRepository) {
        this.todoRepository = todoRepository;
    }

    public Todo create(Todo todo) {
        return todoRepository.save(todo);
    }

    public Todo update(Todo todo) {
        return todoRepository.save(todo);
    }

    public Optional<Todo> findById(long id) {
        return todoRepository.findById(id);
    }

    public Iterable<Todo> findAll() {
        return todoRepository.findAll();
    }

    public void delete(long id) {
        todoRepository.deleteById(id);
    }
}
