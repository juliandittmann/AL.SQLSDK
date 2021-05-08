table 50100 "jdi SQL Connection"
{
    DataClassification = CustomerContent;

    Caption = 'SQL Connection';

    LookupPageId = "jdi SQL Connection List";
    DrillDownPageId = "jdi SQL Connection List";

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
        }

        field(2; Authentication; Enum "jdi SQL Connection Type")
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Authentication <> Authentication::"SQL Server Authentication" then begin
                    "Database User" := '';
                    SetPassword('')
                end;
            end;
        }

        field(3; "Server Name"; Text[250])
        {
            DataClassification = CustomerContent;
        }

        field(4; "Database Name"; Text[250])
        {
            DataClassification = CustomerContent;
        }

        field(5; "Database User"; Text[250])
        {
            DataClassification = EndUserIdentifiableInformation;

            trigger OnValidate()
            begin
                "Database User" := DelChr("Database User", '<>', ' ');
                if "Database User" = '' then
                    exit;
                TestField(Authentication, Authentication::"SQL Server Authentication");
            end;
        }

        field(6; "Password Key"; Guid)
        {
            DataClassification = EndUserPseudonymousIdentifiers;
        }

        field(7; Description; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PrimaryKey; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    begin
        RemovePassword();
    end;


    [NonDebuggable]
    procedure SetPassword(NewPassword: Text)
    begin
        if IsNullGuid("Password Key") then
            "Password Key" := CreateGuid();

        if not EncryptionEnabled() then
            IsolatedStorage.Set(CopyStr("Password Key", 1, 200), NewPassword, DataScope::Module)
        else
            IsolatedStorage.SetEncrypted(CopyStr("Password Key", 1, 200), NewPassword, DataScope::Module);
    end;

    [NonDebuggable]
    procedure GetPassword(): Text
    var
        Password: Text;
    begin
        if not IsNullGuid("Password Key") and IsolatedStorage.Get("Password Key", DataScope::Module, Password) then
            exit(Password);
    end;

    [NonDebuggable]
    procedure HasPassword(): Boolean
    begin
        exit(GetPassword() <> '');
    end;

    [NonDebuggable]
    procedure RemovePassword()
    begin
        if not IsNullGuid("Password Key") then
            IsolatedStorage.Delete("Password Key", DataScope::Module);

        Clear("Password Key");
    end;

    procedure GetConnectionString(): Text[250]
    var
        ConnectionStringLbl: Label 'Server=%1;DataBase=%2;User Id=%3;Password=%4;', Locked = true;
        SSPIConnectionStringLbl: Label 'Data Source=%1;Inital Catalog=%2;Integrated Security=SSPI', Locked = true;
    begin
        case "Authentication" of

            "Authentication"::"Windows Authentication":
                exit(StrSubstNo(SSPIConnectionStringLbl, "Server Name", "Database Name"));

            "Authentication"::"SQL Server Authentication":
                exit(StrSubstNo(ConnectionStringLbl, "Server Name", "Database Name", "Database User", GetPassword()));

        end;
    end;

    procedure ImportConnectionString(ConnectionString: Text)
    var
        SQLConnectionStringBuilder: DotNet SQLConnectionStringBuilder;
        NewPassword: Text;
    begin
        SQLConnectionStringBuilder := SQLConnectionStringBuilder.SQLConnectionStringBuilder(ConnectionString);

        //Trusted connection (SSPI)
        if SQLConnectionStringBuilder.IntegratedSecurity then begin
            Validate(Authentication, Authentication::"Windows Authentication");
            SQLConnectionStringBuilder.TryGetValue('Data Source', "Server Name");
            SQLConnectionStringBuilder.TryGetValue('Initial Catalog', "Database Name");
            exit;
        end;

        //Standard Security
        Validate(Authentication, Authentication::"SQL Server Authentication");
        SQLConnectionStringBuilder.TryGetValue('Server', "Server Name");
        SQLConnectionStringBuilder.TryGetValue('Database', "Database Name");
        SQLConnectionStringBuilder.TryGetValue('User ID', "Database User");
        if SQLConnectionStringBuilder.TryGetValue('Password', NewPassword) then
            SetPassword(NewPassword);
    end;

    procedure TestConnection(): Boolean
    var
        SQLMgt: Codeunit "jdi SQL Management";
    begin
        exit(SQLMgt.TestConnection(Rec));
    end;


    //ExecuteNonQuery
    procedure ExecuteNonQuery(SQLStatement: Text)
    var
        SQLMgt: Codeunit "jdi SQL Management";
    begin
        SQLMgt.ExecuteNonQuery(Rec, SQLStatement);
    end;

    procedure ExecuteNonQuery(SQLStatement: Text; var SQLParameter: Record "jdi SQL Parameter" temporary)
    var
        SQLMgt: Codeunit "jdi SQL Management";
    begin
        SQLMgt.ExecuteNonQuery(Rec, SQLStatement, SQLParameter);
    end;

    [TryFunction]
    procedure TryExecuteNonQuery(SQLStatement: Text)
    var
        SQLMgt: Codeunit "jdi SQL Management";
    begin
        SQLMgt.ExecuteNonQuery(Rec, SQLStatement);
    end;



    //Execute Scalar
    procedure ExecuteScalar(SQLStatement: Text; var ResponseText: Text)
    var
        SQLMgt: Codeunit "jdi SQL Management";
    begin
        SQLMgt.ExecuteScalar(Rec, SQLStatement, ResponseText);
    end;

    procedure ExecuteScalar(SQLStatement: Text; var ResponseDecimal: Decimal)
    var
        SQLMgt: Codeunit "jdi SQL Management";
    begin
        SQLMgt.ExecuteScalar(Rec, SQLStatement, ResponseDecimal);
    end;

    procedure ExecuteScalar(SQLStatement: Text; var ResponseVariant: Variant)
    var
        SQLMgt: Codeunit "jdi SQL Management";
    begin
        SQLMgt.ExecuteScalar(Rec, SQLStatement, ResponseVariant);
    end;


    procedure ExecuteScalar(SQLStatement: Text; var SQLParameter: Record "jdi SQL Parameter" temporary; var ResponseText: Text)
    var
        SQLMgt: Codeunit "jdi SQL Management";
    begin
        SQLMgt.ExecuteScalar(Rec, SQLStatement, SQLParameter, ResponseText);
    end;

    procedure ExecuteScalar(SQLStatement: Text; var SQLParameter: Record "jdi SQL Parameter" temporary; var ResponseDecimal: Decimal)
    var
        SQLMgt: Codeunit "jdi SQL Management";
    begin
        SQLMgt.ExecuteScalar(Rec, SQLStatement, SQLParameter, ResponseDecimal);
    end;

    procedure ExecuteScalar(SQLStatement: Text; var SQLParameter: Record "jdi SQL Parameter" temporary; var ResponseVariant: Variant)
    var
        SQLMgt: Codeunit "jdi SQL Management";
    begin
        SQLMgt.ExecuteScalar(Rec, SQLStatement, SQLParameter, ResponseVariant);
    end;




    //Try-Functions

    [TryFunction]
    procedure TryExecuteScalar(SQLStatement: Text; var ResponseText: Text)
    begin
        ExecuteScalar(SQLStatement, ResponseText);
    end;

    [TryFunction]
    procedure TryExecuteScalar(SQLStatement: Text; var ResponseDecimal: Decimal)
    begin
        ExecuteScalar(SQLStatement, ResponseDecimal);
    end;

    [TryFunction]
    procedure TryExecuteScalar(SQLStatement: Text; var ResponseVariant: Variant)
    begin
        ExecuteScalar(SQLStatement, ResponseVariant);
    end;


    [TryFunction]
    procedure TryExecuteScalar(SQLStatement: Text; var SQLParameter: Record "jdi SQL Parameter" temporary; var ResponseText: Text)
    begin
        ExecuteScalar(SQLStatement, SQLParameter, ResponseText);
    end;

    [TryFunction]
    procedure TryExecuteScalar(SQLStatement: Text; var SQLParameter: Record "jdi SQL Parameter" temporary; var ResponseDecimal: Decimal)
    begin
        ExecuteScalar(SQLStatement, SQLParameter, ResponseDecimal);
    end;

    [TryFunction]
    procedure TryExecuteScalar(SQLStatement: Text; var SQLParameter: Record "jdi SQL Parameter" temporary; var ResponseVariant: Variant)
    begin
        ExecuteScalar(SQLStatement, SQLParameter, ResponseVariant);
    end;



    procedure SetDefaultExternalTableConnection()
    begin
        if HasTableConnection(TableConnectionType::ExternalSQL, Rec."Database Name") then
            UnregisterTableConnection(TableConnectionType::ExternalSQL, Rec."Database Name");

        RegisterTableConnection(TableConnectionType::ExternalSQL, Rec."Database Name", Rec.GetConnectionString());
        SetDefaultTableConnection(TableConnectionType::ExternalSQL, Rec."Database Name");
    end;
}