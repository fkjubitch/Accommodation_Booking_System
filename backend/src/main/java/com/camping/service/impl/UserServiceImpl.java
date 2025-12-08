package com.camping.service.impl;

import com.camping.dto.UserLoginDTO;
import com.camping.dto.UserRegisterDTO;
import com.camping.entity.User;
import com.camping.service.UserService;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * 用户业务实现
 */
@Service
public class UserServiceImpl implements UserService {

    /**
     * 用户注册
     */
    @Override
    public void register(UserRegisterDTO dto) throws Exception {
        if (dto.getUsername() == null || dto.getUsername().isEmpty()) {
            throw new Exception("用户名不能为空");
        }
        if (dto.getPassword() == null || dto.getPassword().isEmpty()) {
            throw new Exception("密码不能为空");
        }

        // TODO: 查询是否用户已存在
        // TODO: 密码加密 (使用 BCryptPasswordEncoder)
        // TODO: 创建新用户记录到数据库

        User user = new User();
        user.setUsername(dto.getUsername());
        user.setPassword(dto.getPassword()); // 实际应加密
        user.setPhone(dto.getPhone());
        user.setRole(0); // 普通用户
        user.setCreateTime(LocalDateTime.now());

        // TODO: userMapper.insert(user);
    }

    /**
     * 用户登录
     */
    @Override
    public Map<String, Object> login(UserLoginDTO dto) throws Exception {
        if (dto.getUsername() == null || dto.getPassword() == null) {
            throw new Exception("用户名或密码不能为空");
        }

        // TODO: 查询用户
        // TODO: 验证密码
        // TODO: 生成 JWT Token

        Map<String, Object> result = new HashMap<>();
        result.put("userId", 1L);
        result.put("username", dto.getUsername());
        result.put("token", "Bearer " + UUID.randomUUID().toString());
        result.put("role", "user");

        return result;
    }

    /**
     * 获取用户信息
     */
    @Override
    public User getUserById(Long userId) throws Exception {
        // TODO: userMapper.selectById(userId);
        return new User();
    }

    /**
     * 更新用户信息
     */
    @Override
    public void updateUserInfo(User user) throws Exception {
        if (user.getUserId() == null) {
            throw new Exception("用户ID不能为空");
        }
        user.setUpdateTime(LocalDateTime.now());
        // TODO: userMapper.updateById(user);
    }

    /**
     * 修改密码
     */
    @Override
    public void changePassword(Long userId, String oldPassword, String newPassword) throws Exception {
        if (userId == null) {
            throw new Exception("用户ID不能为空");
        }
        if (oldPassword == null || newPassword == null) {
            throw new Exception("密码不能为空");
        }
        if (oldPassword.equals(newPassword)) {
            throw new Exception("新密码不能与旧密码相同");
        }

        // TODO: 查询用户
        // TODO: 验证旧密码
        // TODO: 更新新密码
    }
}
