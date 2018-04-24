---
layout: post
title: Python3.6实现编码图像（ppm和jpg）的输出
categories: BasicAlgorithm
description: 输入二进制码，根据不同的编码，输出电压波形
keywords: Algorithm, IoT, 编解码
---

> 原创
> 
> 转载请注明出处，侵权必究。

## 1、反向不归零（NRZ）

反向不归零编码用高电平表示二进制的1，用低电平表示二进制的0。

<img src="/images/posts/2018-4-24-BasiAlgorithm-Encoder-and-Decoder-of-IoT/NRZ.png" width="600" alt="NRZ的图像" />

## 2、曼彻斯特编码
在曼彻斯特编码中，用电压跳变的相位不同来区分1和0，其中从高到低的跳变表示1，从低到高的跳变表示0。

<img src="/images/posts/2018-4-24-BasiAlgorithm-Encoder-and-Decoder-of-IoT/Manchester.png" width="600" alt="Manchester的图像" />

## 3、差动双相（DBP）编码
差动双相编码在半个比特周期中的任意的边沿表示二进制“0”，而没有边沿就是二进制“1”，如下图所示。此外在每个比特周期开始时，电平都要反相。因此，对于接收器来说，位节拍比较容易重建。

<img src="/images/posts/2018-4-24-BasiAlgorithm-Encoder-and-Decoder-of-IoT/DBP.png" width="600" alt="DBP的图像" />

## 4、PIE编码
PIE编码符号有4个，分别是数据0、数据1、数据帧开始SOF和数据帧结束EOF。

<img src="/images/posts/2018-4-24-BasiAlgorithm-Encoder-and-Decoder-of-IoT/PIE.png" width="300" alt="PIE的图像" />

## 5、Python3.6实现效果和代码
效果1：

<img src="/images/posts/2018-4-24-BasiAlgorithm-Encoder-and-Decoder-of-IoT/face1.png" width="400" alt="效果1" />

图像输出（包括jpg和ppm）：

<img src="/images/posts/2018-4-24-BasiAlgorithm-Encoder-and-Decoder-of-IoT/face2.png" width="600" alt="效果2" />

