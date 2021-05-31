import argparse
import cv2

def inferpytorch(model, image):
    import torch
    from modeling.deeplab import *

    model = DeepLab()
    model.load_state_dict( torch.load(model) )
    model.eval()

    output = model(image)

    return output

def inferonnx(model, image):
    import onnxruntime

    img = cv2.imread(image)

    session = onnxruntime.InferenceSession(model, None)
    inputname = session.get_inputs()[0].name
    outputname = session.get_outputs()[0].name
    result = session.run([outputname], {inputname : img})

    return result

def infertrt(model, image):
    print("I'm going to infer with trt")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument("--platform", type=str, help="infer using pytorch, onnx or trt", choices=["pytorch", "onnx", "trt"])
    parser.add_argument("--image", type=str, help="path to image")
    parser.add_argument("--model", type=str, help="path to model")

    args = parser.parse_args()

    if args.platform == "pytorch":
        inferpytorch(args.image)
    elif args.platform == "onnx":
        inferonnx(args.image)
    elif args.platform == "trt":
        infertrt(args.image)


