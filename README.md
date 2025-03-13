# Описание 

Репозиторий содержит Docker фаил для запуска label studio и бэкенда SAM. 

# Сборка docker образа

Предварительно установите docker на ПК. Для того, чтобы собрать образ, перейдите в терминале в папку со скачанным Docker фаилом и введите команду:

```bash
docker build -t label-studio-mobile-sam .
```

Если образ не собирается, попробуйте прописать команду через sudo. 

# Работа с докер образом

Перед запуском необходимо создать volumes для хранения данных с label studio для аккаунта:
```bash
docker volume create labelstudio_config
```
Также для размеченных данных
```bash
docker volume create labelstudio_data
```
Для того чтобы запустить контейнер, введите команду:
```bash
docker run -it   -p 8080:8080   -v labelstudio_config:/root/.config -v labelstudio_data:/root/.local/share/label-studio   --name labelstudio   label-studio-mobile-sam
```
Команда запуска label-studio в терминале контейнера:
```bash
label-studio start
```

Для запуска бэкенда SAM сначала необходимо в другом терминале зайти в контейнер при помощи команды:
```bash
docker exec -it id_контейнера /bin/bash
```

В самом контейнере ввести:
```bash
label-studio-ml start sam --port 8003 --with \
  model_name=mobile_sam  \
  sam_config=vit_t \
  sam_checkpoint_file=./mobile_sam.pt \
  out_mask=True \
  out_bbox=True \
  device=cpu
```

В терминалах label studio и label studio ml есть ip адреса, по которым они работают. Скопируйте ip адрес label studio в поисковую строку браузера для запуска. Ml backend подключается в созданном проекте в настройках во вкладке machine learning





