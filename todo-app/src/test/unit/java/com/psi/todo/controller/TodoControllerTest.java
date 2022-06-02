package com.psi.todo.controller;

import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

import org.hamcrest.Matchers;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.psi.todo.dto.TodoResource;
import com.psi.todo.entity.Todo;
import com.psi.todo.service.ITodoService;
import com.psi.todo.validator.TodoExistsValidator;

import lombok.SneakyThrows;

@SpringBootTest(classes = { TodoController.class, TodoExistsValidator.class })
@AutoConfigureMockMvc(addFilters = false)
@EnableWebMvc
public class TodoControllerTest {

    private static final String TOOD_ID_MUST_BE_GRATER_THAN_0 = "Tood id must be grater than 0";

    private static final String CONTENT_NOT_SPECIFIED = "Content not specified";

    private static final String TODO_RECORD_DOESN_T_EXIST = "Todo record doesn't exist";

    private static final String TODO_ROOT = "/api/v1/todo";

    private static final String TODO_FINDBY_NULL = "/api/v1/todo/null";

    private static final String TODO_FINDBY_ID = "/api/v1/todo/1";

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private ITodoService todoService;

    private static Todo todoResponse;
    private static TodoResource todoRequest;
    private static TodoResource todoInvalidRequest;

    @BeforeAll
    @SneakyThrows({ JsonParseException.class, JsonMappingException.class, IOException.class })
    public static void beforeClass() {
        File resposeFile = new File("src/test/resources/data/todoResponse.json");
        todoResponse = new ObjectMapper().readValue(resposeFile, Todo.class);
        File requestFile = new File("src/test/resources/data/todoRequest.json");
        todoRequest = new ObjectMapper().readValue(requestFile, TodoResource.class);
        File invalidRequestFile = new File("src/test/resources/data/todoInvalidRequest.json");
        todoInvalidRequest = new ObjectMapper().readValue(invalidRequestFile, TodoResource.class);

    }

