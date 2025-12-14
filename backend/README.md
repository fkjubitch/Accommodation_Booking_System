# 露营营地预订系统 - 后端 (Camping Booking System - Backend)

## 项目简介

这是一个完整的露营营地预订系统的后端实现，使用 Spring Boot 2.7 和 PostgreSQL 数据库。系统支持用户预订、支付、设备租赁等完整功能。

## 技术栈

- **框架**: Spring Boot 2.7.8
- **语言**: Java 11+
- **数据库**: PostgreSQL 12+
- **ORM**: MyBatis 2.2.2
- **认证**: JWT (JSON Web Token)
- **构建工具**: Maven 3.6+
- **API 文档**: Swagger/Springfox (可选)

## 项目结构

```
backend/
├── src/
│   ├── main/
│   │   ├── java/com/camping/
│   │   │   ├── common/          # 通用类 (Result)
│   │   │   ├── config/          # 配置类 (CORS, Application)
│   │   │   ├── controller/      # REST 控制器
│   │   │   ├── dto/             # 数据传输对象
│   │   │   ├── entity/          # 实体类
│   │   │   ├── mapper/          # MyBatis 数据访问层
│   │   │   ├── service/         # 业务逻辑层
│   │   │   │   └── impl/        # 服务实现
│   │   │   └── util/            # 工具类
│   │   └── resources/
│   │       ├── mapper/          # MyBatis XML 映射文件
│   │       └── application.yml  # 应用配置
│   └── test/                    # 测试文件
├── pom.xml                      # Maven 配置
└── README.md                    # 项目说明

../sql/
├── schema.sql          # 数据库表结构
├── views_triggers.sql  # 视图和触发器
└── data.sql           # 初始数据
```

## 快速开始

### 1. 前置要求

- JDK 11 或以上版本
- Maven 3.6 或以上版本
- PostgreSQL 12 或以上版本
- Node.js 16+ (用于前端开发)

### 2. 环境配置

#### 2.1 数据库配置

```sql
-- 创建数据库
CREATE DATABASE camping_db ENCODING 'UTF8';

-- 连接到数据库
\c camping_db

-- 执行 SQL 脚本
\i sql/schema.sql
\i sql/views_triggers.sql
\i sql/data.sql
```

#### 2.2 修改配置文件

编辑 `src/main/resources/application.yml`：

```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/camping_db
    username: postgres
    password: your_password # 修改为您的 PostgreSQL 密码
    driver-class-name: org.postgresql.Driver
  jpa:
    hibernate:
      ddl-auto: none
  application:
    name: camping-booking-system
server:
  port: 8080
  servlet:
    context-path: /api
```

### 3. 构建和运行

```bash
# 进入后端目录
cd backend

# 编译项目
mvn clean compile

# 运行测试
mvn test

# 打包项目
mvn clean package

# 运行应用
java -jar target/camping-booking-system-1.0.0.jar

# 或者使用 Maven 插件直接运行
mvn spring-boot:run
```

应用将在 `http://localhost:8080` 启动。

## API 文档

### 基础 URL

```
http://localhost:8080/api
```

### 用户模块 (/user)

| 方法 | 端点           | 描述                                |
| ---- | -------------- | ----------------------------------- |
| POST | /user/register | 用户注册                            |
| POST | /user/login    | 用户登录                            |
| GET  | /user/info     | 获取用户信息（需传 `token` 参数）   |
| POST | /user/logout   | 用户登出（需传 `token` 参数）       |
| PUT  | /user/info     | 更新用户信息                        |
| POST | /user/password | 修改密码（需传 `token`、旧/新密码） |

### 预订模块 (/booking)

| 方法 | 端点                     | 描述                                                  |
| ---- | ------------------------ | ----------------------------------------------------- |
| POST | /booking/check           | 检查可用性                                            |
| POST | /booking/create          | 创建预订（返回 `bookingId/siteNo/totalPrice/status`） |
| POST | /booking/pay             | 支付预订                                              |
| GET  | /booking/my              | 获取我的预订                                          |
| GET  | /booking/{id}            | 获取预订详情                                          |
| POST | /booking/cancel          | 取消预订                                              |
| GET  | /booking/{id}/equipments | 获取订单的装备列表                                    |

### 资源模块

| 方法 | 端点                | 描述                                                                 |
| ---- | ------------------- | -------------------------------------------------------------------- |
| GET  | /type/list          | 房型列表（含总数/可用数等）                                          |
| GET  | /type/list/today    | 当日房型列表（含 `priceToday/available`）                            |
| GET  | /type/{id}          | 房型详情                                                             |
| GET  | /type/calendar      | 价格/占用日历（按日期范围）                                          |
| POST | /type/prices        | 指定日期的日价列表                                                   |
| GET  | /equip/list         | 装备列表（含库存）                                                   |
| GET  | /equip/list/today   | 当日装备列表（含可用库存）                                           |
| GET  | /equip/{id}         | 装备详情                                                             |
| POST | /equip/stock        | 批量查询装备库存                                                     |
| GET  | /equip/categories   | 装备分类列表                                                         |
| GET  | /equip/category/{c} | 按分类查询装备                                                       |
| GET  | /availability/query | 查询资源在日期范围的剩余量（参数：kind, typeId, startDate, endDate） |

### 管理模块 (/admin)

