package com.klab.todo.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@EnableWebSecurity
@Configuration
public class TodoWebSecurityConfig extends WebSecurityConfigurerAdapter {

    private static final String USER = "USER";
    @Value(value = "${api.basic.auth.username}")
    private String basicAuthUserName;
    @Value(value = "${api.basic.auth.password}")
    private String basicAuthPassWord;

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.csrf().disable().authorizeRequests().antMatchers("/actuator/info", "/actuator/health").permitAll()
                .anyRequest().authenticated().and().httpBasic();

    }

    @Autowired
    public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
        auth.inMemoryAuthentication().withUser(basicAuthUserName).password(basicAuthPassWord).roles(USER);
    }

}
