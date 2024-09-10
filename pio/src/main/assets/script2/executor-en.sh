#!/bin/sh
#改上面一行指定解释器
script_path="$1"
export EXECUTOR_PATH="$({EXECUTOR_PATH})"
export START_DIR="$({START_DIR})"
export TEMP_DIR="$({TEMP_DIR})"
export ANDROID_UID="$({ANDROID_UID})"
export ANDROID_SDK="$({ANDROID_SDK})"
export SDCARD_PATH="$({SDCARD_PATH})"
export BUSYBOX="$({BUSYBOX})"
export APP_USER_ID="$({APP_USER_ID})"
# ROOT_PERMISSION 取值为：true 或 false
export ROOT_PERMISSION=$({ROOT_PERMISSION})
# 修复非ROOT权限执行脚本时，无法写入默认的缓存目录 /data/local/tmp
export TMPDIR="$TEMP_DIR"
export XBJ="$TEMP_DIR/.xm"
# 语言
export TEXT_LANG=en
# toolkit工具目录
export bin="$({TOOLKIT})"
export TOOLKIT="$({TOOLKIT})"
[ -f $bin/environment.sh ]&&source $bin/environment.sh
#工具目录
if [ "$ROOT_PERMISSION" == "true" ];then
export mdir="/data/local/MIO"
else
export mdir="$START_DIR/MIO"
fi
export zml="$SDCARD_PATH/MIO"
if [ ! -d "$zml" ]; then
mkdir $zml
fi
if [ ! -d "$mdir" ]; then
mkdir $mdir
fi
export LD_LIBRARY_PATH=$START_DIR/bin/:/data/data/com.mio.kitchen/files/bin
# 添加toolkit添加为应用程序目录
if [[ ! "$TOOLKIT" = "" ]]; then
    # export PATH="$PATH:$TOOLKIT"
    PATH="$TOOLKIT:$PATH"
fi

# 判断是否有指定执行目录，跳转到起始目录
if [[ "$START_DIR" != "" ]] && [[ -d "$START_DIR" ]]
then
    cd "$START_DIR"
fi
# 运行脚本
if [[ -f "$script_path" ]]; then
    chmod 755 "$script_path"
    source "$script_path"
else
    echo "${script_path} is missing" 1>&2
fi
# python3 and img2sdat
if [ ! -d "/data/local/py" ]; then
    echo "installing python3..." 1>&2
    cd $bin
    mkdir -p "/data/local/py"
    unzip python3.zip -d /data/local/py > /dev/null 2>&1
fi
if [ ! -d "/data/local/img2sdat" ]; then
    echo "extract img2sdat..." 1>&2
    cd $bin
    mkdir -p "/data/local/img2sdat"
    unzip img2sdat.zip -d /data/local/img2sdat > /dev/null 2>&1
fi
# end python3 & img2sdat
