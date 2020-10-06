page 50105 "jdi Sql Script Editor"
{
    PageType = Card;
    UsageCategory = None;
    SourceTable = "jdi Sql Script";

    Caption = 'Sql Script Editor';

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

                    trigger Save(ModyfiedCode: Text)
                    begin
                        SaveAndClosePage(ModyfiedCode);
                    end;
                }
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
                    CurrPage."Sql Editor".GetModifedCode();
                end;
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