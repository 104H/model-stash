import torch
import torch.onnx
from modeling.deeplab import *

# Define network
model = DeepLab(num_classes = 3,
                backbone = "resnet",
                in_channels = 4,
                output_stride = 16,
                sync_bn = True,
                freeze_bn = True)

pretrainedpath = "/home/robot/hunaid/pytorch-deeplab-xception/run/cropweed/deeplab-resnet/experiment_7/checkpoint.pth.tar"

# Initialize model with the pretrained weights
map_location = lambda storage, loc: storage
if torch.cuda.is_available():
    map_location = None

checkpoint = torch.load(pretrainedpath)

model.load_state_dict(checkpoint['state_dict'])

model.eval()

#dummy_input = torch.randn(10, 3, 224, 224, device='cuda')
dummy_input = torch.randn(1, 4, 513, 513, requires_grad=True)

torch.onnx.export(
        model,
        dummy_input,
        "deeplab-xception.onnx",
        export_params=True,
        input_names = ['input'],
        output_names = ['output'],
        opset_version=11,
        dynamic_axes={'input' : {0 : 'batch_size'},    # variable length axes
                      'output' : {0 : 'batch_size'}}
        , verbose=True)

