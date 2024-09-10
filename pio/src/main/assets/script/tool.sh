#新建项目
[ -e ${XBJ} ] && xm=`cat ${XBJ}`
[ ! -d $mdir/$xm ]&&mkdir -p $mdir/$xm
packzip(){
[[ "${TEXT_LANG}" = "zh" ]] && echo "开始打包ROM:${name}.zip"
[[ "${TEXT_LANG}" = "en" ]] && echo "Creating ROM: ${name}.zip"
[[ "${TEXT_LANG}" = "ja" ]] && echo "ROM を圧縮：${name}.zip"
if [ -z $lj ]; then
  [[ "${TEXT_LANG}" = "zh" ]] && error "请输入路径，打包"
  [[ "${TEXT_LANG}" = "en" ]] && error "Please enter the output path"
  [[ "${TEXT_LANG}" = "ja" ]] && error "出力フォルダを指定してください"
fi
if [ -x $name ]; then
  [[ "${TEXT_LANG}" = "zh" ]] && error "请输入名称，打包"
  [[ "${TEXT_LANG}" = "en" ]] && error "Please enter the ROM name"
  [[ "${TEXT_LANG}" = "ja" ]] && error "ROM 名を入力してください"
fi
if [ "$kxyt" == "1" ] && [ ! -z "$code" ]; then
utils kxyt $zml/$xm/ $bin/extra_flash.zip $code
else
  if [ -z "$code" ]; then
    [[ "${TEXT_LANG}" = "zh" ]] && warn "请输入机型代号"
    [[ "${TEXT_LANG}" = "en" ]] && warn "Please enter the device codename"
    [[ "${TEXT_LANG}" = "ja" ]] && warn "コードネームを入力してください"
  fi
fi
7z a -tzip ${lj}/${name}.zip $zml/$xm/*
if [ $? = 0 ];then
[[ "${TEXT_LANG}" = "zh" ]] && echo "打包完成，输出${lj}/${name}.zip"
[[ "${TEXT_LANG}" = "en" ]] && echo "Done, output is: ${lj}/${name}.zip"
[[ "${TEXT_LANG}" = "ja" ]] && echo "完成、出力：${lj}/${name}.zip"
else
[[ "${TEXT_LANG}" = "zh" ]] && warn "打包失败"
[[ "${TEXT_LANG}" = "en" ]] && warn "Failed to create ZIP"
[[ "${TEXT_LANG}" = "ja" ]] && warn "ZIP の圧縮に失敗しました"
[ -f ${lj}/${name}.zip ]&&rm -rf ${lj}/${name}.zip
fi
}
dg (){
[ -f $zml/$xm/super.img ]&&echo "super.img"
[ -f $zml/$xm/payload.bin ]&&echo "payload.bin"
}
readdt(){
if [ -e $zml/$xm/super.img ];then
utils lpdump $zml/$xm/super.img
fi
if [ -e $zml/$xm/payload.bin ];then
for i in $(utils payload_dump $zml/$xm/payload.bin)
do
  echo "$i"
done
fi
}
extract_part(){
Extract=$zml/image
IFS=$'\n'
[[ ! -d "$Extract" ]] && mkdir -p "$Extract"

for i in ${IMG}; do
    e=${i##*/}
    File="$Extract/${e}.img"
    if [[ ! -L ${i} ]]; then
      [[ "${TEXT_LANG}" = "zh" ]] && echo "！${e}分区不存在无法提取"
      [[ "${TEXT_LANG}" = "en" ]] && echo "！Cannot backup non-existing partition ${e}"
      [[ "${TEXT_LANG}" = "ja" ]] && echo "！存在しないパーティション ${e} をバックアップのはできませんでした"
    fi
    [[ "${TEXT_LANG}" = "zh" ]] && echo "- 开始提取${e}分区"
    [[ "${TEXT_LANG}" = "en" ]] && echo "- Reading back partition ${e}"
    [[ "${TEXT_LANG}" = "ja" ]] && echo "- パーティションのバックアップ開始：${e}"
    dd if="${i}" of="$File"
    [[ "${TEXT_LANG}" = "zh" ]] && echo "- 已提取${e}分区到：${File}"
    [[ "${TEXT_LANG}" = "en" ]] && echo "- Saved ${e} partition image as ${File}"
    [[ "${TEXT_LANG}" = "ja" ]] && echo "- ${e} のイメージを ${File} にセーブした"
    echo
