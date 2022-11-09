# PX1 - CoreML of ResNet50 for iOS (as Prototype)


## iPad Pro(12.9inch) / iPhone7

<img src="https://user-images.githubusercontent.com/48679574/200833483-ab335bdf-6451-42e3-a337-f65ad6c5c6b0.gif" width="400" height="600"/><img src="https://user-images.githubusercontent.com/48679574/200834950-8d016e22-9ae3-42a6-9cd1-ee6c8c7967dd.gif" width="400" height="600"/>


## Latency
| Hardware | model | avarage Latency |
| :---         |     :---:      |        ---: |
| iPadPro| Resnet50Int8LUT| 0.058 [ms]|
| iPhone7 | Resnet50Int8LUT| 0.16 [ms]|

## PX1 - putting into action and its info 
<b>info</b>
- image's brightness and image size is not almost influenced to accuracy 
- iPad and iPhone image size are same : Height is 720 width is 1280
- When resize image size to 224 and 128 its Latency is same (not delay and not fast)
- <code>DispatchQueue.main.async()</code> must be adjusted, it will cause crash
