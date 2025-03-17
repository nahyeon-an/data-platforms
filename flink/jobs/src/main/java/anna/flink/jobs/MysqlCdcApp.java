package anna.flink.jobs;

import org.apache.flink.api.common.eventtime.WatermarkStrategy;
import org.apache.flink.cdc.connectors.mysql.source.MySqlSource;
import org.apache.flink.cdc.connectors.mysql.table.StartupOptions;
import org.apache.flink.cdc.debezium.JsonDebeziumDeserializationSchema;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;

public class MysqlCdcApp {
    public static void main(String[] args) throws Exception {

        System.out.println("Start!");

        MySqlSource<String> source = MySqlSource.<String>builder()
                .startupOptions(StartupOptions.earliest())
                .hostname("127.0.0.1")
                .port(3307)
                .databaseList("flink_test")
                .tableList("flink_test.users")
                .username("root")
                .password("admin")
                .deserializer(new JsonDebeziumDeserializationSchema())
                .build();

        final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        env.enableCheckpointing(10000);

        env.fromSource(source, WatermarkStrategy.noWatermarks(), "Mysql Cdc Source")
                .print()
                .setParallelism(1);

        env.execute("Print MySQL Snapshot + Binlog");
    }
}
