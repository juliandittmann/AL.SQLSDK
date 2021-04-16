page 50107 "jdi Sql Script Exec Entry List"
{

    PageType = List;
    SourceTable = "jdi Sql Script Exec Entry";
    Caption = 'Sql Script Execution Entry List';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Sql Connection No."; Rec."Sql Connection No.")
                {
                    ApplicationArea = All;
                }

                field("Sql Script No."; Rec."Sql Script No.")
                {
                    ApplicationArea = all;
                }

                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = All;
                }

                field("Hash Code (SHA256)"; Rec."Hash Code (SHA256)")
                {
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        SqlScriptExecutionMgt.ShowScriptCode(Rec);
                    end;
                }

                field("Last Execution Date"; Rec."Last Execution Date")
                {
                    ApplicationArea = All;
                }
                field("Last Execution by"; Rec."Last Execution by")
                {
                    ApplicationArea = All;
                }

                field("Executed with Parameter"; Rec."Executed with Parameter")
                {
                    ApplicationArea = all;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        SqlScriptExecutionMgt.ShowParameterList(Rec);
                    end;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(ShowExecutionParameter)
            {
                ApplicationArea = all;
                Caption = 'Show Execution Parameter';
                ToolTip = 'Shows parameter which the script was executed with.';

                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                Scope = "Repeater";
                Image = LinkAccount;

                trigger OnAction()
                begin
                    SqlScriptExecutionMgt.ShowParameterList(Rec);
                end;
            }
        }
    }
    var
        SqlScriptExecutionMgt: Codeunit "jdi Sql Script Exec Mgt";
}