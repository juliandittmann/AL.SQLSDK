page 50103 "jdi Sql sampleviewPage"
{
    PageType = List;
    SourceTable = "jdi Sql sampleview";
    UsageCategory = None;

    Caption = 'SampleView from SQL Server';

    layout
    {
        area(Content)
        {

            repeater(repeater1)
            {
                field(No; Rec."No")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec."Name")
                {
                    ApplicationArea = All;
                }
                field(Address; Rec."Address")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnInit()
    var
        SqlConnection: Record "jdi Sql Connection";
    begin
        SqlConnection.Get('DEFAULT');
        SqlConnection.SetDefaultExternalTableConnection();
    end;
}