page 50106 "jdi SQL Parameter List"
{
    PageType = List;
    UsageCategory = None;
    SourceTable = "jdi SQL Parameter";

    layout
    {
        area(Content)
        {
            repeater(List)
            {
                field(Name; Rec."Name")
                {
                    ApplicationArea = All;
                    Caption = 'Parameter';
                    ToolTip = 'Parameter Name';
                }
                field(Value; Rec."Value")
                {
                    ApplicationArea = all;
                    Caption = 'Value';
                }
            }
        }
    }
}