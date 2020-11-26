package com.psi.todo.controller;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.util.UriComponentsBuilder;

import com.psi.todo.dto.TodoDeleteRequest;
import com.psi.todo.dto.TodoRequest;
import com.psi.todo.dto.TodoResource;
import com.psi.todo.entity.Todo;
import com.psi.todo.exception.TodoException;
import com.psi.todo.service.ITodoService;
import com.psi.todo.validator.ValidationSequence;

import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import io.swagger.annotations.ResponseHeader;

@Validated(ValidationSequence.class)
@RestController
@RequestMapping(value = { "/todo" })
public class TodoController {

    private ITodoService todoService;

    public TodoController(ITodoService todoService) {
        this.todoService = todoService;
    }

    @ApiOperation(value = "View Todo by provide id", response = Todo.class, produces = MediaType.APPLICATION_JSON_VALUE)
    @ApiResponses(value = { @ApiResponse(code = 200, message = "Retrieved todo successfully"),
            @ApiResponse(code = 400, message = "Todo record doesn't exist", response = TodoException.class), })
    @ApiResponse(code = 401, message = "Unauthorized")
    @GetMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Todo> getTodoById(@Validated(ValidationSequence.class) TodoRequest todoRequest) {
        Optional<Todo> todo = todoService.findById(todoRequest.getId());
        return todo.isPresent() ? new ResponseEntity<Todo>(todo.get(), HttpStatus.OK)
                : new ResponseEntity<Todo>(HttpStatus.NOT_FOUND);
    }

    @ApiOperation(value = "Create Todo", response = Todo.class, responseHeaders = {
            @ResponseHeader(name = "Location", description = "Location of created todo") })
    @ApiResponses(value = {
            @ApiResponse(code = 201, message = "Todo successfully created", responseHeaders = {
                    @ResponseHeader(name = "Location", description = "Location of created todo") }),
            @ApiResponse(code = 401, message = "Unauthorized") })
    @PostMapping(headers = "Accept=application/json")
    public ResponseEntity<Todo> createTodo(@RequestBody @Validated(ValidationSequence.class) TodoResource todo,
            UriComponentsBuilder ucBuilder) {
        HttpHeaders headers = new HttpHeaders();
        Todo todoCreated = todoService.create(todo);
        headers.setLocation(ucBuilder.path("/todo/{id}").buildAndExpand(todoCreated.getId()).toUri());
        return new ResponseEntity<Todo>(todoCreated, headers, HttpStatus.CREATED);
    }

    @ApiOperation(value = "View all Todos", response = List.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Retrieved all todos", response = Todo.class, responseContainer = "List"),
            @ApiResponse(code = 401, message = "Unauthorized") })
    @GetMapping(headers = "Accept=application/json")
    public List<Todo> getAllTodo() {
        return StreamSupport.stream(todoService.findAll().spliterator(), false).collect(Collectors.toList());
    }

    @ApiOperation(value = "Update Todo", response = Todo.class)
    @ApiResponses(value = { @ApiResponse(code = 200, message = "Todo successfully updated", response = Todo.class),
            @ApiResponse(code = 400, message = "Todo record doesn't exist", response = TodoException.class),
            @ApiResponse(code = 401, message = "Unauthorized") })
    @PutMapping(value = "/{id}", headers = "Accept=application/json")
    public ResponseEntity<Todo> updateTodo(@RequestBody @Validated(ValidationSequence.class) TodoResource todo,
            @Validated(ValidationSequence.class) TodoRequest todoRequest) {
        return new ResponseEntity<Todo>(todoService.update(todo, todoRequest.getId()), HttpStatus.OK);
    }

    @ApiOperation(value = "Delete Todo by provide id")
    @ApiResponses(value = { @ApiResponse(code = 204, message = "Todo successfully deleted", response = Void.class),
            @ApiResponse(code = 400, message = "Todo record doesn't exist", response = TodoException.class),
            @ApiResponse(code = 401, message = "Unauthorized"),
            @ApiResponse(code = 500, message = "No Todo with id exists!", response = TodoException.class) })
    @ResponseStatus(HttpStatus.NO_CONTENT)
    @DeleteMapping(value = "/{id}", headers = "Accept=application/json")
    public ResponseEntity<?> deleteTodo(@Validated(ValidationSequence.class) TodoDeleteRequest todoRequest) {
        todoService.delete(todoRequest.getId());
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }

}