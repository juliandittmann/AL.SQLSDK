page 50111 "jdi Sql Script Viewer"
{
    PageType = Card;
    UsageCategory = None;
    SourceTable = "jdi Sql Script Archive";

    Caption = 'Sql Script Viewer';

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            group(Control)
            {
                ShowCaption = false;
                usercontrol("Sql Editor"; "jdi Sql Editor")
                {
                    ApplicationArea = all;

                    trigger ControlAddinLoaded()
                    begin
                        CurrPage."Sql Editor".CreateControl();
                    end;

                    trigger GetCode()
                    begin
                        SetCode();
                    end;
                }
            }
        }
    }

    local procedure SetCode(): Text
    var
        SqlScript: Text;
    begin
        if Rec.GetScript(SqlScript) then
            CurrPage."Sql Editor".SetCode(SqlScript);
    end;
}