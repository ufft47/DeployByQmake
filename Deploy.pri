# Author: Qt君
# QQ交流群: 732271126
# AUTHOR_INFO: 扫码关注微信公众号: [Qt君] 第一时间获取最新推送.
#██████████████    ██      ██████████████    ██████████████
#██          ██  ████  ████    ██  ██        ██          ██
#██  ██████  ██    ██████              ██    ██  ██████  ██
#██  ██████  ██  ████  ██    ████████    ██  ██  ██████  ██
#██  ██████  ██      ██  ██      ██    ████  ██  ██████  ██
#██          ██  ██  ██      ████    ██  ██  ██          ██
#██████████████  ██  ██  ██  ██  ██  ██  ██  ██████████████
#                        ██  ██████  ██████
#██████████  ██████████  ██  ████████████  ██  ██  ██  ██
#      ██        ████        ██  ██    ██  ████████      ██
#  ██  ██  ████  ████  ████████████  ██  ██  ██████
#    ██████        ██████        ██  ██  ██████        ██
#      ██████████  ██  ██  ██  ██  ██  ██  ██      ████
#                ██  ██  ██████  ████  ████████████  ██  ██
#████  ██████████    ██        ████  ██  ██  ██  ██  ██
#████    ████      ████  ██  ██████  ██████████        ██
#  ██  ████  ██    ████  ██████    ██  ██      ██    ██
#████████      ██  ██      ████  ██    ████  ██████████  ██
#██    ████  ████  ██  ████    ████      ████  ████████
#██  ████  ██  ██      ██      ████    ██              ██
#██  ██████  ████    ████  ██████████    ██████████  ██████
#                ████    ████  ████  ██  ██      ██████████
#██████████████  ████        ██████    ████  ██  ██████
#██          ██    ████  ██  ██████  ██████      ████    ██
#██  ██████  ██  ████    ████  ██  ██    ██████████████████
#██  ██████  ██  ████        ██████████  ██        ██  ████
#██  ██████  ██  ██  ██████    ██  ████████  ████████████
#██          ██  ██    ██    ████    ██  ████  ██████  ██
#██████████████  ██████████      ██            ████  ██

QT_BIN_DIR = $$replace(QMAKE_QMAKE, ^(\S*/)\S+$, \1) # 获取从QMake执行文件的所在目录得出Qt的bin路径
QT_DIR = $${QT_BIN_DIR}../ # 获取Qt开发环境路径

QT_AVAILABLE_LIBRARY_LIST = \
    bluetooth concurrent core declarative designer designercomponents enginio \
    gamepad gui qthelp multimedia multimediawidgets multimediaquick network nfc \
    opengl positioning printsupport qml qmltooling quick quickparticles quickwidgets \
    script scripttools sensors serialport sql svg test webkit webkitwidgets \
    websockets widgets winextras xml xmlpatterns webenginecore webengine \
    webenginewidgets 3dcore 3drenderer 3dquick 3dquickrenderer 3dinput 3danimation \
    3dextras geoservices webchannel texttospeech serialbus webview

for (LIBRARY_MODULE, QT_AVAILABLE_LIBRARY_LIST) {
    if (contains(QT, $$LIBRARY_MODULE)) {
        DEPLOY_OPTIONS += --$$LIBRARY_MODULE
    }
    else {
        DEPLOY_OPTIONS += --no-$$LIBRARY_MODULE
    }
}

if (contains(QT, quick)) {
    DEPLOY_OPTIONS += --qmldir $${QT_DIR}qml/
    DEPLOY_OPTIONS -= --no-network
    DEPLOY_OPTIONS += --network
}

if (!isEmpty(DESTDIR)) {
    TARGET_OUT_DIR = $$OUT_PWD/$$DESTDIR/
}
else {
    # 判断时debug版本还是release版本
    CONFIG(debug, debug|release) {
        TARGET_OUT_DIR = $${OUT_PWD}/debug/
        DEPLOY_OPTIONS += --debug
    }
    else {
        TARGET_OUT_DIR = $${OUT_PWD}/release/
        DEPLOY_OPTIONS += --release
    }
}

message(TARGET_OUT_DIR: $$TARGET_OUT_DIR) # 生成文件的输出目录

win32 {
    WIN_DEPLOY_BIN = $${QT_BIN_DIR}windeployqt.exe # 拼接Qt部署程序的文件(windows平台下为windeployqt.exe)
    QMAKE_POST_LINK += $$WIN_DEPLOY_BIN $$DEPLOY_OPTIONS $$TARGET_OUT_DIR$${TARGET}.exe  # 编译完成后执行打包命令
    QMAKE_POST_LINK += && start $$TARGET_OUT_DIR # 打包完成后自动打开目标路径
}

message(QMAKE_POST_LINK: $$QMAKE_POST_LINK) # 打印命令
