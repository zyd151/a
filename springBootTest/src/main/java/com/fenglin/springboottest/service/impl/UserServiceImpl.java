package com.fenglin.springboottest.service.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.mapper.UserMapper;
import com.fenglin.springboottest.service.UserService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

    private final PasswordEncoder passwordEncoder;

    public UserServiceImpl(PasswordEncoder passwordEncoder) {
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public User login(String account, String password) {
        User user = getOne(Wrappers.<User>lambdaQuery().eq(User::getAccount, account));
        // 用 BCrypt 比对原始密码与库中密文
        if (user == null || !passwordEncoder.matches(password, user.getPassword())) {
            return null;
        }
        // 不向外暴露密码
        user.setPassword(null);
        return user;
    }

    @Override
    public void register(String account, String password) {
        long count = count(Wrappers.<User>lambdaQuery().eq(User::getAccount, account));
        if (count > 0) {
            throw new RuntimeException("账号已存在");
        }
        User user = new User();
        user.setAccount(account);
        user.setPassword(passwordEncoder.encode(password)); // 加密存储
        user.setNickname(account);
        save(user);
    }
}
