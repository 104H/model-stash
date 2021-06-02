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

if [ $datasetfound -eq 0 ] && [ $modelfound -eq 0 ] && [ $platformfound -eq 0 ]; then
    if [ "$model" == "yolov4" ]; then
        conda activate pytorch-YOLOv4

        if [ $dataset == "mscoco2017val" ] && [ $platform == "pytorch" ]; then
            cd pytorch-YOLOv4
            python3 evaluate_on_coco.py
        elif [ $dataset == "mscoco2017val" ] && [ $platform == "onnx" ]; then
            cd pytorch-YOLOv4
            python3 demo_darknet2onnx.py
        else
            echo "Not Implemented"
        fi
    if [ "$model" == "detectron2" ]; then
        conda activate pytorch-deeplabxception-detectron2

        if [ $dataset == "mscoco2017val" ] && [ $platform == "pytorch" ]; then
            cd pytorch-YOLOv4
            python3 evaluate_on_coco.py
        elif [ $dataset == "mscoco2017val" ] && [ $platform == "onnx" ]; then
            cd pytorch-YOLOv4
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

