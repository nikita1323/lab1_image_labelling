FROM python:3.9-slim

# 1) Зададим рабочую директорию
WORKDIR /app

# 2) Установим системные пакеты (Git, wget, glib, X11, gcc для pycocotools и т.п.)
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    make \
    git \
    wget \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    && rm -rf /var/lib/apt/lists/*

# 3) Клонируем репозиторий open-mmlab/playground
RUN git clone https://github.com/open-mmlab/playground.git

# 4) Устанавливаем PyTorch CPU (1.10.1) и соответствующие пакеты
RUN pip install --no-cache-dir \
    torch==1.10.1+cpu \
    torchvision==0.11.2+cpu \
    torchaudio==0.10.1 \
    -f https://download.pytorch.org/whl/cpu/torch_stable.html

# 5) Устанавливаем opencv, pycocotools, matplotlib
RUN pip install --no-cache-dir opencv-python pycocotools matplotlib

# 6) Segment Anything + Segment-Anything-HQ
RUN pip install --no-cache-dir git+https://github.com/facebookresearch/segment-anything.git
RUN pip install --no-cache-dir segment-anything-hq

# 7) Переходим в label_anything и скачиваем MobileSAM вес
WORKDIR /app/playground/label_anything
RUN wget -q https://raw.githubusercontent.com/ChaoningZhang/MobileSAM/master/weights/mobile_sam.pt \
    -O mobile_sam.pt

# 8) Устанавливаем Label Studio и Label Studio ML
RUN pip install --no-cache-dir \
    label-studio==1.7.3 \
    label-studio-ml==1.0.9

RUN pip install timm

RUN pip install label-studio


# 9) Открываем порт 8003 (на случай запуска ML backend)
EXPOSE 8003

# 10) По умолчанию запускаем Bash (при желании замените команду на ML-бэкенд)
CMD ["/bin/bash"]
