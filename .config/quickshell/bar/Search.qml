import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

// You can nest this Item inside a PanelWindow or your preferred container
Item {
    id: searchWidget
    width: 400
    height: 300

    // Set this to your actual SearXNG instance URL
    property string searxngUrl: "https://searx.soncore.net"

    ColumnLayout {
        anchors.fill: parent
        spacing: 5

        TextField {
            id: searchInput
            Layout.fillWidth: true
            placeholderText: "Search the web..."

            // Trigger the API call as you type
            onTextChanged: {
                if (text.length > 1) {
                    fetchSuggestions(text);
                } else {
                    suggestionsModel.clear();
                }
            }

            // Execute the search when pressing Enter
            onAccepted: {
                doSearch(text);
            }
        }

        ListView {
            id: suggestionsList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            model: ListModel {
                id: suggestionsModel
            }

            delegate: ItemDelegate {
                width: ListView.view.width
                text: model.suggestion

                // Clicking a suggestion triggers the search
                onClicked: doSearch(model.suggestion)
            }
        }
    }

    // Standard XHR to hit the /autocompleter endpoint
    function fetchSuggestions(query) {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", searxngUrl + "/autocompleter?q=" + encodeURIComponent(query));
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                var response = JSON.parse(xhr.responseText);
                suggestionsModel.clear();

                // SearXNG returns: ["original_query", ["suggestion1", "suggestion2"]]
                if (response.length > 1) {
                    var suggestions = response[1];
                    for (var i = 0; i < suggestions.length; i++) {
                        suggestionsModel.append({
                            "suggestion": suggestions[i]
                        });
                    }
                }
            }
        };
        xhr.send();
    }

    // Opens the search result in your default browser
    function doSearch(query) {
        var url = searxngUrl + "/search?q=" + encodeURIComponent(query);
        Qt.openUrlExternally(url);

        // Optional: Clear the input after searching
        searchInput.text = "";
        suggestionsModel.clear();
    }
}
