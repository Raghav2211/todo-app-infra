package com.klab.todo.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.util.StringUtils;

@EnableWebSecurity
@Configuration
public class TodoWebSecurityConfig extends WebSecurityConfigurerAdapter {

    private static final String USER = "USER";
    @Value(value = "${klab.todo.security.basic.auth.username:#{null}}")
    private String basicAuthUserName;
    @Value(value = "${klab.todo.security.basic.auth.password:#{null}}")
    private String basicAuthPassWord;
    @Value(value = "${klab.todo.security.basic.auth.enable:false}")
    private Boolean isBasicAuthEnable;

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        if (isBasicAuthEnable) {
            hasBasicAuthCredentials();
            http.csrf().disable().authorizeRequests().antMatchers("/actuator/info", "/actuator/health").permitAll()
                    .anyRequest().authenticated().and().httpBasic();
        } else {
            http.authorizeRequests().antMatchers("/").permitAll();
        }
    }

    @Autowired
    public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
        if (isBasicAuthEnable) {
            hasBasicAuthCredentials();
            auth.inMemoryAuthentication().withUser(basicAuthUserName).password(basicAuthPassWord).roles(USER);
        }
    }

    private void hasBasicAuthCredentials() {
        if (!StringUtils.hasText(basicAuthUserName) || !StringUtils.hasText(basicAuthPassWord)) {
            throw new IllegalArgumentException("Basic Auth crendentials(username/password) can't be null");
        }
    }

}
