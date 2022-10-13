# PX1 - CoreML of ResNet50 for iOS (as Prototype)


## iPad Pro(12.9inch)

<img src="https://user-images.githubusercontent.com/48679574/195619737-44254250-53e2-4456-a935-a18ab4ffe1c9.gif" width="400" height="600"/>


## iPhone7

<img src="https://user-images.githubusercontent.com/48679574/195618598-8226c424-1512-4942-a81b-009193789a9d.gif" width="400" height="600"/>


## Latency
| Hardware | model | avarage Latency |
| :---         |     :---:      |        ---: |
| iPadPro| ResNet50| 17,652,928 [ms]|
| iPhone7 | ResNet50| 12,658,784 [ms]|

## putting into action. its info and agenda
<b>info</b>
- image's brightness and image size is not almost influenced to accuracy 
- iPad and iPhone image size are same : Height is 720 width is 1280
- When resize image size to 224 and 128 its Latency is same (not delay and not fast)
- if <code>DispatchQueue.main.async()</code> must be adjusted, so it will cause crash
