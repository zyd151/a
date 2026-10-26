package com.fenglin.springboottest.common;

import lombok.Data;

import java.io.Serializable;

@Data
public class Result<T> implements Serializable {

    /** 200 表示成功，其它表示失败 */
    private int code;
    private String message;
    private T data;

    public static <T> Result<T> success(T data) {
        Result<T> r = new Result<>();
        r.code = 200;
        r.message = "success";
        r.data = data;
        return r;
    }

    public static <T> Result<T> error(String message) {
        Result<T> r = new Result<>();
        r.code = 400;
        r.message = message;
        return r;
    }
}
