#include <QTest>
#include <QTemporaryDir>
#include <QFile>
#include "../playlistmodel.h"

class TestPlaylistModel : public QObject {
    Q_OBJECT
private slots:
    void testInitialState() {
        PlaylistModel model;
        QCOMPARE(model.rowCount(), 0);
        QVERIFY(model.getTrackUrl(0).isEmpty());
        QVERIFY(model.getTrackTitle(0).isEmpty());
    }

    void testOutOfBounds() {
        PlaylistModel model;
        QCOMPARE(model.getTrackUrl(-1), QUrl());
        QCOMPARE(model.getTrackTitle(999), QString());
    }

    void testLoadFolder() {
        PlaylistModel model;
        QTemporaryDir tempDir;
        QVERIFY(tempDir.isValid());

        QFile file1(tempDir.path() + "/song1.mp3");
        QVERIFY(file1.open(QIODevice::WriteOnly));
        file1.close();

        QFile file2(tempDir.path() + "/track2.wav");
        QVERIFY(file2.open(QIODevice::WriteOnly));
        file2.close();

        QFile file3(tempDir.path() + "/document.txt");
        QVERIFY(file3.open(QIODevice::WriteOnly));
        file3.close();

        QString folderUrl = QUrl::fromLocalFile(tempDir.path()).toString();

        model.loadFolder(folderUrl);

        QCOMPARE(model.rowCount(), 2);

        bool hasSong1 = model.getTrackTitle(0) == "song1" || model.getTrackTitle(1) == "song1";
        QVERIFY(hasSong1);
    }
};

QTEST_MAIN(TestPlaylistModel)
#include "test_playlistmodel.moc"