page 50101 "jdi SQL Connection Card"
{
    PageType = Card;
    UsageCategory = None;
    SourceTable = "jdi SQL Connection";

    Caption = 'SQL Connection';

    layout
    {
        area(Content)
        {
            group(General)
            {
                group(General1)
                {
                    ShowCaption = false;
                    field("No."; Rec."No.")
                    {
                        ApplicationArea = All;
                        Caption = 'No.';
                    }
                }
                group(General2)
                {
                    ShowCaption = false;

                    field(Description; Rec.Description)
                    {
                        ApplicationArea = all;
                        Caption = 'Description';
                    }
                }
            }

            group(Connection)
            {
                Caption = 'Connection';

                group(SQLServer)
                {
                    Caption = 'SQL Server';

                    field(Authentication; Rec.Authentication)
                    {
                        ApplicationArea = All;
                        Caption = 'Authentication';

                        trigger OnValidate()
                        begin
                            AuthenticationOnAfterValidate();
                        end;
                    }
                    field("Server Name"; Rec."Server Name")
                    {
                        ApplicationArea = All;
                        Caption = 'Server Name';
                    }

                    field("Database Name"; Rec."Database Name")
                    {
                        ApplicationArea = All;
                        Caption = 'Database Name';
                    }
                }

                group(Credentials)
                {
                    Caption = 'Credentials';

                    field("Database User"; Rec."Database User")
                    {
                        ApplicationArea = All;
                        Caption = 'Database User';

                        Editable = DatabaseUserEditable;
                    }
                    field(Password; Password)
                    {
                        ApplicationArea = All;
                        Caption = 'Password';
                        ToolTip = 'Specifies the password of the Database.';

                        Editable = PasswordEditable;
                        ExtendedDatatype = Masked;

                        trigger OnValidate()
                        begin
                            Rec.SetPassword(Password);
                            Commit();
                        end;
                    }
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

                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Process;


                trigger OnAction()
                var
                    ConnectionErr: Label 'Connection to SQL Database failed.';
                    ConnectionSuccessMsg: Label 'Connection to SQL Database established.';
                begin
                    if Rec.TestConnection() then
                        Message(ConnectionSuccessMsg)
                    else
                        Error(ConnectionErr);
                end;
            }

            action("Import Connection String")
            {
                ApplicationArea = all;
                Caption = 'Import Connection String';

                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                Image = Database;

                trigger OnAction()
                var
                    SQLConnectionStringInput: Page "jdi SQL Connection String";
                begin
                    SQLConnectionStringInput.LookupMode := true;
                    if SQLConnectionStringInput.RunModal() = Action::LookupOK then
                        Rec.ImportConnectionString(SQLConnectionStringInput.GetConnectionString());

                    AuthenticationOnAfterValidate();
                end;
            }
        }
    }

    trigger OnInit()
    begin
        DatabaseUserEditable := true;
        PasswordEditable := true;
    end;


    trigger OnOpenPage()
    begin
        Password := '***';
        DatabaseUserEditable := Rec.Authentication = Rec.Authentication::"SQL Server Authentication";
        PasswordEditable := Rec.Authentication = Rec.Authentication::"SQL Server Authentication";
    end;



    local procedure AuthenticationOnAfterValidate()
    begin
        DatabaseUserEditable := Rec.Authentication = Rec.Authentication::"SQL Server Authentication";
        PasswordEditable := Rec.Authentication = Rec.Authentication::"SQL Server Authentication";
    end;


    var
        Password: Text[250];
        DatabaseUserEditable: Boolean;
        PasswordEditable: Boolean;
}