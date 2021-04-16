table 50102 "jdi Sql Script"
{
    DataClassification = CustomerContent;
    LookupPageId = "jdi Sql Script List";
    fields
    {

        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            NotBlank = true;
        }

        field(2; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

        field(3; "Script Type"; Enum "jdi Sql Script Type")
        {
            Caption = 'Sql Script Type';
            DataClassification = CustomerContent;
        }

        field(4; "File Name"; Text[250])
        {
            Caption = 'File name';
            DataClassification = CustomerContent;
        }

        field(5; "File Type"; Enum "jdi Sql File Type")
        {
            Caption = 'File Type';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(6; "File Extension"; Text[50])
        {
            Caption = 'File Extension';
            Editable = false;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                case LowerCase("File Extension") of
                    'jpg', 'jpeg', 'bmp', 'png', 'tiff', 'tif', 'gif':
                        "File Type" := "File Type"::Image;
                    'pdf':
                        "File Type" := "File Type"::PDF;
                    'docx', 'doc':
                        "File Type" := "File Type"::Word;
                    'xlsx', 'xls':
                        "File Type" := "File Type"::Excel;
                    'pptx', 'ppt':
                        "File Type" := "File Type"::PowerPoint;
                    'msg':
                        "File Type" := "File Type"::Email;
                    'xml':
                        "File Type" := "File Type"::XML;
                    'sql':
                        "File Type" := "File Type"::SQL;
                    else
                        "File Type" := "File Type"::Other;
                end;
            end;
        }

        field(9; "File"; Media)
        {
            Caption = 'File';
            DataClassification = CustomerContent;
        }


        field(10; "Last Change Date"; DateTime)
        {
            Caption = 'Last change';
            Editable = false;
        }

        field(11; "Changed by"; Guid)
        {
            DataClassification = EndUserIdentifiableInformation;
        }

        field(12; "Last Change by"; Code[50])
        {
            Caption = 'Last Change by';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(User."User Name" where("User Security ID" = field("Changed By")));
        }

        field(20; "Hash Code (SHA256)"; Text[64])
        {
            Caption = 'Hash Code (SHA256)';
            Editable = false;
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PrimaryKey; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "File Name", Description)
        {

        }
    }

    trigger OnInsert()
    var
        FileManagement: Codeunit "File Management";
    begin
        if IncomingFileName <> '' then begin
            Rec.Validate("File Extension", FileManagement.GetExtension(IncomingFileName));
            Rec.Validate("File Name", CopyStr(FileManagement.GetFileNameWithoutExtension(IncomingFileName), 1, MaxStrLen(Rec."File Name")));
        end;

        if not Rec.File.HasValue() then
            Error(NoDocumentAttachedErr);

        Rec.Validate("Last Change Date", CurrentDateTime());
        Rec."Changed by" := UserSecurityId();

        CreateSqlParameter();
    end;

    trigger OnModify()
    var
        ConfirmQst: Label 'Do you want to overwrite SqlParameter?';
    begin
        if SqlParameterExist() then
            if Confirm(ConfirmQst) then
                ReCreateSqlParameter();
    end;

    trigger OnDelete()
    begin
        DeleteSqlParameter();
    end;

    local procedure CreateSha256Hash(TempBlob: Codeunit "Temp Blob"): Text[64]
    var
        CryptographyMgt: Codeunit "Cryptography Management";
        HashAlgorithmType: Option MD5,SHA1,SHA256,SHA384,SHA512;
        InStr: InStream;
    begin
        TempBlob.CreateInStream(InStr, TextEncoding::UTF8);
        exit(CopyStr(CryptographyMgt.GenerateHash(InStr, HashAlgorithmType::SHA256), 1, 64));
    end;


    procedure Export(ShowFileDialog: Boolean): Text
    var
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        DocumentStream: OutStream;
        FullFileName: Text;
    begin
        // Ensure document has value in DB
        if not Rec.File.HasValue() then
            exit;

        FullFileName := Rec."File Name" + '.' + Rec."File Extension";
        TempBlob.CreateOutStream(DocumentStream);
        Rec.File.ExportStream(DocumentStream);
        exit(FileManagement.BLOBExport(TempBlob, FullFileName, ShowFileDialog));
    end;


    procedure Import(FileName: Text; TempBlob: Codeunit "Temp Blob")
    var
        FileManagement: Codeunit "File Management";
        DocStream: InStream;
        Sha256Hash: Text[64];
    begin
        if FileName = '' then
            Error(EmptyFileNameErr);
        // Validate file/media is not empty
        if not TempBlob.HasValue() then
            Error(NoContentErr);

        IncomingFileName := FileName;

        Rec.Validate("File Extension", FileManagement.GetExtension(IncomingFileName));
        Rec.Validate("File Name", CopyStr(FileManagement.GetFileNameWithoutExtension(IncomingFileName), 1, MaxStrLen(Rec."File Name")));

        Sha256Hash := CreateSha256Hash(TempBlob);
        if Rec."Hash Code (SHA256)" <> Sha256Hash then begin
            TempBlob.CreateInStream(DocStream);
            Rec.File.ImportStream(DocStream, '', '');
            Rec.Validate("Hash Code (SHA256)", Sha256Hash);
        end;

        if not Rec.File.HasValue() then
            Error(NoDocumentAttachedErr);
        Rec.Insert(true);
    end;

    [TryFunction]
    procedure GetScript(var SqlScript: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        DocumentOutStream: OutStream;
        DocumentInStream: InStream;

        StreamReader: DotNet StreamReader;
        Encoding: DotNet Encoding;
    begin
        Clear(SqlScript);

        // Ensure document has value in DB
        if not Rec.File.HasValue() then
            exit;

        TempBlob.CreateOutStream(DocumentOutStream, TextEncoding::UTF8);
        Rec.File.ExportStream(DocumentOutStream);
        TempBlob.CreateInStream(DocumentInStream, TextEncoding::UTF8);

        StreamReader := StreamReader.StreamReader(DocumentInStream, Encoding.UTF8, true);
        SqlScript := StreamReader.ReadToEnd();
    end;

    procedure Execute()
    var
        SqlScriptMapping: Record "jdi Sql Script Mapping";
        SqlConnection: Record "jdi Sql Connection";
        SqlConnectionList: Page "jdi Sql Connection List";
    begin
        SqlConnectionList.LookupMode(true);
        if (SqlConnectionList.RunModal() = Action::LookupOK) then begin
            SqlConnectionList.GetRecord(SqlConnection);

            if SqlScriptMapping.Get(SqlConnection."No.", Rec."No.") then
                SqlScriptMapping.Execute()
            else
                CreateAndExecuteSqlScriptMapping(SqlConnection);
        end;
    end;


    procedure Execute(SqlConnection: Record "jdi Sql Connection")
    var
        SqlScriptMapping: Record "jdi Sql Script Mapping";
    begin
        if SqlScriptMapping.Get(SqlConnection."No.", Rec."No.") then
            SqlScriptMapping.Execute()
        else
            CreateAndExecuteSqlScriptMapping(SqlConnection);
    end;

    procedure ViewScript()
    var
        SqlScriptEditor: Page "jdi Sql Script Editor";
    begin
        Clear(SqlScriptEditor);
        SqlScriptEditor.SetHideSaveButton(true);
        SqlScriptEditor.SetRecord(Rec);
        SqlScriptEditor.Run();
    end;


    procedure EditScript()
    var
        SqlScriptEditor: Page "jdi Sql Script Editor";
    begin
        Clear(SqlScriptEditor);
        SqlScriptEditor.SetRecord(Rec);
        SqlScriptEditor.Run();
    end;

    procedure SaveScript(NewCode: Text);
    var
        TempBlob: Codeunit "Temp Blob";
        DocOutStream: OutStream;
        DocInStream: InStream;
        Sha256Hash: Text[64];
    begin
        TempBlob.CreateOutStream(DocOutStream, TextEncoding::UTF8);
        DocOutStream.WriteText(NewCode);

        Sha256Hash := CreateSha256Hash(TempBlob);

        if Rec."Hash Code (SHA256)" <> Sha256Hash then begin
            TempBlob.CreateInStream(DocInStream, TextEncoding::UTF8);
            Rec.File.ImportStream(DocInStream, '', '');

            Rec.Validate("Hash Code (SHA256)", Sha256Hash);
            Rec.Validate("Last Change Date", CurrentDateTime());
            Rec."Changed by" := UserSecurityId();
            Rec.Modify(true);
        end;
    end;

    procedure DeleteSqlParameter()
    var
        SqlParameter: Record "jdi Sql Parameter";
    begin
        SqlParameter.SetRange("Sql Script No.", Rec."No.");
        if SqlParameter.FindSet() then
            SqlParameter.DeleteAll(true);
    end;

    procedure CreateSqlParameter()
    var
        SqlParameterMgt: Codeunit "jdi Sql Parameter Mgt";
    begin
        SqlParameterMgt.CreateSqlParameter(Rec);
    end;

    procedure ReCreateSqlParameter()
    begin
        DeleteSqlParameter();
        CreateSqlParameter();
    end;

    procedure SqlParameterExist(): Boolean;
    var
        SqlParameter: Record "jdi Sql Parameter";
    begin
        SqlParameter.SetRange("Sql Script No.", Rec."No.");
        exit(not SqlParameter.IsEmpty());
    end;

    procedure SqlParameterExist(var SqlParameter: Record "jdi Sql Parameter"): Boolean;
    begin
        SqlParameter.SetRange("Sql Script No.", Rec."No.");
        exit(not SqlParameter.IsEmpty());
    end;


    local procedure CreateAndExecuteSqlScriptMapping(SqlConnection: Record "jdi Sql Connection")
    var
        SqlScriptMapping: Record "jdi Sql Script Mapping";
    begin
        CreateSqlScriptMapping(SqlConnection, SqlScriptMapping);
        SqlScriptMapping.Execute();
    end;

    local procedure CreateSqlScriptMapping(SqlConnection: Record "jdi Sql Connection"; var SqlScriptMapping: Record "jdi Sql Script Mapping")
    begin
        SqlScriptMapping.Init();
        SqlScriptMapping."Sql Connection No." := SqlConnection."No.";
        SqlScriptMapping."Sql Script No." := Rec."No.";
        SqlScriptMapping.Insert(true);
    end;


    var
        IncomingFileName: Text;
        NoDocumentAttachedErr: Label 'Please attach a document first.', Comment = 'NoDocumentAttachedError';
        EmptyFileNameErr: Label 'Please choose a file to attach.', Comment = 'EmptyFileNameError';
        NoContentErr: Label 'The selected file has no content. Please choose another file.', Comment = 'NoContentError';
}
