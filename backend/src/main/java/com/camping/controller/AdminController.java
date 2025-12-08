@RestController
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private JdbcTemplate jdbcTemplate; // 简单查询 View 可以直接用 JDBC 或者定义 ViewEntity

    @GetMapping("/report/daily")
    public Result<List<Map<String, Object>>> getDailyReport(@RequestParam String start,
            @RequestParam String end) {
        // 直接查询 PostgreSQL 的视图 View_Daily_Revenue
        String sql = "SELECT * FROM View_Daily_Revenue WHERE date BETWEEN ? AND ?";
        List<Map<String, Object>> list = jdbcTemplate.queryForList(sql, start, end);
        return Result.success(list);
    }
}