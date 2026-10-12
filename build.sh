#!/bin/bash
# Builds Talorys.apk without Gradle: aapt2 -> javac -> d8 -> zipalign -> apksigner
set -e
SDK=$HOME/android-sdk; BT=$SDK/build-tools/35.0.0; JAR=$SDK/platforms/android-35/android.jar
SRC=$(cd $(dirname $0); pwd); OUT=$SRC/build; rm -rf $OUT; mkdir -p $OUT/res $OUT/classes $OUT/gen $OUT/dex
KS=${KS:-/home/user/tab/state/talorys-android-keystore}
PW=$(python3 -c "import json;print(json.load(open('$KS/keystore.json'))['store_password'])")
$BT/aapt2 compile --dir $SRC/res -o $OUT/res.zip
$BT/aapt2 link -I $JAR --manifest $SRC/AndroidManifest.xml -o $OUT/unsigned.apk --java $OUT/gen $OUT/res.zip --min-sdk-version 24 --target-sdk-version 35 --version-code ${VC:-1} --version-name ${VN:-1.0}
javac -source 8 -target 8 -nowarn -Xlint:-options -cp $JAR -d $OUT/classes $(find $SRC/src $OUT/gen -name '*.java')
$BT/d8 --release --min-api 24 --lib $JAR --output $OUT/dex $(find $OUT/classes -name '*.class')
(cd $OUT/dex && zip -q -j ../unsigned.apk classes.dex)
$BT/zipalign -f -p 4 $OUT/unsigned.apk $OUT/aligned.apk
$BT/apksigner sign --ks $KS/talorys.jks --ks-key-alias talorys --ks-pass pass:$PW --key-pass pass:$PW --out $OUT/Talorys.apk $OUT/aligned.apk
cp $OUT/Talorys.apk /home/user/tab/files/Talorys.apk
echo BUILT
