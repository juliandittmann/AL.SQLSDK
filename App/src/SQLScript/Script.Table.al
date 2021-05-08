table 50102 "jdi SQL Script"
{
    DataClassification = CustomerContent;
    LookupPageId = "jdi SQL Script List";
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

        field(3; "Script Type"; Enum "jdi SQL Script Type")
        {
            Caption = 'SQL Script Type';
            DataClassification = CustomerContent;
        }

        field(4; "File Name"; Text[250])
        {
            Caption = 'File name';
            DataClassification = CustomerContent;
        }

        field(5; "File Type"; Enum "jdi SQL File Type")
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
                    'SQL':
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

        CreateSQLParameter();
    end;

    trigger OnModify()
    var
        ConfirmQst: Label 'Do you want to overwrite SQLParameter?';
    begin
        if SQLParameterExist() then
            if Confirm(ConfirmQst) then
                ReCreateSQLParameter();
    end;

    trigger OnDelete()
    begin
        DeleteSQLParameter();
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
    procedure GetScript(var SQLScript: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        DocumentOutStream: OutStream;
        DocumentInStream: InStream;

        StreamReader: DotNet StreamReader;
        Encoding: DotNet Encoding;
    begin
        Clear(SQLScript);

        // Ensure document has value in DB
        if not Rec.File.HasValue() then
            exit;

        TempBlob.CreateOutStream(DocumentOutStream, TextEncoding::UTF8);
        Rec.File.ExportStream(DocumentOutStream);
        TempBlob.CreateInStream(DocumentInStream, TextEncoding::UTF8);

        StreamReader := StreamReader.StreamReader(DocumentInStream, Encoding.UTF8, true);
        SQLScript := StreamReader.ReadToEnd();
    end;

    procedure Execute()
    var
        SQLScriptMapping: Record "jdi SQL Script Mapping";
        SQLConnection: Record "jdi SQL Connection";
        SQLConnectionList: Page "jdi SQL Connection List";
    begin
        SQLConnectionList.LookupMode(true);
        if (SQLConnectionList.RunModal() = Action::LookupOK) then begin
            SQLConnectionList.GetRecord(SQLConnection);

            if SQLScriptMapping.Get(SQLConnection."No.", Rec."No.") then
                SQLScriptMapping.Execute()
            else
                CreateAndExecuteSQLScriptMapping(SQLConnection);
        end;
    end;


    procedure Execute(SQLConnection: Record "jdi SQL Connection")
    var
        SQLScriptMapping: Record "jdi SQL Script Mapping";
    begin
        if SQLScriptMapping.Get(SQLConnection."No.", Rec."No.") then
            SQLScriptMapping.Execute()
        else
            CreateAndExecuteSQLScriptMapping(SQLConnection);
    end;

    procedure ViewScript()
    var
        SQLScriptEditor: Page "jdi SQL Script Editor";
    begin
        Clear(SQLScriptEditor);
        SQLScriptEditor.SetHideSaveButton(true);
        SQLScriptEditor.SetRecord(Rec);
        SQLScriptEditor.Run();
    end;


    procedure EditScript()
    var
        SQLScriptEditor: Page "jdi SQL Script Editor";
    begin
        Clear(SQLScriptEditor);
        SQLScriptEditor.SetRecord(Rec);
        SQLScriptEditor.Run();
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

    procedure DeleteSQLParameter()
    var
        SQLParameter: Record "jdi SQL Parameter";
    begin
        SQLParameter.SetRange("SQL Script No.", Rec."No.");
        if SQLParameter.FindSet() then
            SQLParameter.DeleteAll(true);
    end;

    procedure CreateSQLParameter()
    var
        SQLParameterMgt: Codeunit "jdi SQL Parameter Mgt";
    begin
        SQLParameterMgt.CreateSQLParameter(Rec);
    end;

    procedure ReCreateSQLParameter()
    begin
        DeleteSQLParameter();
        CreateSQLParameter();
    end;

    procedure SQLParameterExist(): Boolean;
    var
        SQLParameter: Record "jdi SQL Parameter";
    begin
        SQLParameter.SetRange("SQL Script No.", Rec."No.");
        exit(not SQLParameter.IsEmpty());
    end;

    procedure GetSQLParameter() Parameter: Dictionary of [Text, Text];
    var
        SQLParameter: Record "jdi SQL Parameter";
    begin
        SQLParameter.SetRange("SQL Script No.", Rec."No.");
        if SQLParameter.FindSet() then
            repeat
                Parameter.Add(SQLParameter.Name, SQLParameter.Value);
            until SQLParameter.Next() = 0;
    end;

    local procedure CreateAndExecuteSQLScriptMapping(SQLConnection: Record "jdi SQL Connection")
    begin
        CreateSQLScriptMapping(SQLConnection).Execute();
    end;

    local procedure CreateSQLScriptMapping(SQLConnection: Record "jdi SQL Connection") SQLScriptMapping: Record "jdi SQL Script Mapping"
    begin
        SQLScriptMapping.Init();
        SQLScriptMapping."SQL Connection No." := SQLConnection."No.";
        SQLScriptMapping."SQL Script No." := Rec."No.";
        SQLScriptMapping.Insert(true);
    end;

    var
        IncomingFileName: Text;
        NoDocumentAttachedErr: Label 'Please attach a document first.', Comment = 'NoDocumentAttachedError';
        EmptyFileNameErr: Label 'Please choose a file to attach.', Comment = 'EmptyFileNameError';
        NoContentErr: Label 'The selected file has no content. Please choose another file.', Comment = 'NoContentError';
}
