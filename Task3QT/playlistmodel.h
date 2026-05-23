#ifndef PLAYLISTMODEL_H
#define PLAYLISTMODEL_H

#include <QAbstractListModel>
#include <QDir>
#include <QUrl>
#include <QFileInfoList>

class PlaylistModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum TrackRoles { TitleRole = Qt::UserRole + 1, PathRole };
    explicit PlaylistModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void loadFolder(const QString &folderPath);
    Q_INVOKABLE QUrl getTrackUrl(int index) const;
    Q_INVOKABLE QString getTrackTitle(int index) const;
    Q_INVOKABLE void loadDeviceLibrary();

private:
    QList<QFileInfo> m_tracks;
};

#endif