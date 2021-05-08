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
                        SqlScript: Record "jdi Sql Script";
                        SqlParameter: Record "jdi Sql Parameter";
                        SqlParameterList: Page "jdi Sql Parameter List";
                    begin
                        if SqlScript.Get(Rec."Sql Script No.") then begin
                            SqlParameter.SetRange("Sql Script No.", SqlScript."No.");
                            if SqlParameter.FindSet() then;
                            SqlParameterList.SetTableView(SqlParameter);
                            SqlParameterList.RunModal();
                        end;
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
                    var
                        SqlScript: Record "jdi Sql Script";
                    begin
                        if SqlScript.Get(Rec."Sql Script No.") then
                            SqlScript.CreateSqlParameter();
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
                    var
                        SqlScript: Record "jdi Sql Script";
                    begin
                        if SqlScript.Get(Rec."Sql Script No.") then
                            SqlScript.DeleteSqlParameter();
                    end;
                }
            }
        }
    }
}
