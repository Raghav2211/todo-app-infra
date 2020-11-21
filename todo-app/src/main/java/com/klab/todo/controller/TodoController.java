package com.klab.todo.controller;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

import javax.validation.constraints.NotBlank;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.util.UriComponentsBuilder;

import com.klab.todo.entity.Todo;
import com.klab.todo.exception.TodoException;
import com.klab.todo.service.ITodoService;

import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import io.swagger.annotations.ResponseHeader;

@RestController
@RequestMapping(value = { "/todo" })
public class TodoController {

    private ITodoService todoService;

    public TodoController(ITodoService todoService) {
        this.todoService = todoService;
    }

    @ApiOperation(value = "View Todo by provide id", response = Todo.class, produces = MediaType.APPLICATION_JSON_VALUE)
    @ApiResponses(value = { @ApiResponse(code = 200, message = "Retrieved todo successfully"),
            @ApiResponse(code = 404, message = "Todo is not found") })
    @GetMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Todo> getTodoById(@PathVariable("id") Long id) {
        Optional<Todo> todo = todoService.findById(id);
        return todo.isPresent() ? new ResponseEntity<Todo>(todo.get(), HttpStatus.OK)
                : new ResponseEntity<Todo>(HttpStatus.NOT_FOUND);
    }

    @ApiOperation(value = "Create Todo", response = Todo.class, responseHeaders = {
            @ResponseHeader(name = "Location", description = "Location of created todo") })
    @ApiResponses(value = { @ApiResponse(code = 201, message = "Todo successfully created", responseHeaders = {
            @ResponseHeader(name = "Location", description = "Location of created todo") }) })
    @PostMapping(headers = "Accept=application/json")
    public ResponseEntity<Todo> createTodo(@RequestBody Todo todo, UriComponentsBuilder ucBuilder) {
        HttpHeaders headers = new HttpHeaders();
        headers.setLocation(ucBuilder.path("/todo/{id}").buildAndExpand(todo.getId()).toUri());
        return new ResponseEntity<Todo>(todoService.create(todo), headers, HttpStatus.CREATED);
    }

    @ApiOperation(value = "View all Todos", response = List.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Retrieved all todos", response = Todo.class, responseContainer = "List") })
    @GetMapping(headers = "Accept=application/json")
    public List<Todo> getAllTodo() {
        return StreamSupport.stream(todoService.findAll().spliterator(), false).collect(Collectors.toList());
    }

    @ApiOperation(value = "Update Todo", response = Todo.class)
    @ApiResponses(value = { @ApiResponse(code = 200, message = "Todo successfully updated", response = Todo.class),
            @ApiResponse(code = 404, message = "Todo record Id doesn't exist", response = TodoException.class) })
    @PutMapping(headers = "Accept=application/json")
    public ResponseEntity<Todo> updateTodo(@RequestBody Todo todo) {
        return new ResponseEntity<Todo>(todoService.update(todo), HttpStatus.OK);
    }

    @ApiOperation(value = "Delete Todo by provide id", response = Todo.class)
    @ApiResponses(value = { @ApiResponse(code = 204, message = "Todo successfully deleted"),
            @ApiResponse(code = 404, message = "Todo record doesn't exist", response = TodoException.class) })
    @ResponseStatus(HttpStatus.NO_CONTENT)
    @DeleteMapping(value = "/{id}", headers = "Accept=application/json")
    public ResponseEntity<Todo> deleteTodo(@PathVariable("id") @NotBlank(message = "Id should be non null") Long id) {
        return new ResponseEntity<Todo>(todoService.delete(id).get(), HttpStatus.NO_CONTENT);
    }

}