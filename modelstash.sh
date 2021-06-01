#!/bin/bash

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

contains $1 ${datasets[@]}
dataset=$?

contains $2 ${models[@]}
model=$?

if [ $dataset -eq 0 ] && [ $model -eq 0 ]; then
    echo "Running your model"
else
    echo -e "Requested dataset or model not available.\nOptions for datasets: ${datasets[@]}\nOptions for models: ${models[@]}"
fi

