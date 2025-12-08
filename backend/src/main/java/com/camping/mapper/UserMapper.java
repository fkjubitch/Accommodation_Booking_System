package com.camping.mapper;

import com.camping.entity.User;

/**
 * 用户 Mapper 接口
 */
public interface UserMapper {

    /**
     * 根据用户名查询用户
     */
    User selectByUsername(String username);

    /**
     * 根据ID查询用户
     */
    User selectById(Long userId);

    /**
     * 插入用户
     */
    void insert(User user);

    /**
     * 更新用户
     */
    void update(User user);
}
