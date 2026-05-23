#include "playlistmodel.h"
#include <QDir>
#include <QStandardPaths>

PlaylistModel::PlaylistModel(QObject *parent) : QAbstractListModel(parent) {}

int PlaylistModel::rowCount(const QModelIndex &parent) const {
    if (parent.isValid()) return 0;
    return m_tracks.size();
}

QVariant PlaylistModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= m_tracks.size()) return QVariant();
    const QFileInfo &fileInfo = m_tracks.at(index.row());
    if (role == TitleRole) return fileInfo.completeBaseName();
    if (role == PathRole) return QUrl::fromLocalFile(fileInfo.absoluteFilePath()).toString();
    return QVariant();
}

QHash<int, QByteArray> PlaylistModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[TitleRole] = "title";
    roles[PathRole] = "path";
    return roles;
}

void PlaylistModel::loadFolder(const QString &folderPath) {
    beginResetModel();
    QUrl url(folderPath);
    QString path;
    if (url.scheme() == "content")
        path = url.toString();
    else
        path = url.toLocalFile();
    QDir dir(path);
    m_tracks = dir.entryInfoList(QStringList() << "*.mp3" << "*.wav" << "*.ogg", QDir::Files);
    endResetModel();
}

QUrl PlaylistModel::getTrackUrl(int index) const {
    if (index < 0 || index >= m_tracks.size()) return QUrl();
    QString filePath = m_tracks.at(index).absoluteFilePath();
    if (filePath.startsWith("content://"))
        return QUrl(filePath);
    return QUrl::fromLocalFile(filePath);
}

QString PlaylistModel::getTrackTitle(int index) const {
    if (index < 0 || index >= m_tracks.size()) return QString();
    return m_tracks.at(index).completeBaseName();
}

void PlaylistModel::loadDeviceLibrary() {
    QStringList locations = QStandardPaths::standardLocations(QStandardPaths::MusicLocation);
    if (!locations.isEmpty()) {
        QString musicPath = locations.first();
        loadFolder(QUrl::fromLocalFile(musicPath).toString());
    }
}