
## Prepare

1. UFF 툴킷과 그래프 surgeon
( https://docs.nvidia.com/deeplearning/sdk/tensorrt-install-guide/index.html#installing ).

./install_tensorflow_1.x.sh

UFF_PATH="$(python3 -c 'import uff; print(uff.__path__[0])')"
sudo chmod +x ${UFF_PATH}/bin/convert_to_uff.py
sudo ln -sf ${UFF_PATH}/bin/convert_to_uff.py /usr/local/bin/convert-to-uff


2. [ssd_inception_v2_coco TensorFlow 학습 모델 다운로드]

cd ~/Downloads
wget http://download.tensorflow.org/models/object_detection/ssd_inception_v2_coco_2017_11_17.tar.gz
tar xzf ssd_inception_v2_coco_2017_11_17.tar.gz


3. UFF 변환기를 사용하여 tensorflow 모델에서 전처리를 수행
1) TensorFlow protobuf 파일 (`frozen_inference_graph.pb`)을 작업 디렉토리로 복사합니다.

cd /usr/src/tensorrt/samples/sampleUffSSD

sudo cp ~/Downloads/ssd_inception_v2_coco_2017_11_17/frozen_inference_graph.pb ./


2) 변환

sudo convert-to-uff frozen_inference_graph.pb -O NMS -p config.py

이렇게하면 변환 된`.uff` 파일이`frozen_inference_graph.pb.uff`라는 이름의 입력과 동일한 디렉토리에 저장됩니다.

`config.py` 스크립트는 SSD TensorFlow 그래프에 필요한 전처리 작업을 지정합니다. 
`config.py` 스크립트에 사용 된 플러그인 노드와 플러그인 매개 변수는 TensorRT에 등록 된 플러그인과 일치해야합니다.

3) 변환 된`.uff` 파일을 데이터 디렉토리에 복사하고 sample_ssd_relu6.uff`로 이름을 바꿉니다.
sudo cp frozen_inference_graph.uff /usr/src/tensorrt/data/ssd/sample_ssd_relu6.uff

4) 샘플에는 모델 학습에 사용되는 모든 레이블 목록이 포함 된`labels.txt` 파일도 필요합니다. (ssd_coco_labels.txt)


## 샘플 실행

1.`<TensorRT 루트 디렉토리> / samples / sampleUffSSD` 디렉토리에서`make`를 실행하여이 샘플을 컴파일하십시오. 
`sample_uff_ssd`라는 바이너리가`<TensorRT 루트 디렉토리> / bin` 디렉토리에 생성됩니다.

cd /usr/src/tensorrt/samples/
sudo make
cd /usr/src/tensorrt/bin/

user@user-desktop:/usr/src/tensorrt/bin$ sudo cp ~/Downloads/ssd_inception_v2_coco_2017_11_17/frozen_inference_graph.uff ../data/ssd/sample_ssd_relu6.uff

user@user-desktop:/usr/src/tensorrt/bin$ sudo ./sample_uff_ssd

sudo ./sample_uff_ssd 

2. trained my model 

user@user-desktop:~/Downloads/pbfiles$ cp /usr/src/tensorrt/samples/sampleUffSSD/config.py ./
user@user-desktop:~/Downloads/pbfiles$ convert-to-uff frozen_inference_graph.pb -O NMS -p config.py


user@user-desktop:/usr/src/tensorrt/data/ssd$ cd ../../samples/
user@user-desktop:/usr/src/tensorrt/samples$ sudo make


user@user-desktop:/usr/src/tensorrt/bin$ sudo rm *.ppm
user@user-desktop:/usr/src/tensorrt/bin$ sudo cp ~/Downloads/pbfiles/frozen_inference_graph.uff ../data/ssd/sample_ssd_relu6.uff
user@user-desktop:/usr/src/tensorrt/bin$ sudo ./sample_uff_ssd


/usr/src/tensorrt/samples/sampleUffSSD$ sudo vim sampleUffSSD.cpp 

427 line

    params.visualThreshold = 0.5;