| 方法 | 端点                          | 描述                  |
| ---- | ----------------------------- | --------------------- |
| POST | /admin/price/set              | 设置日期价格          |
| POST | /admin/price/batch            | 批量设置日期价格      |
| GET  | /admin/report/daily           | 每日收入报告          |
| GET  | /admin/report/type            | 房型收入报告          |
| GET  | /admin/stats/booking          | 预订统计              |
| GET  | /admin/stats/type             | 房型统计              |
| GET  | /admin/logs/operation         | 操作日志（分页/筛选） |
| GET  | /admin/sites                  | 营位列表（可按房型）  |
| GET  | /admin/site/{siteId}          | 营位详情              |
| PUT  | /admin/site/{siteId}/status   | 更新营位状态          |
| GET  | /admin/occupancy/date         | 指定日期占用情况      |
| GET  | /admin/revenue/trend          | 收益趋势              |
| POST | /admin/booking/price-adjust   | 手动调整订单价格      |
| GET  | /admin/user/{userId}/behavior | 用户操作记录          |

## 核心业务逻辑

### 预订流程

1. **检查可用性** (`/booking/check`)

   - 验证设备库存
   - 计算价格分解
   - 返回可用性和价格信息

2. **创建预订** (`/booking/create`)

   - @Transactional 事务处理
   - 验证设备库存
   - 自动分配营地
   - 创建 Booking 和 BookingEquip 记录

3. **支付** (`/booking/pay`)

   - 更新预订状态为已支付
   - 记录操作日志

4. **取消** (`/booking/cancel`)
   - 更新预订状态为已取消
   - 删除设备预订
   - 触发数据库触发器

### 价格计算

```
总价 = 基础价格 × 晚数 + 动态价格差异 + 设备费用
其中：
- 基础价格：营地类型默认价格
- 动态价格：每日价格表中的特殊价格
- 设备费用：所有选中设备的费用
```

### 营地分配算法

```
1. 查询该类型的所有营地
2. 排除时间冲突的营地 (check_in <= 已订 check_out 且 check_out >= 已订 check_in)
3. 从剩余营地中分配第一个可用的营地
```

## 数据库设计

### 核心表

- **users**: 用户信息
- **site_types**: 营地类型
- **sites**: 营地
- **bookings**: 预订
- **equipments**: 设备
- **daily_prices**: 每日价格
- **booking_equips**: 预订设备关系表
- **operation_logs**: 操作日志

### 视图

- `view_daily_revenue`: 每日收入统计
- `view_site_occupancy`: 营地利用率
- `view_user_booking_stats`: 用户预订统计
- `view_equipment_inventory`: 设备库存

### 触发器

- `trigger_booking_creation`: 记录创建预订
- `trigger_booking_status_change`: 记录状态变更
- `trigger_update_booking_time`: 更新时间戳

## 安全性

### 密码加密

使用 SHA-256 加盐哈希：

```java
// PasswordUtil.generateSalt() - 生成盐值
// PasswordUtil.encryptPassword(password, salt) - 加密密码
// PasswordUtil.verifyPassword(password, salt, encrypted) - 验证密码
```

### JWT 认证

- 生成令牌: `JwtUtil.generateToken(userId, username, role)`
- 令牌有效期: 24 小时
- 签名算法: HS512
- 包含信息: userId, username, role

### CORS 配置

已启用 CORS，允许所有来源的跨域请求。

## 错误处理

统一使用 `Result` 类进行响应:

```java
// 成功响应
Result.success(data)        // code=1

// 错误响应
Result.error("Error message")  // code=0
```

## 日志

日志配置在 `application.yml` 中:

- 日志级别: DEBUG
- 输出位置: 文件 + 控制台
- 日志文件: `logs/camping-booking-system.log`

## 常见问题

### 1. 数据库连接失败

检查 PostgreSQL 是否运行，并确认 `application.yml` 中的连接参数正确。

### 2. JAR 包依赖问题

运行 `mvn clean install` 以重新下载依赖。

### 3. 端口被占用

修改 `application.yml` 中的 `server.port` 字段。

## 前后端集成

前端项目位于 `../frontend` 目录，使用 Vue 3 + TypeScript 构建。

```bash
# 启动前端开发服务器
cd ../frontend
npm install
npm run dev
```

前端将在 `http://localhost:5173` 运行，通过 CORS 与后端通信。

## 生产部署

### 1. 构建 Docker 镜像

```dockerfile
# Dockerfile
FROM openjdk:11-jre-slim
COPY target/camping-booking-system-1.0.0.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
```

```bash
docker build -t camping-booking-system:1.0.0 .
docker run -p 8080:8080 \
  -e DB_URL=jdbc:postgresql://postgres:5432/camping_db \
  -e DB_USER=postgres \
  -e DB_PASSWORD=postgres \
  camping-booking-system:1.0.0
```

### 2. 配置生产环境

创建 `application-prod.yml`:

```yaml
spring:
  datasource:
    url: jdbc:postgresql://${DB_HOST:localhost}:${DB_PORT:5432}/${DB_NAME:camping_db}
    username: ${DB_USER:postgres}
    password: ${DB_PASSWORD:postgres}
server:
  port: ${SERVER_PORT:8080}
logging:
  level:
    com.camping: INFO
```

### 3. 启动应用

```bash
java -jar target/camping-booking-system-1.0.0.jar --spring.profiles.active=prod
```

## 开发说明

### 代码规范

- Java: Alibaba Java Coding Guidelines
- 命名: camelCase for methods/variables, PascalCase for classes
- 注释: 中英文混用，优先中文

### 添加新的 API

1. 创建 DTO 类 (`src/main/java/com/camping/dto/`)
2. 创建或更新 Service 层
3. 更新 Controller 并添加映射
4. 添加对应的 MyBatis Mapper XML

### 测试

```bash
# 运行所有测试
mvn test

# 运行特定测试类
mvn test -Dtest=BookingServiceImplTest
```

## 许可证

MIT License

## 联系方式

如有问题或建议，欢迎联系开发团队。
