import QtQuick
import QtTest
import QtQuick.Controls

Item {
    id: root
    width: 400; height: 400

    TestCase {
        name: "MediaPlayerUITests"

        function test_component_creation() {
            var windowComponent = Qt.createComponent("../main.qml");
            var window = windowComponent.createObject(root);
            verify(window !== null, "Главное окно должно быть создано успешно");
            window.destroy();
        }

        function test_time_formatting() {
            var windowComponent = Qt.createComponent("../main.qml");
            var window = windowComponent.createObject(root);

            compare(window.formatTime(0), "0:00");
            compare(window.formatTime(65000), "1:05");
            compare(window.formatTime(600000), "10:00");

            window.destroy();
        }
    }
}