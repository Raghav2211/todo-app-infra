package com.klab.todo.service;

import java.util.Optional;

import javax.persistence.PersistenceException;

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

        if(null == todo.getId())
            throw new PersistenceException(String.format("Todo record to update is without id"));
        Optional<Todo> optTodo = todoRepository.findById(todo.getId());
        if (!optTodo.isPresent()) {
            throw new PersistenceException(String.format("Todo record Id %s doesn't exist", todo.getId()));
        }

        return todoRepository.save(todo);
    }

    public Optional<Todo> findById(long id) {
        return todoRepository.findById(id);
    }

    public Iterable<Todo> findAll() {
        return todoRepository.findAll();
    }

    public Optional<Todo> delete(long id) {
        Optional<Todo> optTodo = todoRepository.findById(id);
        if (!optTodo.isPresent()) {
            throw new PersistenceException("Todo record doesn't exist");
        }
        todoRepository.deleteById(id);
        return optTodo;
    }
}
