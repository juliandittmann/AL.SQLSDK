page 50104 "jdi Sql Script List"
{
    PageType = List;
    ApplicationArea = all;
    SourceTable = "jdi Sql Script";
    Caption = 'Sql Scripts';

    UsageCategory = Lists;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    Caption = 'No.';
                    ApplicationArea = All;
                }

                field("File Name"; Rec."File Name")
                {
                    Caption = 'File Name';
                    ToolTip = 'File Name';
                    ApplicationArea = all;
                    Editable = false;
                    trigger OnDrillDown()
                    var
                        TempBlob: Codeunit "Temp Blob";
                    begin
                        if Rec.File.HasValue() then
                            Rec.Export(true)
                        else begin
                            Rec."File Name" := CopyStr(FileManagement.BLOBImportWithFilter(TempBlob, ImportTxt, Rec."File Name", StrSubstNo(FileDialogTxt, FilterTxt), FilterTxt), 1, 250);
                            if Rec."File Name" <> '' then
                                Rec.Import(Rec."File Name", TempBlob);
                            CurrPage.Update(false);
                        end;
                    end;
                }
                field("File Extension"; Rec."File Extension")
                {
                    Caption = 'File Extension';
                    ToolTip = 'File Extension';
                    ApplicationArea = all;
                    Editable = false;
                }

                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                    ApplicationArea = all;
                }

                field("Script Type"; Rec."Script Type")
                {
                    Caption = 'Script Type';
                    ApplicationArea = all;
                }

                field("Last Change Date"; Rec."Last Change Date")
                {
                    Caption = 'Last Change';
                    ToolTip = 'Last Change';
                    ApplicationArea = all;
                    Editable = false;
                }

                field("Last Change by"; Rec."Last Change by")
                {
                    Caption = 'Last Change by';
                    ToolTip = 'Last Change by';
                    ApplicationArea = all;
                    Editable = false;
                }

                field("Hash Code (SHA256)"; Rec."Hash Code (SHA256)")
                {
                    Caption = 'Hash Code (SHA256)';
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }


            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Edit Script")
            {
                Caption = 'Edit Script';
                ToolTip = 'Opens Scripteditor';
                ApplicationArea = all;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;

                Scope = "Repeater";

                Image = Edit;

                trigger OnAction()
                begin
                    Rec.EditScript();
                end;
            }

            action(Execute)
            {
                Caption = 'Execute';
                ToolTip = 'Execute';
                ApplicationArea = all;
                Promoted = true;
                PromotedIsBig = true;
                Scope = "Repeater";

                Image = ExecuteBatch;

                trigger OnAction()
                begin
                    Rec.Execute();
                end;
            }

            action(Download)
            {
                Caption = 'Download';
                ToolTip = 'Download';
                ApplicationArea = all;
                Promoted = true;
                PromotedIsBig = true;
                Scope = "Repeater";
                Image = Export;

                trigger OnAction()
                begin
                    if Rec."File Name" <> '' then
                        Rec.Export(true);
                end;
            }

            group(Parameter)
            {
                Caption = 'Parameter';
                Image = AboutNav;

                action(ShowSqlParameter)
                {
                    Caption = 'Show SqlParameter';
                    ToolTip = 'Deletes existing SqlParameter and creates new SqlParameter';
                    ApplicationArea = all;
                    Scope = Page;
                    Image = EditList;

                    trigger OnAction()
                    var
                        SqlParameter: Record "jdi Sql Parameter";
                        SqlParameterList: Page "jdi Sql Parameter List";
                    begin
                        SqlParameter.SetRange("Sql Script No.", Rec."No.");
                        if SqlParameter.FindSet() then;
                        SqlParameterList.SetTableView(SqlParameter);
                        SqlParameterList.RunModal();
                    end;
                }

                action(ReCreateSqlParameter)
                {
                    Caption = 'Recreate SqlParameter';
                    ToolTip = 'Deletes existing SqlParameter and creates new SqlParameter';
                    ApplicationArea = all;
                    Scope = Page;
                    Image = CreateDocument;

                    trigger OnAction()
                    begin
                        Rec.CreateSqlParameter();
                    end;
                }

                action(DeleteSqlParementer)
                {
                    Caption = 'Delete SqlParameter';
                    ToolTip = 'Deletes existing SqlParameter.';
                    ApplicationArea = all;
                    Scope = Page;
                    Image = Delete;

                    trigger OnAction()
                    begin
                        Rec.DeleteSqlParameter();
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."File Name" := CopyStr(SelectFileTxt, 1, 250);
    end;

    var
        FileManagement: Codeunit "File Management";
        ImportTxt: Label 'Attach a document.', comment = 'Add a file';
        FilterTxt: Label '*.sql', Locked = true;
        FileDialogTxt: Label 'Attachments (%1)|%1', Comment = 'Add     " (%1)|%1"     to the phrase. This is important!';
        SelectFileTxt: Label 'Select File...', Comment = 'With dots please';

}
