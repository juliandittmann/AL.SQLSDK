table 50105 "jdi SQL Script Archive"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "SQL Script No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "jdi SQL Script"."No.";
            Editable = false;
        }

        field(2; "Entry No."; Integer)
        {
            DataClassification = SystemMetadata;
            Editable = false;
        }

        field(3; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            Editable = false;
        }


        field(4; "File Name"; Text[250])
        {
            Caption = 'File name';
            DataClassification = CustomerContent;
            Editable = false;
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
        }

        field(9; "File"; Media)
        {
            Caption = 'File';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(10; "Last Change Date"; DateTime)
        {
            Caption = 'Last change';
            Editable = false;
        }

        field(11; "Changed by"; Guid)
        {
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
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
        key(PrimaryKey; "SQL Script No.", "Entry No.")
        {
            Clustered = true;
        }
    }

    procedure Export(ShowFileDialog: Boolean): Text
    var
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        DocumentStream: OutStream;
        FullFileName: Text;
    begin
        // Ensure document has value in DB
        if not File.HasValue() then
            exit;

        FullFileName := "File Name" + '.' + "File Extension";
        TempBlob.CreateOutStream(DocumentStream);
        File.ExportStream(DocumentStream);
        exit(FileManagement.BLOBExport(TempBlob, FullFileName, ShowFileDialog));
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
        if not File.HasValue() then
            exit;

        TempBlob.CreateOutStream(DocumentOutStream, TextEncoding::UTF8);
        File.ExportStream(DocumentOutStream);
        TempBlob.CreateInStream(DocumentInStream, TextEncoding::UTF8);

        StreamReader := StreamReader.StreamReader(DocumentInStream, Encoding.UTF8, true);
        SQLScript := StreamReader.ReadToEnd();
    end;

    procedure ViewScript()
    var
        SQLScriptViewer: Page "jdi SQL Script Viewer";
    begin
        Clear(SQLScriptViewer);
        SQLScriptViewer.SetRecord(Rec);
        SQLScriptViewer.Run();
    end;

    procedure GetNextEntryNo() NextEntryNo: Integer
    var
        SQLScriptArchive: Record "jdi SQL Script Archive";
    begin
        TestField("SQL Script No.");
        SQLScriptArchive.SetRange("SQL Script No.", Rec."SQL Script No.");
        if SQLScriptArchive.FindLast() then
            NextEntryNo := SQLScriptArchive."Entry No." + 1
        else
            NextEntryNo := 1;
    end;

}