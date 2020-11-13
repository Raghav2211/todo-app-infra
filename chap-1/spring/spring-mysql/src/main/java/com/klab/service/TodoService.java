package com.klab.service;

import java.util.Optional;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.klab.entity.Todo;
import com.klab.repository.TodoRepository;

@Service
@Transactional
public class TodoService implements ITodoService {

    private TodoRepository todoRepository;

    public TodoService(TodoRepository todoRepository) {
        this.todoRepository = todoRepository;
    }

    public void create(Todo todo) {
        todoRepository.save(todo);
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
