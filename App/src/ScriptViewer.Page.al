page 50111 "jdi SQL Script Viewer"
{
    PageType = Card;
    UsageCategory = None;
    SourceTable = "jdi SQL Script Archive";

    Caption = 'SQL Script Viewer';

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
                usercontrol("SQL Editor"; "jdi SQL Editor")
                {
                    ApplicationArea = all;

                    trigger ControlAddinLoaded()
                    begin
                        CurrPage."SQL Editor".CreateControl();
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
        SQLScript: Text;
    begin
        if Rec.GetScript(SQLScript) then
            CurrPage."SQL Editor".SetCode(SQLScript);
    end;
}