page 50108 "jdi Sql Script ExecP EntryList"
{
    PageType = List;
    SourceTable = "jdi Sql Script ExecParam Entry";
    Caption = 'Sql Script Execution Parameter Entry List';
    UsageCategory = None;

    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Execution Entry No."; Rec."Execution Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Parameter Name"; Rec."Parameter Name")
                {
                    ApplicationArea = All;
                }
                field(Value; Rec."Value")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
