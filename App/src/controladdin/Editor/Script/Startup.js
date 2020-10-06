var iframe = window.frameElement;

iframe.parentElement.style.display = 'flex';
iframe.parentElement.style.flexDirection = 'column';
iframe.parentElement.style.flexGrow = '1';

iframe.style.removeProperty('height');
iframe.style.removeProperty('min-height');
iframe.style.removeProperty('max-height');

iframe.style.flexGrow = '1';
iframe.style.flexShrink = '1';
iframe.style.flexBasis = 'auto';
iframe.style.paddingBottom = '42px';

iframe.style.height = '700px';


var controlAddIn = document.getElementById('controlAddIn');
controlAddIn.style.height = '100%';
controlAddIn.style.width = 'inherit';

$(document).ready(function () {
    $navControlContainer = $("#controlAddIn");

    ace.config.set("basePath", "https://cdnjs.com/libraries/ace/1.4.4/");

    ace.config.setModuleUrl("ace/mode/sql", "https://cdnjs.cloudflare.com/ajax/libs/ace/1.4.4/mode-sql.js");
    ace.config.setModuleUrl("ace/theme/monokai", "https://cdnjs.cloudflare.com/ajax/libs/ace/1.4.4/theme-monokai.js");
    ace.config.setModuleUrl("ace/theme/sqlserver", "https://cdnjs.cloudflare.com/ajax/libs/ace/1.4.4/theme-sqlserver.js");

    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ControlAddinLoaded', null);
});


