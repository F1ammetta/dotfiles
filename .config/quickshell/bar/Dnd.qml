pragma Singleton
import QtQuick

QtObject {
    id: dndSingleton

    property bool enabled: false

    // Maintain a list of recent notifications as a history log
    property var notificationHistory: []

    function addNotification(notif) {
        let newHistory = [...notificationHistory];
        
        // Append notification to history
        newHistory.unshift({
            id: notif.id !== undefined ? notif.id : Date.now(),
            summary: notif.summary !== undefined ? notif.summary : "",
            body: notif.body !== undefined ? notif.body : "",
            image: notif.image !== undefined ? notif.image : "",
            time: new Date()
        });

        // Limit history to 50 items
        if (newHistory.length > 50) {
            newHistory.pop();
        }
        
        notificationHistory = newHistory;
    }

    function clearHistory() {
        notificationHistory = [];
    }

    function removeNotification(id) {
        notificationHistory = notificationHistory.filter(n => n.id !== id);
    }
}
