# jupyterhub

jupyter notebook 을 multi user 가 사용할 수 있는 환경으로 구성한 솔루션  
- 자원 관리가 효율적임  

docker 컨테이너 실행  
```shell
# c.LocalAuthenticator.create_system_users=True 설정을 했을 때 비밀번호를 모르겠음
docker run -d -p 8000:8000 -v ./jupyterhub_config.py:/etc/jupyterhub/jupyterhub_config.py --name jupyterhub quay.io/jupyterhub/jupyterhub jupyterhub -f /etc/jupyterhub/jupyterhub_config.py 
```

계정 생성  
```shell
docker exec -it jupyterhub bash

# bash 쉘에서 다음 명령어로 계정 생성  
adduser anna

# 아래 3개 실행 후 서버 재시작 필요함 ...;;
# todo : custom docker image 로 개선 필요
apt-get update
apt-get install -y python3 python3-pip
python3 -m pip install jupyterhub notebook jupyterlab
```

<참고>
jupyterhub default 설정파일 생성  
```shell
mkdir /etc/jupyterhub
cd /etc/jupyterhub/
jupyterhub --generate-config -f jupyterhub_config.py
```

vim 설치 : jupyterhub config 를 수정하기 위해.. 
```shell
apt-get update
apt-get install -y vim 
```
