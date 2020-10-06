page 50101 "jdi Sql Connection Card"
{
    PageType = Card;
    UsageCategory = None;
    SourceTable = "jdi Sql Connection";

    Caption = 'Sql Connection';

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

                group(SqlServer)
                {
                    Caption = 'Sql Server';

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
                    ConnectionErr: Label 'Connection to Sql Database failed.';
                    ConnectionSuccessMsg: Label 'Connection to Sql Database established.';
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
                    SqlConnectionStringInput: Page "jdi Sql Connection String";
                begin
                    SqlConnectionStringInput.LookupMode := true;
                    if SqlConnectionStringInput.RunModal() = Action::LookupOK then
                        Rec.ImportConnectionString(SqlConnectionStringInput.GetConnectionString());

                    AuthenticationOnAfterValidate();
                end;
            }

            group(Test)
            {
                Image = TestFile;

                action(Test4)
                {
                    Caption = 'Show View';
                    ApplicationArea = All;
                    Image = TestReport;

                    trigger OnAction()
                    var
                        SqlView: Page "jdi Sql sampleviewPage";
                    begin
                        SqlView.Run();
                    end;
                }
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
        DatabaseUserEditable := Rec.Authentication = Rec.Authentication::"Sql Server Authentication";
        PasswordEditable := Rec.Authentication = Rec.Authentication::"Sql Server Authentication";
    end;



    local procedure AuthenticationOnAfterValidate()
    begin
        DatabaseUserEditable := Rec.Authentication = Rec.Authentication::"Sql Server Authentication";
        PasswordEditable := Rec.Authentication = Rec.Authentication::"Sql Server Authentication";
    end;


    var
        Password: Text[250];
        DatabaseUserEditable: Boolean;
        PasswordEditable: Boolean;
}