done
}
parts (){
if [[ 0 ]]; then
a=0
b=(`ls /dev/block/`)
    for i in ${b[@]}; do
        [[ -d /dev/block/${i} ]] && unset b[$a]
        a=$((a+1))
    done
        BLOCKDEV=`which blockdev`
    
            find /dev/block -type l | while read o; do
                [[ -d "$o" ]] && continue
                c=`basename "$o"`
                echo ${b[@]} | grep -q "$c" && continue
                echo $c
            done | sort -u | while read Row; do
                BLOCK=`find /dev/block/by-name -name $Row | head -n 1`
                    if [[ -n $BLOCKDEV ]]; then   
                        size=`blockdev --getsize64 $BLOCK`
                        if [[ $size -ge 1073741824 ]]; then
                            File_Type=`awk "BEGIN{print $size/1073741824}"`G
                        elif [[ $size -ge 1048576 ]]; then
                            File_Type=`awk "BEGIN{print $size/1048576}"`MB
                        elif [[ $size -ge 1024 ]]; then
                            File_Type=`awk "BEGIN{print $size/1024}"`kb
                        elif [[ $size -le 1024 ]]; then
                            File_Type=${size}b
                        fi
                       if [[ "$File_Type" != "b" ]]; then
                           [[ "${TEXT_LANG}" = "zh" ]] && echo "${BLOCK}|${Row} 「大小：${File_Type}」"
                           [[ "${TEXT_LANG}" = "en" ]] && echo "${BLOCK}|${Row} 「Size：${File_Type}」"
                           [[ "${TEXT_LANG}" = "ja" ]] && echo "${BLOCK}|${Row} 「サイズ：${File_Type}」"
                       fi
                    else
                        echo "$BLOCK|$Row" 
                    fi
            done
fi
}
tqdgjx(){
if [ -f $zml/$xm/super.img ];then
[ "$(utils utils gettype $zml/$xm/super.img)" = "sparse" ]&&str $zml/$xm/super.img
fi
for i in ${jxs}
do
[[ "${TEXT_LANG}" = "zh" ]] && echo "正在提取${i}"
[[ "${TEXT_LANG}" = "en" ]] && echo "Unpacking: $[i]"
[[ "${TEXT_LANG}" = "ja" ]] && echo "展開中：${i}"
[ "$tqjx" = "super.img" ]&&utils lpunpack $zml/$xm/super.img $zml/$xm/ ${i} 1
[ "$tqjx" = "payload.bin" ]&&utils payload $zml/$xm/payload.bin $zml/$xm/ $i
done
[ $del = 1 ]&&rm -rf $zml/$xm/$tqjx
for i in $(ls *_a.img)
do
[[ "${TEXT_LANG}" = "zh" ]] && echo "重命名$i到$(echo $i|sed 's/_a//g')"
[[ "${TEXT_LANG}" = "en" ]] && echo "Renaming ${i} to $(echo $i|sed 's/_a//g')"
[[ "${TEXT_LANG}" = "ja" ]] && echo "$i を $(echo $i|sed 's/_a//g') にリネーム"
mv $i $(echo $i|sed 's/_a//g')
done
}
cm (){
for i in $(ls -d $START_DIR/module/*/ )
do
basename $i
done
}
flash_img (){
if [[ -z ${IMG} ]]; then
  [[ "${TEXT_LANG}" = "zh" ]] && error "刷入"
  [[ "${TEXT_LANG}" = "en" ]] && error "Flash"
  [[ "${TEXT_LANG}" = "ja" ]] && error "イメージを焼く"
fi
IFS=$'\n'
e=${IMG##*/}
[[ "${TEXT_LANG}" = "zh" ]] && echo "- 您当前选择了${e}分区"
[[ "${TEXT_LANG}" = "en" ]] && echo "- You selected partition: ${e}"
[[ "${TEXT_LANG}" = "ja" ]] && echo "- 選択したパーティション：${e}"
[[ "${TEXT_LANG}" = "zh" ]] && echo "- 刷入文件路径：${Image_to_flash}"
[[ "${TEXT_LANG}" = "en" ]] && echo "- Image File: ${Image_to_flash}"
[[ "${TEXT_LANG}" = "ja" ]] && echo "- イメージファイル：${Image_to_flash}"
[[ "${TEXT_LANG}" = "zh" ]] && echo "- 检测刷入镜像文件是否存在"
[[ "${TEXT_LANG}" = "en" ]] && echo "- Checking whether if the image file exists"
[[ "${TEXT_LANG}" = "ja" ]] && echo "- イメージファイルの存在を確認中"
if [[ ! -L "${IMG}" ]]; then
  [[ "${TEXT_LANG}" = "zh" ]] && error "！${e}分区不存在无法刷入"
  [[ "${TEXT_LANG}" = "en" ]] && error "！Cannot flash to non-existing partition: ${e}"
  [[ "${TEXT_LANG}" = "ja" ]] && error "！存在しないパーティション ${e} を焼くのはできません"
fi
    if [[ -f "$Image_to_flash" ]]; then
        [[ "${TEXT_LANG}" = "zh" ]] && echo "- 开始刷写${e}分区"
        [[ "${TEXT_LANG}" = "en" ]] && echo "- Start flashing partition: ${e}"
        [[ "${TEXT_LANG}" = "ja" ]] && echo "- パーティション ${e} に焼き込み中"
        dd if="$Image_to_flash" of="${IMG}"
        if [[ $CQ = 1 ]]; then
         [[ "${TEXT_LANG}" = "zh" ]] && echo "即将重启到恢复模式，倒计时开始……"
         [[ "${TEXT_LANG}" = "en" ]] && echo "Rebooting to recovery in a few seconds..."
         [[ "${TEXT_LANG}" = "ja" ]] && echo "Recovery モードに再起動します、カウントダウン開始……"
         for i in $(seq 4 -1 1); do
            echo ${i}
            sleep 1
         done
         reboot recovery
         fi
         if [[ $CQ1 = 1 ]]; then
          [[ "${TEXT_LANG}" = "zh" ]] && echo "即将重启手机，倒计时开始……"
          [[ "${TEXT_LANG}" = "en" ]] && echo "Rebooting the device in a few second..."
          [[ "${TEXT_LANG}" = "ja" ]] && echo "装置を再起動します、カウントダウン開始……"
          for i in $(seq 4 -1 1); do
            echo ${i}
            sleep 1
          done
          reboot
         fi
    else
        [[ "${TEXT_LANG}" = "zh" ]] && error "！${Image_to_flash}刷入文件不存在无法刷写到${e}分区，操作"
        [[ "${TEXT_LANG}" = "en" ]] && error "！Cannot flash non-exsting image file ${Image_to_flash} to partition ${e}, operation"
        [[ "${TEXT_LANG}" = "ja" ]] && error "！存在しないイメージファイル ${Image_to_flash} を ${e} パーティションに焼くのはできません、操作"
    fi
    [[ "${TEXT_LANG}" = "zh" ]] && echo "- 完成"
    [[ "${TEXT_LANG}" = "en" ]] && echo "- Done"
    [[ "${TEXT_LANG}" = "ja" ]] && echo "- 完了"
    sleep 2
}
gszh(){
for i in ${IMG}
do
if [ $gs = sparse ];then
if [ "$(utils gettype $zml/$xm/${i}.img)" = "ext" ] || [ "$(utils gettype $zml/$xm/${i}.img)" = "erofs" ] || [ "$(utils gettype $zml/$xm/${i}.img)" = "super" ] ;then
rts $zml/$xm/${i}.img
fi
  if [ "$(utils gettype $zml/$xm/${i}.img)" = "sparse" ]; then
    [[ "${TEXT_LANG}" = "zh" ]] && warn "${i}已是sparse格式"
    [[ "${TEXT_LANG}" = "en" ]] && warn "${i} is already an sparse image"
    [[ "${TEXT_LANG}" = "ja" ]] && warn "${i} はすでに sparse イメージです"
  fi
fi
if [ $gs = raw ];then
if [ "$(utils gettype $zml/$xm/${i}.img)" = "ext" ] || [ "$(utils gettype $zml/$xm/${i}.img)" = "erofs" ] || [ "$(utils gettype $zml/$xm/${i}.img)" = "super" ] ;then
[[ "${TEXT_LANG}" = "zh" ]] && warn "${i}已经为raw镜像"
[[ "${TEXT_LANG}" = "en" ]] && warn "${i} is already a raw image"
[[ "${TEXT_LANG}" = "ja" ]] && warn "${i} はすでに raw イメージです"
fi
[ "$(utils gettype $zml/$xm/${i}.img)" = "sparse" ]&&rts $zml/$xm/${i}.img
fi
if [ $gs = dat ]||[ $gs = br ];then
[ "$(utils gettype $zml/$xm/${i}.img)" = "ext" ]&&rts $zml/$xm/${i}.img
if [ "$(utils gettype $zml/$xm/${i}.img)" = "sparse" ];then
[[ "${TEXT_LANG}" = "zh" ]] && echo "[img]到[dat]:${i}.img"
[[ "${TEXT_LANG}" = "en" ]] && echo "[img] to [dat]:${i}.img"
[[ "${TEXT_LANG}" = "ja" ]] && echo "[img] を [dat] に変換：${i}.img"
python3 /data/local/img2sdat/img2sdat.py $zml/$xm/${i}.img $zml/$xm/ 4
if [ -f $zml/$xm/${i}.new.dat ];then
[ $del = 1 ]&&rm -rf $zml/$xm/${i}.img
fi
fi
if [ $gs = br ];then
[[ "${TEXT_LANG}" = "zh" ]] && echo "[dat]到[br]:${i}.new.dat"
[[ "${TEXT_LANG}" = "en" ]] && echo "[dat] to [br]:${i}.new.dat"
[[ "${TEXT_LANG}" = "ja" ]] && echo "[dat] を [br] に変換：${i}.new.dat"
brotli -q $brlv -j -w 24 $zml/$xm/${i}.new.dat -o $zml/$xm/${i}.new.dat.br
if [ -f $zml/$xm/${i}.new.dat.br ];then
[ $del = 1 ]&&rm -rf $zml/$xm/${i}.new.dat
fi
fi
fi
done
}
warn () {
echo "$1" >&2
}
download (){
if [ -z $romdz ];then
[[ "${TEXT_LANG}" = "zh" ]] && warn 请输入有效内容
[[ "${TEXT_LANG}" = "en" ]] && warn 'The download link cannot be empty'
[[ "${TEXT_LANG}" = "ja" ]] && warn 'ダウンロードリンクを入力してください'
exit 1
fi
rname=$(basename $romdz | sed -E 's/^([^?]+)[?].+$/\1/')
if [ -e $zml/$rname ];then
[[ "${TEXT_LANG}" = "zh" ]] && warn "您似乎已经下载了这个文件"
[[ "${TEXT_LANG}" = "en" ]] && warn "It appears that this file is already downloaded"
[[ "${TEXT_LANG}" = "ja" ]] && warn "このファイルはすでにダウンロード済みのようですが"
[[ "${TEXT_LANG}" = "zh" ]] && echo "要重新下载吗"
[[ "${TEXT_LANG}" = "en" ]] && echo "Remove it and re-download?"
[[ "${TEXT_LANG}" = "ja" ]] && echo "削除して再ダウンロードしますか"
if pd;then
rm -rf $zml/$rname
else
[[ "${TEXT_LANG}" = "zh" ]] && echo "跳过"
[[ "${TEXT_LANG}" = "en" ]] && echo "Skip"
[[ "${TEXT_LANG}" = "ja" ]] && echo "スキップ"
if [ $jb = 1 ];then
[[ "${TEXT_LANG}" = "zh" ]] && echo "要解包这个文件吗"
[[ "${TEXT_LANG}" = "en" ]] && echo "Do you want to extract the file?"
[[ "${TEXT_LANG}" = "ja" ]] && echo "ファイルを解凍しますか？"
if pd;then
xzrom=$zml/$rname
UZ
else
[[ "${TEXT_LANG}" = "zh" ]] && echo "跳过解包"
[[ "${TEXT_LANG}" = "en" ]] && echo "Skip extracting"
[[ "${TEXT_LANG}" = "ja" ]] && echo "解凍をスキップ"
fi
fi
exit 0
fi
fi
[[ "${TEXT_LANG}" = "zh" ]] && echo "已开启最大速率"
[[ "${TEXT_LANG}" = "en" ]] && echo "Your file is being downloaded at crazy speed"
[[ "${TEXT_LANG}" = "ja" ]] && echo "驚異的な速さでファイルをダウンロードします"
curl -# -L -k $romdz -o $zml/$rname
if [ $? = 1 ];then
[[ "${TEXT_LANG}" = "zh" ]] && error "下载失败"
[[ "${TEXT_LANG}" = "en" ]] && error "Download failed"
[[ "${TEXT_LANG}" = "ja" ]] && error "ダウンロードに失敗しました"
rm -rf $zml/$rname
elif [ $jb = 1 ];then
xzrom=$zml/$rname
UZ
fi
}
error (){
[[ "${TEXT_LANG}" = "zh" ]] && echo "$1 失败，请截图联系群主">&2
[[ "${TEXT_LANG}" = "en" ]] && echo "$1 failed, please report this bug with a screenshot to the group owner">&2
[[ "${TEXT_LANG}" = "ja" ]] && echo "$1 に失敗しました、バグを報告するには、スクリーンショットをグループオーナーに送信してください">&2
exit 1
}
make_ext4 (){
[ ${img_type} = sparse ] && argv=-s
make_ext4fs -J -T 1 $argv -S $con -l $size -C $fs -L $1 -a $1 $zml/$xm/$1.img $mdir/$xm/$1
if [ $? = 1 ]; then
  [[ "${TEXT_LANG}" = "zh" ]] && error '打包'
  [[ "${TEXT_LANG}" = "en" ]] && error 'Pack'
  [[ "${TEXT_LANG}" = "ja" ]] && error '再構築'
fi
if [ $jxys = 1 ];then
if [ ${i}mg_type = raw ];then
resize2fs -M $zml/$xm/$1.img
else
[[ "${TEXT_LANG}" = "zh" ]] && warn '您已打包为sparse，无法压缩'
[[ "${TEXT_LANG}" = "en" ]] && warn 'Output format is already a sparse image, skipping resizing the image'
[[ "${TEXT_LANG}" = "ja" ]] && warn '出力フォーマットは sparse、イメージのリサイズをスキップします'
fi
fi
}
mkeimg (){
	size2=`echo $size/4096|bc|cut -d "." -f 1`
	bin/mke2fs -O ^has_journal -t ext4 -b 4096 -L $1 -I 256 -M /$1 $zml/$xm/$1.img $size2
	[ "$Reading" = "ro" ] && dx=-s
	bin/e2fsdroid -e -T 1230768000 -C $fs -S $con -f $mdir/$xm/$1 -a /$1 $dx $zml/$xm/$1.img
  if [ $? = 1 ];then
  error 打包
  rm -rf $zml/$xm/$1.img
  fi
  [ $jxys = 1 ]&&resize2fs -M $zml/$xm/$1.img
  [ ${i}mg_type = sparse ] && rts $zml/$xm/$1.img
}
packsuper (){
if [ "$type" = "A" ];then
command+="--metadata-size 65536 -super-name super -metadata-slots 2 -device super:${super_size} --group ${super_group}:${super_size} "
fi
for i in ${simg}
do
[ "$(utils gettype $zml/$xm/${i}.img)" = "sparse" ]&&str $zml/$xm/${i}.img
if [ "$(utils gettype $zml/$xm/${i}.img)" = "erofs" ]||[ "$(utils gettype $zml/$xm/${i}.img)" = "ext" ];then
[ "$type" = "A" ]&&command+="--partition ${i}:readonly:$(wc -c <$zml/$xm/${i}.img):${super_group} --image ${i}=$zml/$xm/${i}.img "
if [ "$type" = "AB" ]||[ "$type" = "VAB" ];then
ml1+="--partition ${i}_a:readonly:$(wc -c <$zml/$xm/${i}.img):${super_group}_a --image ${i}_a=$zml/$xm/${i}.img "
ml2+="--partition ${i}_b:readonly:0:${super_group}_b "
fi
fi
done
if [ "$type" = "AB" ]||[ "$type" = "VAB" ];then
command+="--metadata-size 65536 -super-name super -metadata-slots 3 -device super:${super_size} --group ${super_group}_a:${super_size} ${ml1} --group ${super_group}_b:${super_size} ${ml2} "
fi
[ "$type" = "VAB" ]&&command+="--virtual-ab "
[ "$from" = "sparse" ]&&command+="--sparse "
lpmake $command --out $zml/$xm/super.img
if [ $? = 0 ];then
[[ "${TEXT_LANG}" = "zh" ]] && echo " - 打包成功！"
[[ "${TEXT_LANG}" = "en" ]] && echo " - Packed successfully"
[[ "${TEXT_LANG}" = "ja" ]] && echo " - 再構築に成功しました"
else
[[ "${TEXT_LANG}" = "zh" ]] && error " - 打包super"
[[ "${TEXT_LANG}" = "en" ]] && error " - Pack super"
[[ "${TEXT_LANG}" = "ja" ]] && error " - superの再構築"
fi
}
findfile (){
for i in $(ls $zml/$xm/*.$1)
do
basename ${i} .$1
done
}
readsize (){
if [ -f $zml/$xm/dynamic_partitions_op_list ];then
list=$zml/$xm/dynamic_partitions_op_list
else
list=/dev/null
fi
if [ "$psize" = "auto" ];then
size=$(utils rsize $mdir/$xm/${1} 1 $list)
else
if [ -e $mdir/$xm/config/${1}_size.txt ]; then
size=$(cat $mdir/$xm/config/${1}_size.txt)
else
[[ "${TEXT_LANG}" = "zh" ]] && warn "镜像大小配置不存在，切换为动态读取"
[[ "${TEXT_LANG}" = "en" ]] && warn "Image size is unknown, determining from file size"
[[ "${TEXT_LANG}" = "ja" ]] && warn "イメージサイズは不明です、ファイルから取得します"
size=$(utils rsize $mdir/$xm/${1} 1 $list)
fi
size=$(utils rsize $mdir/$xm/${1} 1 $list)
fi
}
mkerofs (){
	mkfs.erofs -z${type},${fze} -T 1230768000 --mount-point=/$1 --fs-config-file=$fs --file-contexts=$con $zml/$xm/${i}.img $mdir/$xm/${i}
}
pack(){
for i in ${UIMGS};do
xmdz=`cat ${XBJ}`
fs=$mdir/$xm/config/"${i}"_fs_config
con=$mdir/$xm/config/"${i}"_file_contexts
utils patch_fs_con $mdir/$xm/${i} $fs $con
[[ "${TEXT_LANG}" = "zh" ]] && echo " - 正在打包${i}"
[[ "${TEXT_LANG}" = "en" ]] && echo " - Packing ${i}"
[[ "${TEXT_LANG}" = "ja" ]] && echo " - 再構築中：${i}"
readsize "${i}"
if [ ! -f $mdir/$xm/config/${i}_erofs ];then
if [ "$zhua" != "1" ];then
$dbfs "${i}"
else
mkerofs "${i}"
fi
else
if [ "$zhua" != "1" ];then
mkerofs "${i}"
else
$dbfs "${i}"
fi
fi
if [ -f $zml/$xm/${i}.img ];then
[[ "${TEXT_LANG}" = "zh" ]] && echo " - 打包${i}完成"
[[ "${TEXT_LANG}" = "en" ]] && echo " - Successfully packed ${i}"
[[ "${TEXT_LANG}" = "ja" ]] && echo " - ${i} の再構築完了"
[ $del = 1 ]&&rm -rf $mdir/$xm/$i
else
  if [ $? = 1 ]; then
    [[ "${TEXT_LANG}" = "zh" ]] && warn "打包失败，不删除源文件"
    [[ "${TEXT_LANG}" = "en" ]] && warn "Failed to repack, keeping the source file"
    [[ "${TEXT_LANG}" = "ja" ]] && warn "再構築に失敗しました、ソースファイルを保持します"
  fi
fi
done
}
rts (){
[[ "${TEXT_LANG}" = "zh" ]] && echo "[raw]到[sparse]:$(basename $1)"
[[ "${TEXT_LANG}" = "en" ]] && echo "[raw] to [sparse]:$(basename $1)"
[[ "${TEXT_LANG}" = "ja" ]] && echo "[raw] を [sparse] に変換：$(basename $1)"
img2simg $1 $1_sparse
[ -e "$1"_sparse ] && rm -rf $1
mv "$1"_sparse $1
}
str (){
[[ "${TEXT_LANG}" = "zh" ]] && echo "[sparse]到[raw]：$(basename $1)"
[[ "${TEXT_LANG}" = "en" ]] && echo "[sparse] to [raw]：$(basename $1)"
[[ "${TEXT_LANG}" = "ja" ]] && echo "[sparse] を [raw] に変換：$(basename $1)"
utils simg2img "$1"
}
mn () {
if [ -d $zml/"$xmmc" -o -d $mdir/"$xmmc" ]; then
  [[ "${TEXT_LANG}" = "zh" ]] && echo "- 项目已存在，将自动重命名！"
  [[ "${TEXT_LANG}" = "en" ]] && echo "- Project exists, appending a suffix!"
  [[ "${TEXT_LANG}" = "ja" ]] && echo "- この名前のプロジェクトはすでに存在しています、新しい名前を使用して続けます"
  xmmc="$xmmc"-`date "+%Y%m%d%H%M%S"`
fi
[[ "${TEXT_LANG}" = "zh" ]] && echo "- 正在创建：${xmmc}"
[[ "${TEXT_LANG}" = "en" ]] && echo "- Making directory：${xmmc}"
[[ "${TEXT_LANG}" = "ja" ]] && echo "- ディレクトリを作成：${xmmc}"
mkdir -p $zml/"$xmmc"
mkdir -p $mdir/"$xmmc"
[[ "${TEXT_LANG}" = "zh" ]] && echo "- 创建完成！"
[[ "${TEXT_LANG}" = "en" ]] && echo "- Done！"
[[ "${TEXT_LANG}" = "ja" ]] && echo "- 完成！"
echo ${xmmc} > ${XBJ}
}
pd (){
if [ $(id -u ) = 0 ];then
[[ "${TEXT_LANG}" = "zh" ]] && echo "音量键选择"
[[ "${TEXT_LANG}" = "en" ]] && echo "Use volume keys to select"
[[ "${TEXT_LANG}" = "ja" ]] && echo "音量キーで選択してください"
else
[[ "${TEXT_LANG}" = "zh" ]] && warn "您正在使用非Root模式，默认选择否"
[[ "${TEXT_LANG}" = "en" ]] && warn "Device is not ROOTED, defaulting to NO"
[[ "${TEXT_LANG}" = "ja" ]] && warn "この装置はROOT化されていませんなので、デフォルトで NO にします"
return 1
exit 0
fi
[[ "${TEXT_LANG}" = "zh" ]] && echo "[+]是 [-]否"
[[ "${TEXT_LANG}" = "en" ]] && echo "[+]Yes [-]No"
[[ "${TEXT_LANG}" = "ja" ]] && echo "[+]はい [-]いいえ"
key=$(getevent -qlc 1)
sleep 0.2
Up=$(echo $key |grep KEY_VOLUMEUP)
Down=$(echo $key |grep KEY_VOLUMEDOWN)
	[ "$Up" != "" ] && return 0
	[ "$Down" != "" ] && return 1
}
install_module (){
mkdir -p $START_DIR/module
7z x -y $file -o$START_DIR/module
chmod -R 755 $START_DIR/module/
for var in $(find $START_DIR/module/ -name install.sh);do
source $var
rm -rf $var
done
}
finddir () {
for i in $(ls -d $2/*/)
do
basename ${i}
done
}
#查看项目
check () {
for i in $(ls -d $zml/*/);do
basename ${i}
done
}
lsmdir () {
for imgs in $(ls -d $mdir/$xm/*/);do
[ -e $mdir/$xm/config/$(basename ${imgs})_file_contexts ] && basename ${imgs}
done
}
zy () {
if [ ! -d $zml/$xm ] || [ -z $xm ];then
[[ "${TEXT_LANG}" = "zh" ]] && echo "请选择一个正确的项目"
[[ "${TEXT_LANG}" = "en" ]] && echo "Please select an existing project"
[[ "${TEXT_LANG}" = "ja" ]] && echo "プロジェクトを選択してください"
else
[[ "${TEXT_LANG}" = "zh" ]] && echo "当前选择：${xm}"
[[ "${TEXT_LANG}" = "en" ]] && echo "Selected：${xm}"
[[ "${TEXT_LANG}" = "ja" ]] && echo "プロジェクト：${xm}"
fi
}
unlock (){
if [ ! -d $zml/$xm ] || [ -z $xm ];then
[[ "${TEXT_LANG}" = "zh" ]] && echo "请重新选择项目"
[[ "${TEXT_LANG}" = "en" ]] && echo "Please re-select the project"
[[ "${TEXT_LANG}" = "ja" ]] && echo "プロジェクトをもう一度選択してください"
else
echo 'unlocked'
fi
}
#删除项目
del () {
for i in ${xms};do
[[ "${TEXT_LANG}" = "zh" ]] && echo "- 正在删除：${i}"
[[ "${TEXT_LANG}" = "en" ]] && echo "- Removing project: ${i}"
[[ "${TEXT_LANG}" = "ja" ]] && echo "- プロジェクトを削除：${i}"
rm -rf $zml/${i}
rm -rf $mdir/${i}
[[ "${TEXT_LANG}" = "zh" ]] && echo "- 删除${i}完成"
[[ "${TEXT_LANG}" = "en" ]] && echo "- Removed ${i}"
[[ "${TEXT_LANG}" = "ja" ]] && echo "- ${i} を削除した"
done
}
UZ (){
name=$(basename "$xzrom" .zip)
if [ -d $zml/$name -o -d $mdir/$name ]; then
name="$name"-`date "+%Y%m%d%H%M%S"`
mkdir -p $zml/$name
mkdir -p $mdir/$name
else
mkdir -p $zml/$name
mkdir -p $mdir/$name
fi
[[ "${TEXT_LANG}" = "zh" ]] && echo "- 开始解包${xzrom}"
[[ "${TEXT_LANG}" = "en" ]] && echo "- Extracting: ${xzrom}"
[[ "${TEXT_LANG}" = "ja" ]] && echo "- 展開開始：${xzrom}"
7z x "$xzrom" -o$zml/$name
[[ "${TEXT_LANG}" = "zh" ]] && echo "- 完成"
[[ "${TEXT_LANG}" = "en" ]] && echo "- Done"
[[ "${TEXT_LANG}" = "ja" ]] && echo "- 完成"
echo $name > ${XBJ}
[ $del = 1 ]&&rm -rf "$xzrom"
}
ubdi (){
if [ -f "$1".new.dat.br ];then
[[ "${TEXT_LANG}" = "zh" ]] && echo " - 正在解包："$1".new.dat.br"
[[ "${TEXT_LANG}" = "en" ]] && echo " - Decompressing: "$1".new.dat.br"
[[ "${TEXT_LANG}" = "ja" ]] && echo " - 解凍中："$1".new.dat.br"
brotli -dj "$1".new.dat.br
rm -rf "$1".new.dat.br
fi
if [ -e "$1".new.dat.1 ];then
    [[ "${TEXT_LANG}" = "zh" ]] && echo " - 正在合并 $1"
    [[ "${TEXT_LANG}" = "en" ]] && echo " - Merging $1"
    [[ "${TEXT_LANG}" = "ja" ]] && echo " - 再結合中：$1"
    cat $zml/$xm/"$1".new.dat.{1..99} 2>/dev/null >> $zml/$xm/${1}.new.dat
    rm -rf $zml/$xm/${1}.new.dat.{1..99}
fi
if [  -f "$1".new.dat ];then
[[ "${TEXT_LANG}" = "zh" ]] && echo " - 正在解包："$1".new.dat"
[[ "${TEXT_LANG}" = "en" ]] && echo " - Unpacking: "$1".new.dat"
[[ "${TEXT_LANG}" = "ja" ]] && echo " - 展開中："$1".new.dat"
utils sdat2img "$1".transfer.list "$1".new.dat "$1".img
rm -rf "$1".transfer.list "$1".new.dat "$1".patch.dat
fi
if [ -f ${i}.img ];then
if [[ $(utils gettype "$1".img) = sparse ]]; then
str "$1".img
fi
if [[ $(utils gettype "$1".img) = ext ]]; then
[[ "${TEXT_LANG}" = "zh" ]] && echo " - 正在解包[IMG]："$1".img"
[[ "${TEXT_LANG}" = "en" ]] && echo " - Unpacking[IMG]: "$1".img"
[[ "${TEXT_LANG}" = "ja" ]] && echo " - 展開中[IMG]："$1".img"
utils extract_ext $mdir/"$xm"/ $zml/$xm/"$1".img
fi
if [[ $(utils gettype "$1".img) = erofs ]]; then
[[ "${TEXT_LANG}" = "zh" ]] && echo " - 正在解包[EROFS]：${1}.img"
[[ "${TEXT_LANG}" = "en" ]] && echo " - Unpacking[EROFS]: ${1}.img"
[[ "${TEXT_LANG}" = "ja" ]] && echo " - 展開中[EROFS]：${1}.img"
extract.erofs -i $zml/$xm/"$1".img -o $mdir/$xm/ -x
echo "erofs" > $mdir/$xm/config/${1}_erofs
fi
[ -d $mdir/$xm/"$1" ] && rm -rf "$1".img
fi
}
UN (){
project=$zml/$xm/
cd $project
for i in $(ls *.*|cut -d "." -f 1);
	do
ubdi ${i}
done
exit 0
}
delmod (){
for i in ${mod}
do
[[ "${TEXT_LANG}" = "zh" ]] && echo "正在移除${i}"
[[ "${TEXT_LANG}" = "en" ]] && echo "Uninstalling ${i}"
[[ "${TEXT_LANG}" = "ja" ]] && echo "アンインストール中：${i}"
[ -f $START_DIR/module/${i}/uninstall.sh ]&&source $START_DIR/module/${i}/uninstall.sh
rm -rf $START_DIR/module/${i}
if [ "$?" == "0" ];then
[[ "${TEXT_LANG}" = "zh" ]] && echo "已删除${i}"
[[ "${TEXT_LANG}" = "en" ]] && echo "Uninstalled ${i}"
[[ "${TEXT_LANG}" = "ja" ]] && echo "${i} をアンインストールしました"
else
[[ "${TEXT_LANG}" = "zh" ]] && echo "删除${i}失败"
[[ "${TEXT_LANG}" = "en" ]] && echo "Failed to uninstall ${i}"
[[ "${TEXT_LANG}" = "ja" ]] && echo "${i} のアンインストールに失敗しました"
fi
done
}
module (){
[[ "${TEXT_LANG}" = "zh" ]] && cat <<Mod
<?xml version="1.0" encoding="utf-8"?>
<group reload="true">
    <action reload="true" auto-off="true">
        <title>删除插件</title>
        <set>script/tool.sh delmod</set>
        <param name="mod" title="请选择插件支持多选：" options-sh="script/tool.sh cm" desc="识别已安装的插件" required="true" multiple="true"/>
    </action>
</group>
<group title="已安装的插件">
Mod
[[ "${TEXT_LANG}" = "en" ]] && cat <<Mod
<?xml version="1.0" encoding="utf-8"?>
<group reload="true">
    <action reload="true" auto-off="true">
        <title>Uninstall Plugins</title>
        <set>script/tool.sh delmod</set>
        <param name="mod" title="Select plugins(s):" options-sh="script/tool.sh cm" desc="Select from installed plugins" required="true" multiple="true"/>
    </action>
</group>
<group title="Installed plugins">
Mod
[[ "${TEXT_LANG}" = "ja" ]] && cat <<Mod
<?xml version="1.0" encoding="utf-8"?>
<group reload="true">
    <action reload="true" auto-off="true">
        <title>プラグインをアンインストール</title>
        <set>script/tool.sh delmod</set>
        <param name="mod" title="プラグインを選択" options-sh="script/tool.sh cm" desc="インストール済のプラグインから選択" required="true" multiple="true"/>
    </action>
</group>
<group title="インストール済のプラグイン">
Mod
for var in $(find $START_DIR/module/ -name index.xml);do
cat $var
done

cat <<Mod
</group>
Mod
}
zdyfj (){
cd $zml/$xm/
for i in ${zdy}
do
ubdi ${i}
done
}
if (type $1 >/dev/null 2>&1);then
$1
else
findfile $1
fi
