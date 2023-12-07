package com.itheima;

import org.apache.catalina.filters.CorsFilter;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

/**
 * Hello world!
 */
@SpringBootApplication
public class BigEventApplication {


    public static void main(String[] args) {
        SpringApplication.run(BigEventApplication.class,args);
    }
}
