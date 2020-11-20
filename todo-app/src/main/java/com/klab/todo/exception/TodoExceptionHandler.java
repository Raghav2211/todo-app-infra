package com.klab.todo.exception;

import javax.persistence.PersistenceException;
import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.transaction.TransactionException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

@ControllerAdvice
public class TodoExceptionHandler {

    private static final String MY_SQL_UNAVAILABLE = "MySQL Unavailable..";

    @ExceptionHandler(Exception.class)
    @ResponseStatus(value = HttpStatus.INTERNAL_SERVER_ERROR)
    public @ResponseBody TodoException handleException(final Exception exception, final HttpServletRequest request) {
        TodoException error = new TodoException();
        error.setMessage(exception.getMessage());
        error.setRequestedURI(request.getRequestURI());

        return error;
    }

    @ExceptionHandler(TransactionException.class)
    @ResponseStatus(value = HttpStatus.INTERNAL_SERVER_ERROR)
    public @ResponseBody TodoException handleConnectionException(final Exception exception,
            final HttpServletRequest request) {

        TodoException error = new TodoException();
        error.setMessage(MY_SQL_UNAVAILABLE);
        error.setRequestedURI(request.getRequestURI());

        return error;
    }
    
    @ExceptionHandler(PersistenceException.class)
    @ResponseStatus(value = HttpStatus.NOT_FOUND)
    public @ResponseBody TodoException handlePersistence(final Exception exception,
            final HttpServletRequest request) {
        
        TodoException error = new TodoException();
        error.setMessage(exception.getMessage());
        error.setRequestedURI(request.getRequestURI());

        return error;
    }

}
