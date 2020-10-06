table 50100 "jdi Sql Connection"
{
    DataClassification = CustomerContent;

    Caption = 'Sql Connection';

    LookupPageId = "jdi Sql Connection List";
    DrillDownPageId = "jdi Sql Connection List";

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
        }

        field(2; Authentication; Enum "jdi Sql Connection Type")
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Authentication <> Authentication::"Sql Server Authentication" then begin
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
                TestField(Authentication, Authentication::"Sql Server Authentication");
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

            "Authentication"::"Sql Server Authentication":
                exit(StrSubstNo(ConnectionStringLbl, "Server Name", "Database Name", "Database User", GetPassword()));

        end;
    end;

    procedure ImportConnectionString(ConnectionString: Text)
    var
        SqlConnectionStringBuilder: DotNet SqlConnectionStringBuilder;
        NewPassword: Text;
    begin
        SqlConnectionStringBuilder := SqlConnectionStringBuilder.SqlConnectionStringBuilder(ConnectionString);

        //Trusted connection (SSPI)
        if SqlConnectionStringBuilder.IntegratedSecurity then begin
            Validate(Authentication, Authentication::"Windows Authentication");
            SqlConnectionStringBuilder.TryGetValue('Data Source', "Server Name");
            SqlConnectionStringBuilder.TryGetValue('Initial Catalog', "Database Name");
            exit;
        end;

        //Standard Security
        Validate(Authentication, Authentication::"Sql Server Authentication");
        SqlConnectionStringBuilder.TryGetValue('Server', "Server Name");
        SqlConnectionStringBuilder.TryGetValue('Database', "Database Name");
        SqlConnectionStringBuilder.TryGetValue('User ID', "Database User");
        if SqlConnectionStringBuilder.TryGetValue('Password', NewPassword) then
            SetPassword(NewPassword);
    end;

    procedure TestConnection(): Boolean
    var
        SqlMgt: Codeunit "jdi Sql Management";
    begin
        exit(SqlMgt.TestConnection(Rec));
    end;


    //ExecuteNonQuery
    procedure ExecuteNonQuery(SqlStatement: Text)
    var
        SqlMgt: Codeunit "jdi Sql Management";
    begin
        SqlMgt.ExecuteNonQuery(Rec, SqlStatement);
    end;

    procedure ExecuteNonQuery(SqlStatement: Text; var SqlParamenter: Record "jdi Sql Parameter" temporary)
    var
        SqlMgt: Codeunit "jdi Sql Management";
    begin
        SqlMgt.ExecuteNonQuery(Rec, SqlStatement, SqlParamenter);
    end;

    [TryFunction]
    procedure TryExecuteNonQuery(SqlStatement: Text)
    var
        SqlMgt: Codeunit "jdi Sql Management";
    begin
        SqlMgt.ExecuteNonQuery(Rec, SqlStatement);
    end;



    //Execute Scalar
    procedure ExecuteScalar(SqlStatement: Text; var ResponseText: Text)
    var
        SqlMgt: Codeunit "jdi Sql Management";
    begin
        SqlMgt.ExecuteScalar(Rec, SqlStatement, ResponseText);
    end;

    procedure ExecuteScalar(SqlStatement: Text; var ResponseDecimal: Decimal)
    var
        SqlMgt: Codeunit "jdi Sql Management";
    begin
        SqlMgt.ExecuteScalar(Rec, SqlStatement, ResponseDecimal);
    end;

    procedure ExecuteScalar(SqlStatement: Text; var ResponseVariant: Variant)
    var
        SqlMgt: Codeunit "jdi Sql Management";
    begin
        SqlMgt.ExecuteScalar(Rec, SqlStatement, ResponseVariant);
    end;


    procedure ExecuteScalar(SqlStatement: Text; var SqlParamenter: Record "jdi Sql Parameter" temporary; var ResponseText: Text)
    var
        SqlMgt: Codeunit "jdi Sql Management";
    begin
        SqlMgt.ExecuteScalar(Rec, SqlStatement, SqlParamenter, ResponseText);
    end;

    procedure ExecuteScalar(SqlStatement: Text; var SqlParamenter: Record "jdi Sql Parameter" temporary; var ResponseDecimal: Decimal)
    var
        SqlMgt: Codeunit "jdi Sql Management";
    begin
        SqlMgt.ExecuteScalar(Rec, SqlStatement, SqlParamenter, ResponseDecimal);
    end;

    procedure ExecuteScalar(SqlStatement: Text; var SqlParamenter: Record "jdi Sql Parameter" temporary; var ResponseVariant: Variant)
    var
        SqlMgt: Codeunit "jdi Sql Management";
    begin
        SqlMgt.ExecuteScalar(Rec, SqlStatement, SqlParamenter, ResponseVariant);
    end;




    //Try-Functions

    [TryFunction]
    procedure TryExecuteScalar(SqlStatement: Text; var ResponseText: Text)
    begin
        ExecuteScalar(SqlStatement, ResponseText);
    end;

    [TryFunction]
    procedure TryExecuteScalar(SqlStatement: Text; var ResponseDecimal: Decimal)
    begin
        ExecuteScalar(SqlStatement, ResponseDecimal);
    end;

    [TryFunction]
    procedure TryExecuteScalar(SqlStatement: Text; var ResponseVariant: Variant)
    begin
        ExecuteScalar(SqlStatement, ResponseVariant);
    end;


    [TryFunction]
    procedure TryExecuteScalar(SqlStatement: Text; var SqlParamenter: Record "jdi Sql Parameter" temporary; var ResponseText: Text)
    begin
        ExecuteScalar(SqlStatement, SqlParamenter, ResponseText);
    end;

    [TryFunction]
    procedure TryExecuteScalar(SqlStatement: Text; var SqlParamenter: Record "jdi Sql Parameter" temporary; var ResponseDecimal: Decimal)
    begin
        ExecuteScalar(SqlStatement, SqlParamenter, ResponseDecimal);
    end;

    [TryFunction]
    procedure TryExecuteScalar(SqlStatement: Text; var SqlParamenter: Record "jdi Sql Parameter" temporary; var ResponseVariant: Variant)
    begin
        ExecuteScalar(SqlStatement, SqlParamenter, ResponseVariant);
    end;



    procedure SetDefaultExternalTableConnection()
    begin
        if HasTableConnection(TableConnectionType::ExternalSQL, Rec."Database Name") then
            UnregisterTableConnection(TableConnectionType::ExternalSQL, Rec."Database Name");

        RegisterTableConnection(TableConnectionType::ExternalSQL, Rec."Database Name", Rec.GetConnectionString());
        SetDefaultTableConnection(TableConnectionType::ExternalSQL, Rec."Database Name");
    end;
}