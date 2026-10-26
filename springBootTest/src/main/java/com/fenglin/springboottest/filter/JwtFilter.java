package com.fenglin.springboottest.filter;

import com.fenglin.springboottest.common.JwtUtil;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.List;
import java.util.Set;

@Component
public class JwtFilter implements Filter {

    @Autowired
    private JwtUtil jwtUtil;

    /** 免鉴权的公开接口（精确匹配） */
    private static final Set<String> PUBLIC_PATHS = Set.of(
            "/user/login", "/user/register", "/user/test"
    );

    /** 免鉴权的前缀（文档 / 错误页等） */
    private static final List<String> PUBLIC_PREFIXES = List.of(
            "/v3/api-docs", "/swagger-ui", "/error"
    );

    @Override
    public void doFilter(ServletRequest servletRequest,
                        ServletResponse servletResponse,
                        FilterChain chain) throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String path = request.getServletPath();

        // 预检请求、公开接口、文档与错误页直接放行
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())
                || PUBLIC_PATHS.contains(path)
                || PUBLIC_PREFIXES.stream().anyMatch(path::startsWith)) {
            chain.doFilter(servletRequest, servletResponse);
            return;
        }

        String header = request.getHeader("Authorization");
        String token = null;
        if (header != null && header.startsWith("Bearer ")) {
            token = header.substring(7);
        }

        if (token == null || !jwtUtil.validate(token)) {
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"code\":401,\"message\":\"未登录或登录已过期\"}");
            return;
        }

        // 将当前账号放入请求属性，供 Controller 使用
        request.setAttribute("account", jwtUtil.getAccountFromToken(token));
        chain.doFilter(servletRequest, servletResponse);
    }
}
