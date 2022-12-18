# 启动图标制作

1. res--->new--->`ImageAsset`

![图标制作](images/图标制作.png)

2. 修改`app/src/main/AndroidManifest.xml` 文件

```xml
 <application
android:icon="@mipmap/campus_launcher"
android:roundIcon="@mipmap/campus_launcher_round"
 </application>
```

# 制作Android Splash闪屏

当我们的APP已经启动但尚未在内存中时，用户点击app图标启动应用程序于实际调用启动程序Activity的`onCreate()`之间可能会有一些延迟，在“冷启动”期间，`WindowManager`尝试使用应用程序主题中的元素（如`windowBackground`）绘制占位符UI。因此，我们可以将其更改为显示启动的drawable, 而不是显示默认的`windowBackground`(通常为白色或黑色)。这样，启动画面仅在需要时显示,而且不会减慢用户启动APP数据。

