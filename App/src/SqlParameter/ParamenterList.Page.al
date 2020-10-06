page 50106 "jdi Sql Paramenter List"
{
    PageType = List;
    UsageCategory = None;
    SourceTable = "jdi Sql Parameter";

    layout
    {
        area(Content)
        {
            repeater(List)
            {
                field(Name; Rec."Name")
                {
                    ApplicationArea = All;
                    Caption = 'Paramenter';
                    ToolTip = 'Paramenter Name';
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