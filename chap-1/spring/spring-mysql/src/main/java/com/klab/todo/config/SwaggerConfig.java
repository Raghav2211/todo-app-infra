/**
 * 
 */
package com.klab.todo.config;

import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.service.Contact;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;

@Configuration
public class SwaggerConfig {

    @Bean
    public Docket api() {
        return new Docket(DocumentationType.SWAGGER_2)
                .useDefaultResponseMessages(false)
                .select().apis(RequestHandlerSelectors.any())
                .paths(PathSelectors.any()).build().apiInfo(metaData());
    }

    private ApiInfo metaData() {
        return new ApiInfo("TODO App on Kubernetes application", "TODO App on Kubernetes application", "0.1.0",
                "Terms of service",
                new Contact("TODO",
                        "https://github.com/Raghav2211/kubernetes-lab/tree/spring-mysql/chap-1/spring/spring-mysql",
                        "todo@todo.com"),
                "TODO Licence", "http://localhost:8080", List.of());
    }

}
