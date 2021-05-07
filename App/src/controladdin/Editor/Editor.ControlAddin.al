controladdin "jdi SQL Editor"
{
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;

    Scripts =
        'https://code.jquery.com/jquery-3.3.1.min.js',
        'https://cdnjs.cloudflare.com/ajax/libs/ace/1.4.4/ace.js',
        'src/controladdin/Editor/Script/Utility.js',
        'src/controladdin/Editor/Script/Interface.js',
        'src/controladdin/Editor/Script/SqlEditor.js';

    StartupScript =
        'src/controladdin/Editor/Script/Startup.js';


    event ControlAddinLoaded();
    procedure CreateControl();

    event GetCode();
    procedure SetCode(SqlCode: Text);




    event Save(ModyfiedCode: Text);
    procedure GetModifedCode();

}