    @SneakyThrows
    @Test
    public void testGetTodoById() {

        Mockito.when(todoService.findById(1l)).thenReturn(Optional.of(todoResponse));
        MediaType MEDIA_TYPE_JSON_UTF8 = MediaType.APPLICATION_JSON;
        mockMvc.perform(MockMvcRequestBuilders.get(TODO_FINDBY_ID).accept(MEDIA_TYPE_JSON_UTF8))
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers.content().json(new ObjectMapper().writeValueAsString(todoResponse)));
        Mockito.verify(todoService, Mockito.times(2)).findById(1l);
        Mockito.verifyNoMoreInteractions(todoService);
    }

    @SneakyThrows
    @Test
    public void testGetTodoByIdNotFound() {
        Mockito.when(todoService.findById(1l)).thenReturn(Optional.empty());
        MediaType MEDIA_TYPE_JSON_UTF8 = MediaType.APPLICATION_JSON;
        String error = mockMvc.perform(MockMvcRequestBuilders.get(TODO_FINDBY_ID).accept(MEDIA_TYPE_JSON_UTF8))
                .andExpect(MockMvcResultMatchers.status().isBadRequest()).andReturn().getResolvedException()
                .getMessage();
        assertTrue(error.contains(TODO_RECORD_DOESN_T_EXIST));
        Mockito.verify(todoService).findById(1l);
        Mockito.verifyNoMoreInteractions(todoService);
    }

    @SneakyThrows
    @Test
    public void testGetTodoByNullId() {
        MediaType MEDIA_TYPE_JSON_UTF8 = MediaType.APPLICATION_JSON;
        String error = mockMvc.perform(MockMvcRequestBuilders.get(TODO_FINDBY_NULL).accept(MEDIA_TYPE_JSON_UTF8))
                .andExpect(MockMvcResultMatchers.status().isBadRequest()).andReturn().getResolvedException()
                .getMessage();
        assertTrue(error.contains("NumberFormatException"));
        Mockito.verifyNoMoreInteractions(todoService);
    }

    @SneakyThrows
    @Test
    public void testGetAllTodo() {
        Mockito.when(todoService.findAll()).thenReturn(List.of(todoResponse));
        MediaType MEDIA_TYPE_JSON_UTF8 = MediaType.APPLICATION_JSON;
        mockMvc.perform(MockMvcRequestBuilders.get(TODO_ROOT).accept(MEDIA_TYPE_JSON_UTF8))
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers.jsonPath("$", Matchers.hasSize(1)))
                .andExpect(MockMvcResultMatchers.jsonPath("$.[0].id", Matchers.is(1)));
        Mockito.verify(todoService).findAll();
        Mockito.verifyNoMoreInteractions(todoService);
    }

    @SneakyThrows
    @Test
    public void testCreateTodo() {
        Mockito.when(todoService.create(todoRequest)).thenReturn(todoResponse);
        MediaType MEDIA_TYPE_JSON_UTF8 = MediaType.APPLICATION_JSON;
        mockMvc.perform(
                MockMvcRequestBuilders.post(TODO_ROOT).content(new ObjectMapper().writeValueAsString(todoRequest))
                        .contentType(MEDIA_TYPE_JSON_UTF8).accept(MEDIA_TYPE_JSON_UTF8))
                .andExpect(MockMvcResultMatchers.status().isCreated())
                .andExpect(MockMvcResultMatchers.jsonPath("$.id", Matchers.is(1)));
        Mockito.verify(todoService).create(todoRequest);
        Mockito.verifyNoMoreInteractions(todoService);
    }

    @SneakyThrows
    @Test
    public void testCreateWithInvalidTodo() {
        MediaType MEDIA_TYPE_JSON_UTF8 = MediaType.APPLICATION_JSON;
        String error = mockMvc
                .perform(MockMvcRequestBuilders.post(TODO_ROOT)
                        .content(new ObjectMapper().writeValueAsString(todoInvalidRequest))
                        .contentType(MEDIA_TYPE_JSON_UTF8).accept(MEDIA_TYPE_JSON_UTF8))
                .andExpect(MockMvcResultMatchers.status().isBadRequest()).andReturn().getResolvedException()
                .getMessage();
        assertTrue(error.contains(CONTENT_NOT_SPECIFIED));
        Mockito.verifyNoMoreInteractions(todoService);
    }

    @SneakyThrows
    @Test
    public void testUpdateTodo() {
        Mockito.when(todoService.update(todoRequest, 1l)).thenReturn(todoResponse);
        Mockito.when(todoService.findById(1l)).thenReturn(Optional.of(todoResponse));
        MediaType MEDIA_TYPE_JSON_UTF8 = MediaType.APPLICATION_JSON;
        mockMvc.perform(
                MockMvcRequestBuilders.put(TODO_FINDBY_ID).content(new ObjectMapper().writeValueAsString(todoRequest))
                        .contentType(MEDIA_TYPE_JSON_UTF8).accept(MEDIA_TYPE_JSON_UTF8))
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers.jsonPath("$.id", Matchers.is(1)))
                .andExpect(MockMvcResultMatchers.jsonPath("$.content", Matchers.is("Update Error content")));
        Mockito.verify(todoService).update(todoRequest, 1l);
        Mockito.verify(todoService).findById(1l);
        Mockito.verifyNoMoreInteractions(todoService);
    }

    @SneakyThrows
    @Test
    public void testUpdateNonExistTodo() {
        Mockito.when(todoService.findById(1l)).thenReturn(Optional.empty());
        MediaType MEDIA_TYPE_JSON_UTF8 = MediaType.APPLICATION_JSON;
        String error = mockMvc
                .perform(MockMvcRequestBuilders.put(TODO_FINDBY_ID)
                        .content(new ObjectMapper().writeValueAsString(todoRequest)).contentType(MEDIA_TYPE_JSON_UTF8)
                        .accept(MEDIA_TYPE_JSON_UTF8))
                .andExpect(MockMvcResultMatchers.status().isBadRequest()).andReturn().getResolvedException()
                .getMessage();
        assertTrue(error.contains(TODO_RECORD_DOESN_T_EXIST));
        Mockito.verify(todoService).findById(1l);
        Mockito.verifyNoMoreInteractions(todoService);
    }

    @SneakyThrows
    @Test
    public void testUpdateNegativeIdTodo() {
        Mockito.when(todoService.findById(-1l)).thenReturn(Optional.empty());
        MediaType MEDIA_TYPE_JSON_UTF8 = MediaType.APPLICATION_JSON;
        String error = mockMvc
                .perform(MockMvcRequestBuilders.put(TODO_FINDBY_ID)
                        .content(new ObjectMapper().writeValueAsString(todoRequest)).contentType(MEDIA_TYPE_JSON_UTF8)
                        .accept(MEDIA_TYPE_JSON_UTF8))
                .andExpect(MockMvcResultMatchers.status().isBadRequest()).andReturn().getResolvedException()
                .getMessage();
        assertTrue(error.contains(TODO_RECORD_DOESN_T_EXIST));
        Mockito.verify(todoService).findById(1l);
        Mockito.verifyNoMoreInteractions(todoService);
    }

    @SneakyThrows
    @Test
    public void testDeleteTodo() {
        Mockito.doNothing().when(todoService).delete(1l);
        MediaType MEDIA_TYPE_JSON_UTF8 = MediaType.APPLICATION_JSON;
        mockMvc.perform(MockMvcRequestBuilders.delete(TODO_FINDBY_ID).accept(MEDIA_TYPE_JSON_UTF8))
                .andExpect(MockMvcResultMatchers.status().isNoContent());
        Mockito.verify(todoService).delete(1l);
        Mockito.verifyNoMoreInteractions(todoService);
    }

    @SneakyThrows
    @Test
    public void testDeleteWithNegativeTodoId() {
        MediaType MEDIA_TYPE_JSON_UTF8 = MediaType.APPLICATION_JSON;
        String error = mockMvc.perform(MockMvcRequestBuilders.delete("/api/v1/todo/-1").accept(MEDIA_TYPE_JSON_UTF8))
                .andExpect(MockMvcResultMatchers.status().isBadRequest()).andReturn().getResolvedException()
                .getMessage();
        assertTrue(error.contains(TOOD_ID_MUST_BE_GRATER_THAN_0));
        Mockito.verifyNoMoreInteractions(todoService);

    }

}
