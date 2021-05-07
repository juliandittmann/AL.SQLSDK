page 50105 "jdi SQL Script Editor"
{
    PageType = Card;
    UsageCategory = None;
    SourceTable = "jdi SQL Script";

    Caption = 'SQL Script Editor';

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
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

                trigger Save(ModyfiedCode: Text)
                begin
                    SaveAndClosePage(ModyfiedCode);
                end;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(actionSave)
            {
                ApplicationArea = all;

                Visible = not HideSaveButton;

                Caption = 'Save';
                Image = Save;

                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CurrPage."SQL Editor".GetModifedCode();
                end;
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

    procedure SetHideSaveButton(pHideSaveButton: Boolean)
    begin
        HideSaveButton := pHideSaveButton;
    end;

    local procedure SaveAndClosePage(ModifedCode: Text)
    begin
        Rec.SaveScript(ModifedCode);
        CurrPage.Close();
    end;

    var
        HideSaveButton: Boolean;
}