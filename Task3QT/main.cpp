#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "playlistmodel.h"

#if defined(Q_OS_ANDROID)
#include <QtCore/private/qandroidextras_p.h>
#include <QPermissions>
#endif

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

#if defined(Q_OS_ANDROID)
    // Для новых версий Android (13+) запрашиваем READ_MEDIA_AUDIO, для старых READ_EXTERNAL_STORAGE
    QStringList permissions = {
        "android.permission.READ_EXTERNAL_STORAGE",
        "android.permission.READ_MEDIA_AUDIO"
    };

    for (const QString &permission : permissions) {
        auto result = QtAndroidPrivate::checkPermission(permission).result();
        if (result == QtAndroidPrivate::Denied) {
            QtAndroidPrivate::requestPermission(permission);
        }
    }
#endif

    QQmlApplicationEngine engine;
    qmlRegisterType<PlaylistModel>("com.media.player", 1, 0, "PlaylistModel");

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Task3QT", "Main");

    return QCoreApplication::exec();
}
