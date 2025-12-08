package com.camping.mapper;

import com.camping.entity.OperationLog;
import java.util.List;
import java.util.Map;

/**
 * 操作日志 Mapper 接口
 */
public interface OperationLogMapper {

    /**
     * 查询所有日志
     */
    List<OperationLog> selectAll(Map<String, Object> params);

    /**
     * 按操作类型查询日志
     */
    List<OperationLog> selectByOperation(String operation);

    /**
     * 插入日志
     */
    void insert(OperationLog operationLog);
}
