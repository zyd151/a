package com.fenglin.springboottest.vo;

import com.fenglin.springboottest.entity.User;
import lombok.Data;

@Data
public class LoginVO {
    /** 登录令牌 */
    private String token;
    /** 登录用户信息（密码已置空） */
    private User user;
}
