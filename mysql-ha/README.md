# mysql  

## mysql master-slave 구성  

### 1. mysql 배포하기  
```shell
docker-compose up -d
```

### 2. 사용자 생성 및 권한 부여  
```shell
docker exec -it mysql-master mysql -uroot -padmin -e "CREATE USER 'replica'@'%' IDENTIFIED BY 'replica'; GRANT REPLICATION SLAVE ON *.* TO 'replica'@'%'; FLUSH PRIVILEGES;"
```

### 3. 마스터 bin log, postition 확인하기  
```shell
docker exec -it mysql-master mysql -uroot -padmin -e "SHOW MASTER STATUS;"
```
- 시작 bin log file 과 position 을 복사  
```shell
BIN_LOG_FILE=mysql-bin.000003
POSITION=833
```

### 4. 슬레이브 DB 에서 마스터를 설정  
```shell
docker exec -it mysql-slave mysql -uroot -padmin -e "CHANGE MASTER TO MASTER_HOST='mysql-master', MASTER_USER='replica', MASTER_PASSWORD='replica', MASTER_LOG_FILE='$BIN_LOG_FILE', MASTER_LOG_POS=$POSITION; START SLAVE;"
```
- 수행 후 다음 로그가 남음  
  - 2025-01-02T12:39:19.363382Z 10 [System] [MY-014001] [Repl] Replica receiver thread for channel '': connected to source 'replica@mysql-master:3306' with server_uuid=ef41ca2d-c905-11ef-81ef-0242c0a8e402, server_id=1. Starting replication from file 'mysql-bin.000003', position '833'.

### 5. 슬레이브 상태 확인  
```shell
docker exec -it mysql-slave mysql -uroot -padmin -e "SHOW SLAVE STATUS\G;"
```