package com.fenglin.springboottest.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.fenglin.springboottest.entity.User;

public interface UserService extends IService<User> {

    /**
     * 登录校验
     *
     * @return 校验成功返回用户（密码字段为 null），失败返回 null
     */
    User login(String account, String password);

    /**
     * 注册用户
     *
     * @throws RuntimeException 账号已存在时抛出，信息为 "账号已存在"
     */
    void register(String account, String password);
}
