page 50109 "jdi Sql Script Mapping List"
{

    PageType = List;
    SourceTable = "jdi Sql Script Mapping";
    Caption = 'Sql Script Mapping List';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Sql Connection No."; Rec."Sql Connection No.")
                {
                    ApplicationArea = All;
                }
                field("Sql Script No."; Rec."Sql Script No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec."Description")
                {
                    ApplicationArea = all;
                }
                field("Last Execution Date"; Rec."Last Execution Date")
                {
                    ApplicationArea = All;
                }

                field("Last Execution by"; Rec."Last Execution by")
                {
                    ApplicationArea = All;
                }

                field("Last Change"; Rec."Last Change")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Edit)
            {
                Caption = 'Edit';
                ToolTip = 'Edit';
                ApplicationArea = all;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                Scope = "Repeater";

                Image = Edit;

                trigger OnAction()
                var
                    SqlScript: Record "jdi Sql Script";
                begin
                    if SqlScript.get(Rec."Sql Script No.") then
                        SqlScript.EditScript();
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
                var
                    SqlScript: Record "jdi Sql Script";
                begin
                    if SqlScript.Get(Rec."Sql Script No.") then
                        if SqlScript."File Name" <> '' then
                            SqlScript.Export(true);
                end;
            }

            group(Paramenter)
            {
                Caption = 'Paramenter';
                Image = AboutNav;

                action(ShowSqlParamenter)
                {
                    Caption = 'Show SqlParamenter';
                    ToolTip = 'Deletes existing SqlParamenter and creates new SqlParamenter';
                    ApplicationArea = all;
                    Scope = Page;
                    Image = EditList;

                    trigger OnAction()
                    var
                        SqlScript: Record "jdi Sql Script";
                        SqlParamenter: Record "jdi Sql Parameter";
                        SqlParamenterList: Page "jdi Sql Paramenter List";
                    begin
                        if SqlScript.Get(Rec."Sql Script No.") then begin
                            SqlParamenter.SetRange("Sql Script No.", SqlScript."No.");
                            if SqlParamenter.FindSet() then;
                            SqlParamenterList.SetTableView(SqlParamenter);
                            SqlParamenterList.RunModal();
                        end;
                    end;
                }

                action(ReCreateSqlParamenter)
                {
                    Caption = 'Recreate SqlParamenter';
                    ToolTip = 'Deletes existing SqlParamenter and creates new SqlParamenter';
                    ApplicationArea = all;
                    Scope = Page;
                    Image = CreateDocument;

                    trigger OnAction()
                    var
                        SqlScript: Record "jdi Sql Script";
                    begin
                        if SqlScript.Get(Rec."Sql Script No.") then
                            SqlScript.CreateSqlParamenter();
                    end;
                }

                action(DeleteSqlParementer)
                {
                    Caption = 'Delete SqlParamenter';
                    ToolTip = 'Deletes existing SqlParamenter.';
                    ApplicationArea = all;
                    Scope = Page;
                    Image = Delete;

                    trigger OnAction()
                    var
                        SqlScript: Record "jdi Sql Script";
                    begin
                        if SqlScript.Get(Rec."Sql Script No.") then
                            SqlScript.DeleteSqlParamenter();
                    end;
                }
            }
        }
    }
}
