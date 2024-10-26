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

import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import Lomiri.Components 1.3
import Morph.Web 0.1
import QtWebEngine 1.11
import QtSystemInfo 5.5

import Example 1.0

ApplicationWindow {
    id: window
    visible: true
    color: "transparent"

    ScreenSaver {
        id: screenSaver
        screenSaverEnabled: !Qt.application.active || !webview.recentlyAudible
    }

    width: units.gu(45)
    height: units.gu(75)

    objectName: "mainView"
    property bool loaded: false
    property bool onError: false

    property QtObject defaultProfile: WebEngineProfile {
        id: webContext
        storageName: "myProfile"
        offTheRecord: false
        persistentCookiesPolicy: WebEngineProfile.ForcePersistentCookies
        property alias dataPath: webContext.persistentStoragePath

        dataPath: dataLocation

        userScripts: [
            WebEngineScript {
                id: cssinjection
                injectionPoint: WebEngineScript.DocumentReady
                worldId: WebEngineScript.UserWorld
                sourceCode: "\n(function() { ... })();"
            }
        ]

        //httpUserAgent: "Mozilla/5.0 (Linux; Android 12; Ubuntu Touch) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.72 Mobile Safari/537.36"
        httpUserAgent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36" 
    }

    WebView {
        id: webview
        anchors.fill: parent
        url: "https://teams.microsoft.com/v2/"
        profile: defaultProfile
        zoomFactor: 0.7
        settings.fullScreenSupportEnabled: true
        settings.dnsPrefetchEnabled: true
        enableSelectOverride: true
        property var currentWebview: webview
        property ContextMenuRequest contextMenuRequest: null
        settings.pluginsEnabled: true
        settings.javascriptCanAccessClipboard: true

        onFeaturePermissionRequested: grantFeaturePermission(url, WebEngineView.MediaAudioVideoCapture, true);

        onFullScreenRequested: function(request) {
            request.accept();
            navBar.visible = !navBar.visible
            if (request.toggleOn) {
                window.showFullScreen();
            } else {
                window.showNormal();
            }
        }

        onLoadingChanged: {
            if (loadRequest.status === WebEngineLoadRequest.LoadStartedStatus) {
                window.loaded = true
            } else if (loadRequest.status === WebEngineLoadRequest.LoadFailedStatus) {
                window.onError = true
            }
        }

        onNewViewRequested: function(request) {
            var url = request.requestedUrl.toString()
            if (url.startsWith('https://teams.microsoft.com/')) {
                var reg = new RegExp('[?&]q=([^&#]*)', 'i');
                var param = reg.exec(url);
                if (param) {
                    Qt.openUrlExternally(decodeURIComponent(param[1]))
                } else {
                    Qt.openUrlExternally(url)
                    request.action = WebEngineNavigationRequest.IgnoreRequest;
                }
            } else {
                Qt.openUrlExternally(url)
            }
        }

        onContextMenuRequested: function(request) {
            if (!Qt.inputMethod.visible) {
                request.accepted = true;
                contextMenuRequest = request
                contextMenu.x = request.x;
                contextMenu.y = request.y;
                contextMenu.open();
            }
        }
    }
}
