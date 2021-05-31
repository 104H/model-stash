from modeling.backbone import resnet, xception, drn, mobilenet

def build_backbone(backbone, in_channels, output_stride, BatchNorm):
    if backbone == 'resnet':
        return resnet.ResNet101(output_stride, in_channels, BatchNorm)
    elif backbone == 'xception':
        return xception.AlignedXception(output_stride, BatchNorm)
    elif backbone == 'drn':
        return drn.drn_d_54(BatchNorm)
    elif backbone == 'mobilenet':
        return mobilenet.MobileNetV2(output_stride, BatchNorm)
    if backbone == 'resnet18':
        return resnet.ResNet18(output_stride, in_channels, BatchNorm)
    if backbone == 'resnet18untrained':
        return resnet.ResNet18(output_stride, in_channels, BatchNorm, False)
    if backbone == 'resnetuntrained':
        return resnet.ResNet101(output_stride, in_channels, BatchNorm, False)
    else:
        raise NotImplementedError
