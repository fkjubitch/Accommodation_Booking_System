-- ============================================================================
-- 视图和触发器定义
-- ============================================================================

-- 视图1: 日期收入汇总视图
CREATE OR REPLACE VIEW view_daily_revenue AS
SELECT 
    DATE(b.create_time) as revenue_date,
    st.type_id,
    st.type_name,
    COUNT(DISTINCT b.booking_id) as booking_count,
    SUM(CASE WHEN b.status = 1 THEN 1 ELSE 0 END) as paid_count,
    SUM(CASE WHEN b.status = 1 THEN b.total_price ELSE 0 END) as revenue,
    SUM(CASE WHEN b.status = 0 THEN b.total_price ELSE 0 END) as pending_amount,
    SUM(CASE WHEN b.status = 2 THEN b.total_price ELSE 0 END) as cancelled_amount
FROM bookings b
JOIN site_types st ON b.type_id = st.type_id
GROUP BY DATE(b.create_time), st.type_id, st.type_name
ORDER BY revenue_date DESC;

-- 视图2: 营地利用率视图
CREATE OR REPLACE VIEW view_site_occupancy AS
SELECT 
    st.type_id,
    st.type_name,
    COUNT(s.site_id) as total_sites,
    COUNT(DISTINCT CASE WHEN b.booking_id IS NOT NULL THEN s.site_id END) as occupied_sites,
    ROUND(COUNT(DISTINCT CASE WHEN b.booking_id IS NOT NULL THEN s.site_id END)::numeric / 
          COUNT(s.site_id) * 100, 2) as occupancy_rate
FROM site_types st
JOIN sites s ON st.type_id = s.type_id
LEFT JOIN bookings b ON s.site_id = b.site_id 
    AND b.status IN (0, 1)
    AND CURRENT_DATE BETWEEN b.check_in AND b.check_out
GROUP BY st.type_id, st.type_name;

-- 视图3: 用户预订统计视图
CREATE OR REPLACE VIEW view_user_booking_stats AS
SELECT 
    u.user_id,
    u.username,
    COUNT(b.booking_id) as total_bookings,
    SUM(CASE WHEN b.status = 1 THEN 1 ELSE 0 END) as completed_bookings,
    SUM(CASE WHEN b.status = 1 THEN b.total_price ELSE 0 END) as total_spent,
    COUNT(DISTINCT b.type_id) as different_types_booked
FROM users u
LEFT JOIN bookings b ON u.user_id = b.user_id
GROUP BY u.user_id, u.username
ORDER BY total_spent DESC;

-- 视图4: 设备库存视图
CREATE OR REPLACE VIEW view_equipment_inventory AS
SELECT 
    e.equip_id,
    e.equip_name,
    e.category,
    e.total_stock,
    COALESCE(SUM(be.quantity), 0) as booked_quantity,
    e.total_stock - COALESCE(SUM(be.quantity), 0) as available_quantity,
    ROUND((e.total_stock - COALESCE(SUM(be.quantity), 0))::numeric / e.total_stock * 100, 2) as availability_rate
FROM equipments e
LEFT JOIN booking_equips be ON e.equip_id = be.equip_id
LEFT JOIN bookings b ON be.booking_id = b.booking_id AND b.status IN (0, 1)
GROUP BY e.equip_id, e.equip_name, e.category, e.total_stock;

-- ============================================================================
-- 触发器和函数定义
-- ============================================================================

