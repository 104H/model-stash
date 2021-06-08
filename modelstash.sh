#!/bin/bash
source ~/anaconda3/etc/profile.d/conda.sh

function contains {
    args=("$@")
    x="${args[0]}"

    for i in "${args[@]:1}"
    do
        if [ "$i" == "$1" ]; then
            true; return
        fi
    done

    false; return
}

datasets=("cropweed" "mscoco2017val")
models=("detectron2" "yolov4")
platforms=("pytorch" "onnx" "tensort")

dataset=$1
model=$2
platform=$3

contains $dataset ${datasets[@]}
datasetfound=$?

contains $model ${models[@]}
modelfound=$?

contains $platform ${platforms[@]}
platformfound=$?

#if [ $datasetfound -eq 0 ] && [ $modelfound -eq 0 ] && [ $platformfound -eq 0 ]; then
if [ $modelfound -eq 0 ] && [ $platformfound -eq 0 ]; then
    if [ "$model" == "yolov4" ]; then
        conda activate pytorch-YOLOv4
        cd pytorch-YOLOv4

        if [ $platform == "pytorch" ]; then
            # reads the model from scratch and then perofrms the inference once per image
            for img in "$dataset"/*.jpg
            do
                python3 demo.py -imgfile "${img}"
            done

        elif [ $platform == "onnx" ]; then
            python3 onnxinference.py yolov4_1_3_608_608_static.onnx "$dataset" 1

        else
            echo "Not Implemented"
        fi

    elif [ "$model" == "detectron2" ]; then
        conda activate pytorch-deeplab-xception
        cd pytorch-deeplab-xception

        if [ $platform == "pytorch" ]; then
            CUDA_VISIBLE_DEVICES=0 python3 train.py --backbone resnet --infer --workers 4 --epochs 1 --batch-size 1 --gpu-ids 0 --checkname deeplab-resnet --eval-interval 1 --dataset "$dataset"

        elif [ $platform == "onnx" ]; then
            python3 demo_darknet2onnx.py

        else
            echo "Not Implemented"
        fi
    else
        echo "Not Implemented"
    fi
else
    echo -e "Requested dataset, model, or platform not available.\nOptions for datasets: ${datasets[@]}\nOptions for models: ${models[@]}\nOptions for platforms: ${platforms[@]}"
fi