```
import numpy as np
from PIL import Image
import sys

# 异常
class StringError(Exception):
    def __init__(self,err):
        Exception.__init__(self)
        self.err=err
        
def getNRZ(binum,line_pixes=3,bi_pixes=90,pic_height=400,y_max=350,y_min=50):
    """
    反向不归零编码（NRZ）
    binum:输入的二进制码
	line_pixes:线的宽度（像素）；bi_pixes：1位编码的宽度；pic_height图片高；y_max：线的最高点；y_min线的最低点
    """
    last_bi = '2' #存储上一次数据，2表示刚开始
    pic_np = np.ones((bi_pixes * (len(binum)+1),pic_height),dtype=np.int)
    for index,item in enumerate(binum):
        try:
            if last_bi != item and last_bi != 2:
                pic_np[(index*bi_pixes - line_pixes):(index*bi_pixes + line_pixes),y_min:y_max]=0
                
            if item == '1':	# 1划横线
                pic_np[index*bi_pixes:(index+1)*bi_pixes,(y_max-line_pixes):(y_max+line_pixes)]=0
                last_bi = '1'
            elif item == '0':
                pic_np[index*bi_pixes:(index+1)*bi_pixes,(y_min-line_pixes):(y_min+line_pixes)]=0
                last_bi = '0' 
            else:
                raise StringError('\r\n!!!  ERROR  !!! :  Your binary string is NOT 0 or 1')
        except StringError as var:
            print(var.err)
            sys.exit()

    return  pic_np      
    
def getManchester(binum,line_pixes=3,bi_pixes=90,pic_height=400,y_max=350,y_min=50):
    """
    曼彻斯特（Manchester）编码
    binum:输入的二进制码
	line_pixes:线的宽度（像素）；bi_pixes：1位编码的宽度；pic_height图片高；y_max：线的最高点；y_min线的最低点
    """
    last_bi = '2' #存储上一次数据，2表示刚开始
    pic_np = np.ones((bi_pixes * (len(binum)+1),pic_height),dtype=np.int8)
    for index,item in enumerate(binum):
        try:
            if last_bi == item and last_bi != '2':
                pic_np[(index*bi_pixes - line_pixes):(index*bi_pixes + line_pixes),y_min:y_max]=0
                
            if item == '1':	# 1划横线
                pic_np[index*bi_pixes:(2*index+1)*bi_pixes//2,(y_max-line_pixes):(y_max+line_pixes)]=0
                pic_np[(2*index+1)*bi_pixes//2:(index+1)*bi_pixes,(y_min-line_pixes):(y_min+line_pixes)]=0
                pic_np[((2*index+1)*bi_pixes//2 - line_pixes):((2*index+1)*bi_pixes//2 + line_pixes),y_min:y_max]=0
                last_bi = '1'
            elif item == '0':
                pic_np[index*bi_pixes:(2*index+1)*bi_pixes//2,(y_min-line_pixes):(y_min+line_pixes)]=0
                pic_np[(2*index+1)*bi_pixes//2:(index+1)*bi_pixes,(y_max-line_pixes):(y_max+line_pixes)]=0
                pic_np[((2*index+1)*bi_pixes//2 - line_pixes):((2*index+1)*bi_pixes//2 + line_pixes),y_min:y_max]=0
                last_bi = '0'
            else:
                raise StringError('\r\n!!!  ERROR  !!! :  Your binary string is NOT 0 or 1')
        except StringError as var:
            print(var.err)
            sys.exit()	
    return  pic_np   

def getDBP(binum,line_pixes=3,bi_pixes=90,pic_height=400,y_max=350,y_min=50):
    """
    差动双相（DBP）编码
    binum:输入的二进制码
	line_pixes:线的宽度（像素）；bi_pixes：1位编码的宽度；pic_height图片高；y_max：线的最高点；y_min线的最低点
    """
    last_level = 0 #存储上一次最后的电平，0表示刚开始
    pic_np = np.ones((bi_pixes * (len(binum)+1),pic_height),dtype=np.int8)
    for index,item in enumerate(binum):
        try:
            if item == '1':	# 1划横线
                if last_level == 0:
                    pic_np[index*bi_pixes:(index+1)*bi_pixes,(y_max-line_pixes):(y_max+line_pixes)] = 0
                    last_level = 1
                else :
                    pic_np[index*bi_pixes:(index+1)*bi_pixes,(y_min-line_pixes):(y_min+line_pixes)] = 0
                    last_level = 0
            elif item == '0':
                if last_level == 0:
                    pic_np[index*bi_pixes:(2*index+1)*bi_pixes//2,(y_max-line_pixes):(y_max+line_pixes)] = 0
                    pic_np[(2*index+1)*bi_pixes//2:(index+1)*bi_pixes,(y_min-line_pixes):(y_min+line_pixes)] = 0
                    pic_np[((2*index+1)*bi_pixes//2 - line_pixes):((2*index+1)*bi_pixes//2 + line_pixes),y_min:y_max] = 0
                    last_level = 0
                else :
                    pic_np[index*bi_pixes:(2*index+1)*bi_pixes//2,(y_min-line_pixes):(y_min+line_pixes)] = 0
                    pic_np[(2*index+1)*bi_pixes//2:(index+1)*bi_pixes,(y_max-line_pixes):(y_max+line_pixes)] = 0
                    pic_np[((2*index+1)*bi_pixes//2 - line_pixes):((2*index+1)*bi_pixes//2 + line_pixes),y_min:y_max] = 0
                    last_level = 1  
            else:
                raise StringError('\r\n!!!  ERROR  !!! :  Your binary string is NOT 0 or 1')
        except StringError as var:
            print(var.err)
            sys.exit()
        pic_np[((index+1)*bi_pixes- line_pixes):((index+1)*bi_pixes + line_pixes),y_min:y_max] = 0
        
    return  pic_np  


def getPIE(binum,line_pixes=2,bi_pixes=40,pic_height=200,y_max=150,y_min=50):
    """
    PIE编码
    binum:输入的二进制码
	line_pixes:线的宽度（像素）；bi_pixes：1位编码的宽度；pic_height图片高；y_max：线的最高点；y_min线的最低点
    """
	
    Tari = 16    # 电平周期个数，加上SOF和EOF
    for item in binum:
        Tari += (int(item)+1)*2
    pic_np = np.ones((bi_pixes * (Tari+1),pic_height),dtype=np.int8)
    
	# SOF
    pic_np[0:line_pixes,y_min:y_max] = 0
    pic_np[0:bi_pixes,(y_min-line_pixes):(y_min+line_pixes)] = 0
     
    pic_np[bi_pixes-line_pixes:bi_pixes+line_pixes,y_min:y_max] = 0
    pic_np[bi_pixes:2*bi_pixes,(y_max-line_pixes):(y_max+line_pixes)] = 0
    
    pic_np[2*bi_pixes-line_pixes:2*bi_pixes+line_pixes,y_min:y_max] = 0
    pic_np[2*bi_pixes:3*bi_pixes,(y_min-line_pixes):(y_min+line_pixes)] = 0
    
    pic_np[3*bi_pixes-line_pixes:3*bi_pixes+line_pixes,y_min:y_max] = 0
    pic_np[3*bi_pixes:8*bi_pixes,(y_max-line_pixes):(y_max+line_pixes)] = 0  
    
    pic_np[8*bi_pixes-line_pixes:8*bi_pixes+line_pixes,y_min:y_max] = 0
	
	# 0和1
    idx = 8 #用于保存运行完高低电平后的下标
    for index,item in enumerate(binum):
        try:
            if item == '1':	# 1划横线
                pic_np[idx*bi_pixes-line_pixes:idx*bi_pixes+line_pixes,y_min:y_max] = 0
                pic_np[(1+idx)*bi_pixes-line_pixes:(1+idx)*bi_pixes+line_pixes,y_min:y_max] = 0
                pic_np[(4+idx)*bi_pixes-line_pixes:(4+idx)*bi_pixes+line_pixes,y_min:y_max] = 0
                pic_np[idx*bi_pixes:(1+idx)*bi_pixes,y_min-line_pixes:y_min+line_pixes] = 0
                pic_np[(1+idx)*bi_pixes:(4+idx)*bi_pixes,y_max-line_pixes:y_max+line_pixes] = 0
                idx += 4
            elif item == '0':
                pic_np[idx*bi_pixes-line_pixes:idx*bi_pixes+line_pixes,y_min:y_max] = 0
                pic_np[(1+idx)*bi_pixes-line_pixes:(1+idx)*bi_pixes+line_pixes,y_min:y_max] = 0
                pic_np[(2+idx)*bi_pixes-line_pixes:(2+idx)*bi_pixes+line_pixes,y_min:y_max] = 0
                pic_np[idx*bi_pixes:(1+idx)*bi_pixes,y_min-line_pixes:y_min+line_pixes] = 0 
                pic_np[(1+idx)*bi_pixes:(2+idx)*bi_pixes,y_max-line_pixes:y_max+line_pixes] = 0
                idx += 2
            else:
                raise StringError('\r\n!!!  ERROR  !!! :  Your binary string is NOT 0 or 1')
        except StringError as var:
            print(var.err)
            sys.exit()
	# EOF
    pic_np[idx*bi_pixes-line_pixes:idx*bi_pixes+line_pixes,y_min:y_max] = 0
    pic_np[idx*bi_pixes:idx*bi_pixes+bi_pixes,(y_min-line_pixes):(y_min+line_pixes)] = 0
    pic_np[idx*bi_pixes+bi_pixes-line_pixes:(idx+1)*bi_pixes+line_pixes,y_min:y_max] = 0
    pic_np[(idx+1)*bi_pixes:(idx+8)*bi_pixes,(y_max-line_pixes):(y_max+line_pixes)] = 0  
      
    return  pic_np  
# 输入二进制
binum = input("Please input your binary string: ") 
print("You input \""+binum+"\"")

## NRZ  
img = Image.fromarray(getNRZ(binum).T*255.0)
img = img.convert('L')
img = img.transpose(Image.FLIP_TOP_BOTTOM) 
img.save('NRZ.ppm')
img.save('NRZ.jpg')
img.show()

##Manchester
img = Image.fromarray(getManchester(binum).T*255.0)
img = img.convert('L')
img = img.transpose(Image.FLIP_TOP_BOTTOM) 
img.save('Manchester.ppm')
img.save('Manchester.jpg')
img.show()

##DBP
img = Image.fromarray(getDBP(binum).T*255.0)
img = img.convert('L')
img = img.transpose(Image.FLIP_TOP_BOTTOM) 
img.save('DBP.ppm')
img.save('DBP.jpg')
img.show()

#PIE
img = Image.fromarray(getPIE(binum).T*255.0)
img = img.convert('L')
img = img.transpose(Image.FLIP_TOP_BOTTOM) 
img.save('PIE.ppm')
img.save('PIE.jpg')
img.show()

```