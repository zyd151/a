package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("user")
public class User {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 登录账号（手机号 / 邮箱） */
    private String account;

    /** 密码（演示用明文，生产环境请加密存储） */
    private String password;

    /** 昵称 */
    private String nickname;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;
}
