# Flink  

## Deployment  

flink 의 배포 방식에는 application 모드와 session 모드가 존재함  
- application : flink cluster 를 독립적으로 실행하고, 독립된 클러스터에서 job 을 실행함
  - job 마다 jobmanager 와 taskmanager 를 배포함  
  - 독립적인 자원 사용 -> k8s native deploy 방식에서 볼 수 있음  
- session : flink cluster 에 여러 job 이 배포되고 실행됨   
  - job 이 jobmanager 와 taskmanager 를 공유함  
  - flink standalone cluster 에서 볼 수 있음  