-- 触发器1: 预订创建审计日志
CREATE OR REPLACE FUNCTION log_booking_creation()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO operation_logs (
        operation, 
        operator_id, 
        operator_name, 
        description, 
        details, 
        log_time
    )
    VALUES (
        'create_booking',
        NEW.user_id,
        'system',
        'Booking created: ID ' || NEW.booking_id || ' for type ' || NEW.type_id,
        JSON_BUILD_OBJECT(
            'booking_id', NEW.booking_id,
            'user_id', NEW.user_id,
            'type_id', NEW.type_id,
            'site_id', NEW.site_id,
            'check_in', NEW.check_in,
            'check_out', NEW.check_out,
            'total_price', NEW.total_price
        )::text,
        CURRENT_TIMESTAMP
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 触发器2: 预订状态变更审计日志
CREATE OR REPLACE FUNCTION log_booking_status_change()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO operation_logs (
            operation,
            operator_id,
            operator_name,
            description,
            details,
            log_time
        )
        VALUES (
            'update_booking_status',
            NEW.user_id,
            'system',
            'Booking status updated: ID ' || NEW.booking_id || ' from ' || OLD.status || ' to ' || NEW.status,
            JSON_BUILD_OBJECT(
                'booking_id', NEW.booking_id,
                'old_status', OLD.status,
                'new_status', NEW.status,
                'update_reason', CASE 
                    WHEN NEW.status = 1 THEN 'Payment completed'
                    WHEN NEW.status = 2 THEN 'Booking cancelled'
                    ELSE 'Status updated'
                END
            )::text,
            CURRENT_TIMESTAMP
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 触发器3: 更新预订修改时间
CREATE OR REPLACE FUNCTION update_booking_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.update_time = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 绑定触发器
DROP TRIGGER IF EXISTS trigger_booking_creation ON bookings;
CREATE TRIGGER trigger_booking_creation
AFTER INSERT ON bookings
FOR EACH ROW
EXECUTE FUNCTION log_booking_creation();

DROP TRIGGER IF EXISTS trigger_booking_status_change ON bookings;
CREATE TRIGGER trigger_booking_status_change
AFTER UPDATE ON bookings
FOR EACH ROW
EXECUTE FUNCTION log_booking_status_change();

DROP TRIGGER IF EXISTS trigger_update_booking_time ON bookings;
CREATE TRIGGER trigger_update_booking_time
BEFORE UPDATE ON bookings
FOR EACH ROW
EXECUTE FUNCTION update_booking_timestamp();

-- 触发器4: 用户修改时间更新
CREATE OR REPLACE FUNCTION update_user_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.update_time = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_update_user_time ON users;
CREATE TRIGGER trigger_update_user_time
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_user_timestamp();

-- 触发器5: 营地修改时间更新
CREATE OR REPLACE FUNCTION update_site_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.update_time = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_update_site_time ON sites;
CREATE TRIGGER trigger_update_site_time
BEFORE UPDATE ON sites
FOR EACH ROW
EXECUTE FUNCTION update_site_timestamp();

-- ============================================================================
-- 存储过程定义
-- ============================================================================

-- 存储过程1: 取消预订并更新库存
CREATE OR REPLACE FUNCTION cancel_booking_and_release_equipment(
    p_booking_id BIGINT
)
RETURNS TABLE (
    status_code INTEGER,
    message VARCHAR
) AS $$
DECLARE
    v_booking_id BIGINT;
BEGIN
    -- 开始事务
    BEGIN
        -- 验证预订是否存在
        SELECT booking_id INTO v_booking_id
        FROM bookings
        WHERE booking_id = p_booking_id
        FOR UPDATE;
        
        IF v_booking_id IS NULL THEN
            RETURN QUERY SELECT 0::INTEGER, 'Booking not found'::VARCHAR;
            RETURN;
        END IF;
        
        -- 更新预订状态为已取消
        UPDATE bookings
        SET status = 2, update_time = CURRENT_TIMESTAMP
        WHERE booking_id = p_booking_id;
        
        -- 删除相关的设备预订记录
        DELETE FROM booking_equips
        WHERE booking_id = p_booking_id;
        
        -- 记录操作日志
        INSERT INTO operation_logs (
            operation,
            operator_id,
            operator_name,
            description,
            log_time
        )
        VALUES (
            'cancel_booking',
            NULL,
            'system',
            'Booking cancelled: ID ' || p_booking_id,
            CURRENT_TIMESTAMP
        );
        
        RETURN QUERY SELECT 1::INTEGER, 'Booking cancelled successfully'::VARCHAR;
        
    EXCEPTION WHEN OTHERS THEN
        RETURN QUERY SELECT 0::INTEGER, 'Error cancelling booking: ' || SQLERRM::VARCHAR;
    END;
END;
$$ LANGUAGE plpgsql;

-- 存储过程2: 获取指定日期的营地价格
CREATE OR REPLACE FUNCTION get_site_price(
    p_type_id BIGINT,
    p_specific_date DATE
)
RETURNS TABLE (
    price DECIMAL,
    from_source VARCHAR
) AS $$
BEGIN
    -- 尝试获取特定日期的价格
    RETURN QUERY
    SELECT dp.price, 'daily_price'::VARCHAR
    FROM daily_prices dp
    WHERE dp.type_id = p_type_id
    AND dp.specific_date = p_specific_date;
    
    -- 如果没有特定日期的价格，返回基础价格
    IF NOT FOUND THEN
        RETURN QUERY
        SELECT st.base_price, 'base_price'::VARCHAR
        FROM site_types st
        WHERE st.type_id = p_type_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- 存储过程3: 获取可用营地数量
CREATE OR REPLACE FUNCTION get_available_sites_count(
    p_type_id BIGINT,
    p_check_in DATE,
    p_check_out DATE
)
RETURNS INTEGER AS $$
DECLARE
    v_total_sites INTEGER;
    v_booked_sites INTEGER;
BEGIN
    -- 获取该类型的总营地数
    SELECT COUNT(*)
    INTO v_total_sites
    FROM sites
    WHERE type_id = p_type_id AND status = 1;
    
    -- 获取时间范围内已预订的营地数
    SELECT COUNT(DISTINCT site_id)
    INTO v_booked_sites
    FROM bookings
    WHERE type_id = p_type_id
    AND status IN (0, 1)
    AND NOT (check_out <= p_check_in OR check_in >= p_check_out);
    
    RETURN v_total_sites - COALESCE(v_booked_sites, 0);
END;
$$ LANGUAGE plpgsql;
