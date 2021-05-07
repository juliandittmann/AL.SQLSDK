permissionset 50100 "jdi SQL SDK"
{
    Access = Public;
    Assignable = true;
    Caption = 'SQL SDK';
    Permissions = codeunit "jdi SQL Install" = X,
                  codeunit "jdi SQL Management" = X,
                  codeunit "jdi SQL Parameter Mgt" = X,
                  codeunit "jdi SQL Script Archive Mgt" = X,
                  codeunit "jdi SQL Script Exec Mgt" = X,
                  codeunit "jdi SQL Update" = X,
                  page "jdi SQL Connection Card" = X,
                  page "jdi SQL Connection List" = X,
                  page "jdi SQL Connection String" = X,
                  page "jdi SQL Parameter List" = X,
                  page "jdi SQL Script Archive List" = X,
                  page "jdi SQL Script Editor" = X,
                  page "jdi SQL Script Exec Entry List" = X,
                  page "jdi SQL Script ExecP EntryList" = X,
                  page "jdi SQL Script List" = X,
                  page "jdi SQL Script Mapping List" = X,
                  page "jdi SQL Script Viewer" = X,
                  table "jdi SQL Connection" = X,
                  table "jdi SQL Parameter" = X,
                  table "jdi SQL Script" = X,
                  table "jdi SQL Script Archive" = X,
                  table "jdi SQL Script Exec Entry" = X,
                  table "jdi SQL Script ExecParam Entry" = X,
                  table "jdi SQL Script Mapping" = X,
                  tabledata "jdi SQL Connection" = RIMD,
                  tabledata "jdi SQL Parameter" = RIMD,
                  tabledata "jdi SQL Script" = RIMD,
                  tabledata "jdi SQL Script Archive" = RIMD,
                  tabledata "jdi SQL Script Exec Entry" = RIMD,
                  tabledata "jdi SQL Script ExecParam Entry" = RIMD,
                  tabledata "jdi SQL Script Mapping" = RIMD;
}
