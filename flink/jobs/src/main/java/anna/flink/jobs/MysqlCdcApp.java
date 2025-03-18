package anna.flink.jobs;

import org.apache.flink.api.common.eventtime.WatermarkStrategy;
import org.apache.flink.cdc.connectors.mysql.source.MySqlSource;
import org.apache.flink.cdc.connectors.mysql.table.StartupOptions;
import org.apache.flink.cdc.debezium.JsonDebeziumDeserializationSchema;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.SimpleDateFormat;

public class MysqlCdcApp {
    private static final Logger LOG = LoggerFactory.getLogger(MysqlCdcApp.class);

    public static void main(String[] args) throws Exception {

        LOG.info("Start!");

//        String date = "2025-03-15 00:00:00";
//        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        MySqlSource<String> source = MySqlSource.<String>builder()
                .startupOptions(StartupOptions.earliest())
//                .startupOptions(StartupOptions.timestamp(df.parse(date).getTime()))
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
//                .map(row -> {
//                    System.out.println("Received: " + row);
//                    return row;
//                })
                .print()
                .setParallelism(1);

        env.execute("Print MySQL Snapshot + Binlog");
    }
}
