git clone https://github.com/cocodataset/cocoapi.git
cd cocoapi/PythonAPI
make
cd /tf_ssd/tod/train_models/research
curl -OL https://github.com/google/protobuf/releases/download/v3.2.0/protoc-3.2.0-linux-x86_64.zip
unzip protoc-3.2.0-linux-x86_64.zip -d protoc3
sudo mv protoc3/bin/* /usr/local/bin/
sudo mv protoc3/include/* /usr/local/include/
protoc object_detection/protos/*.proto --python_out=.
python object_detection/builders/model_builder_test.py
