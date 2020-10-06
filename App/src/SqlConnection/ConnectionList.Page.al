page 50100 "jdi Sql Connection List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "jdi Sql Connection";
    CardPageId = "jdi Sql Connection Card";
    Editable = false;

    Caption = 'Sql Connections';

    layout
    {
        area(Content)
        {
            repeater(SqlConnectionRepeater)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    Editable = false;
                }

                field(Authentication; Rec."Authentication")
                {
                    ApplicationArea = All;
                    Caption = 'Authentication';
                    Editable = false;
                }

                field("Server Name"; Rec."Server Name")
                {
                    ApplicationArea = All;
                    Caption = 'Server Name';
                    Editable = false;
                }

                field("Database Name"; Rec."Database Name")
                {
                    ApplicationArea = All;
                    Caption = 'Database Name';
                    Editable = false;
                }
                field("Database User"; Rec."Database User")
                {
                    ApplicationArea = All;
                    Caption = 'Database User';

                    Editable = false;
                }
                field(Password; Password)
                {
                    ApplicationArea = All;
                    Caption = 'Password';
                    ToolTip = 'Specifies the password of the Database.';
                    Editable = false;
                    ExtendedDatatype = Masked;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(TestConnection)
            {
                ApplicationArea = All;
                Caption = 'Test Connection';
                Image = TestDatabase;

                trigger OnAction()
                var
                    ConnectionErr: Label 'Connection to Sql Database failed.';
                    ConnectionSuccessMsg: Label 'Connection to Sql Database established.';
                begin
                    if Rec.TestConnection() then
                        Message(ConnectionSuccessMsg)
                    else
                        Error(ConnectionErr);
                end;
            }
        }
    }


    trigger OnAfterGetCurrRecord()
    begin
        Password := '***';
    end;

    var
        Password: Text[250];
}