# 为Android编译x264库

该工程为Android编译x264动态链接库。

## 1. 准备工作

- 准备NDK，确保cmake已经安装。
- 下载x264源码。
- 下载此工程。

## 2. 编译步骤

由于x264编译出的so库带有版本号，不适合Android构建，因此要先修改脚本来去掉soname中的版本号。

- 打开`$X264_PATH/configure`文件，找到如下片段并修改：
```shell
else
    echo "SOSUFFIX=so" >> config.mak
    echo "SONAME=libx264.so.$API" >> config.mak # 去掉".$API"，使SONAME=libx264.so
    echo "SOFLAGS=-shared -Wl,-soname,\$(SONAME) $SOFLAGS" >> config.mak
fi
```
- 打开该工程的`build_for_android.sh`文件编辑
- 修改`SOURCE_PATH`为x264的源码目录。
- 修改`NDK`为NDK目录。
- 根据你的操作系统修改`HOST_TAG`。
- 根据你的需求修改`API`。
- 运行`build_for_android.sh`

成功后会将库和头文件都存放在该工程的`android`目录下。

x264的编译脚本会固定编译静态库，如果需要也可以在编译成功后到x264源码目录下找到。