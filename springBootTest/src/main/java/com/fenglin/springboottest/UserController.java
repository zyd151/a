package com.fenglin.springboottest;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.fenglin.springboottest.common.JwtUtil;
import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.dto.LoginDTO;
import com.fenglin.springboottest.dto.RegisterDTO;
import com.fenglin.springboottest.dto.TrainingRecordDTO;
import com.fenglin.springboottest.entity.TrainingStats;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.service.UserService;
import com.fenglin.springboottest.service.TrainingStatsService;
import com.fenglin.springboottest.vo.LoginVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private Environment environment;

    @Autowired
    private TrainingStatsService trainingStatsService;

    /** 登录：校验账号密码，成功签发 JWT 并返回用户信息（不含密码） */
    @PostMapping("/login")
    public Result<LoginVO> login(@Valid @RequestBody LoginDTO dto) {
        User user = userService.login(dto.getAccount(), dto.getPassword());
        if (user == null) {
            return Result.error("账号或密码错误");
        }
        LoginVO vo = new LoginVO();
        vo.setToken(jwtUtil.generateToken(user.getAccount()));
        vo.setUser(user);
        return Result.success(vo);
    }

    /** 注册：账号已存在时返回错误信息 */
    @PostMapping("/register")
    public Result<Void> register(@Valid @RequestBody RegisterDTO dto) {
        userService.register(dto.getAccount(), dto.getPassword());
        return Result.success(null);
    }

    /** 获取当前登录用户信息（需携带有效 Token） */
    @SecurityRequirement(name = "bearerAuth")
    @GetMapping("/info")
    public Result<User> info(HttpServletRequest request) {
        String account = (String) request.getAttribute("account");
        User user = userService.getOne(Wrappers.<User>lambdaQuery().eq(User::getAccount, account));
        if (user != null) {
            user.setPassword(null);
        }
        return Result.success(user);
    }

    /** 获取当前登录用户的训练统计（需携带有效 Token） */
    @SecurityRequirement(name = "bearerAuth")
    @GetMapping("/stats")
    public Result<TrainingStats> stats(HttpServletRequest request) {
        String account = (String) request.getAttribute("account");
        return Result.success(trainingStatsService.getOrInit(account));
    }

    /** 记录一次训练，更新统计（需携带有效 Token） */
    @SecurityRequirement(name = "bearerAuth")
    @PostMapping("/training")
    public Result<TrainingStats> record(@Valid @RequestBody TrainingRecordDTO dto, HttpServletRequest request) {
        String account = (String) request.getAttribute("account");
        return Result.success(trainingStatsService.record(account, dto.getShots(), dto.getHits()));
    }

    /** 保留原来的环境探测接口 */
    @GetMapping("/test")
    public String test() {
        return environment.getProperty("spring.application.name") + "  " +
                environment.getProperty("server.port");
    }
}
