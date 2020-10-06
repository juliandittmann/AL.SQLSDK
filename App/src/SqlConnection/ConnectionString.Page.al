page 50102 "jdi Sql Connection String"
{
    PageType = StandardDialog;
    UsageCategory = None;

    Caption = 'Sql Connection String Input';

    layout
    {
        area(Content)
        {
            group(Input)
            {
                field(ConnectionString; ConnectionString)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    Caption = 'Connection String';
                    ShowCaption = false;
                }
            }
        }
    }

    procedure GetConnectionString(): Text
    begin
        exit(ConnectionString);
    end;

    var
        ConnectionString: Text;
}