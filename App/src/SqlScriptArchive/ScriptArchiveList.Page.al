page 50110 "jdi Sql Script Archive List"
{
    PageType = List;
    SourceTable = "jdi Sql Script Archive";
    Caption = 'Sql Script Archive List';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Sql Script No."; Rec."Sql Script No.")
                {
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec."Description")
                {
                    ApplicationArea = All;
                }
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = All;
                }
                field("File Type"; Rec."File Type")
                {
                    ApplicationArea = All;
                }
                field("File Extension"; Rec."File Extension")
                {
                    ApplicationArea = All;
                }

                field("Last Change Date"; Rec."Last Change Date")
                {
                    ApplicationArea = All;
                }

                field("Last Change by"; Rec."Last Change by")
                {
                    ApplicationArea = All;
                }
                field("Hash Code (SHA256)"; Rec."Hash Code (SHA256)")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("View Script")
            {
                Caption = 'View Script';
                ToolTip = 'Opens Scripteditor';
                ApplicationArea = all;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;

                Scope = "Repeater";

                Image = Edit;

                trigger OnAction()
                begin
                    Rec.ViewScript();
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
        }
    }
}
