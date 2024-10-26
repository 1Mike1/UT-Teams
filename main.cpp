/*
 * Copyright (C) 2024  Mithlesh Kumar
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * teams-for-ut is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


#include <QGuiApplication>
#include <QCoreApplication>
#include <QUrl>
#include <QString>
#include <QQuickStyle>
#include <QQmlEngine>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QVector>
#include <QtWebEngine/qtwebengineglobal.h>

int main(int argc, char** argv) {
    QGuiApplication::setOrganizationName("teams-for-ut.mithlesh.kumar");
    QGuiApplication::setApplicationName("teams-for-ut.mithlesh.kumar");
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication::setAttribute(Qt::AA_ShareOpenGLContexts);
    
    const auto chromiumFlags = qgetenv("QTWEBENGINE_CHROMIUM_FLAGS");
    qputenv("QTWEBENGINE_CHROMIUM_FLAGS", chromiumFlags + " --simulate-touch-screen-with-mouse --touch-events=enabled --enable-features=OverlayScrollbar,kEnableQuic,OverlayScrollbarFlashAfterAnyScrollUpdate,OverlayScrollbarFlashWhenMouseEnter --enable-blink-features=NeverSlowMode,BackFowardCache,Canvas2dScrollPathIntoView,BackForwardCacheExperimentHTTPHeader,Accelerated2dCanvas,AcceleratedSmallCanvases --enable-smooth-scrolling  --disable-low-res-tiling --enable-gpu --enable-gpu-rasterization --enable-zero-copy  --adaboost --enable-gpu-msemory-buffer-video-frames  --font-render-hinting=none --disable-font-subpixel-positioning --disable-new-content-rendering-timeout --enable-defer-all-script-without-optimization-hints  --enable-gpu-vsync  --enable-oop-rasterization --enable-accelerated-video-decode ");
        
    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle("Suru");
    QQmlApplicationEngine engine(QUrl("qrc:/Main.qml"));

    return app.exec();
}
