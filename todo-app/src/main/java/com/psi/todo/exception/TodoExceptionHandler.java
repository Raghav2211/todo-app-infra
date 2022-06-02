package com.psi.todo.exception;

import javax.persistence.PersistenceException;
import javax.servlet.http.HttpServletRequest;

import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.TransactionException;
import org.springframework.validation.BindException;
import org.springframework.web.bind.ServletRequestBindingException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

import com.psi.todo.entity.Todo;

@ControllerAdvice
@RestController
public class TodoExceptionHandler extends ResponseEntityExceptionHandler {

    private static final String MY_SQL_UNAVAILABLE = "MySQL Unavailable..";

    @ExceptionHandler(Exception.class)
    @ResponseStatus(value = HttpStatus.INTERNAL_SERVER_ERROR)
    public @ResponseBody TodoException handleException(final Exception exception, final HttpServletRequest request) {
        TodoException error = new TodoException();
        error.setMessage(exception.getMessage());
        error.setCode(HttpStatus.INTERNAL_SERVER_ERROR.value());
        return error;
    }
    @ExceptionHandler(EmptyResultDataAccessException.class)
    @ResponseStatus(value = HttpStatus.INTERNAL_SERVER_ERROR)
    public @ResponseBody TodoException handleDataAaccessException(final Exception exception, final HttpServletRequest request) {
        TodoException error = new TodoException();
        error.setMessage(exception.getMessage().replace("class "+Todo.class.getName()+ " entity", "Todo"));
        error.setCode(HttpStatus.INTERNAL_SERVER_ERROR.value());
        return error;
    }
    

    @ExceptionHandler(TransactionException.class)
    @ResponseStatus(value = HttpStatus.INTERNAL_SERVER_ERROR)
    public @ResponseBody TodoException handleConnectionException(final Exception exception,
            final HttpServletRequest request) {

        TodoException error = new TodoException();
        error.setMessage(MY_SQL_UNAVAILABLE);
        error.setCode(HttpStatus.INTERNAL_SERVER_ERROR.value());

        return error;
    }

    @ExceptionHandler(PersistenceException.class)
    @ResponseStatus(value = HttpStatus.NOT_FOUND)
    public @ResponseBody TodoException handlePersistence(final Exception exception, final HttpServletRequest request) {

        TodoException error = new TodoException();
        error.setMessage(exception.getMessage());
        error.setCode(HttpStatus.NOT_FOUND.value());

        return error;
    }

    @Override
    protected ResponseEntity<Object> handleBindException(BindException ex, HttpHeaders headers, HttpStatus status,
            WebRequest request) {
        var bindingResult = ex.getBindingResult();
        var fieldErrors = bindingResult.getFieldErrors();
        TodoException error = new TodoException();
        error.setMessage(fieldErrors.get(0).getDefaultMessage().contains("null") ? "Tood id must not be null"
                : fieldErrors.get(0).getDefaultMessage());
        error.setCode(HttpStatus.BAD_REQUEST.value());
        return new ResponseEntity<>(error, HttpStatus.BAD_REQUEST);
    }

    @Override
    protected ResponseEntity<Object> handleServletRequestBindingException(ServletRequestBindingException ex,
            HttpHeaders headers, HttpStatus status, WebRequest request) {
        TodoException error = new TodoException();
        error.setMessage(ex.getLocalizedMessage());
        error.setCode(HttpStatus.BAD_REQUEST.value());
        return new ResponseEntity<>(error, HttpStatus.BAD_REQUEST);
    }
    
    

}
