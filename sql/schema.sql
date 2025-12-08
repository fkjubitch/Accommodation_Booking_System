-- 1. 视图设计 (View)
CREATE OR REPLACE VIEW View_Daily_Revenue AS
SELECT 
    DATE(checkInTime) as date, 
    SUM(totalPrice) as revenue
FROM BookingTable
WHERE status = 1 -- 1: 已支付
GROUP BY DATE(checkInTime);

-- 2. 触发器函数 (PostgreSQL 需要先定义 Function 再绑定 Trigger)
CREATE OR REPLACE FUNCTION func_booking_audit() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO OperationLogTable (operation, operatorID, description, logTime)
    VALUES (
        'NEW_ORDER', 
        NEW.userID, 
        'Order ID ' || NEW.bookingID || ' created for Site ' || NEW.siteID, 
        NOW()
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 3. 绑定触发器
CREATE TRIGGER Trigger_Booking_Audit
AFTER INSERT ON BookingTable
FOR EACH ROW EXECUTE FUNCTION func_booking_audit();