var $editor;

var SqlEditor;
(function (SqlEditor) {
    //Config for ElementIds
    var Config = {
        Editor: "editor"
    };

    SqlEditor.setCode = function (Code) {
        $editor.setValue(Code);
        $editor.resize();
    }

    //Show SqlEditor
    SqlEditor.show = function () {
        var Html = SqlEditor.getHtml();
        $navControlContainer.append(Html);

        $editor = ace.edit(Config.Editor, {
            minLines: 60,
            maxLines: 60,
            mode: "ace/mode/sql",
            theme: "ace/theme/sqlserver",
            bug: 1
        });

        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('GetCode', null);
    }

    //Remove SqlEditor
    SqlEditor.remove = function () {
        deleteID(Config.ImageContainer);
    }

    SqlEditor.save = function () {
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('Save',
            [
                $editor.getValue()
            ]
        );
    }

    //Get HTML-Content for "SqlEditor"
    SqlEditor.getHtml = function () {
        var Html = '';
        Html += '<div id="editor" class="container">';
        Html += '</div>';

        return Html;
    }
})(SqlEditor || (SqlEditor = {}));

