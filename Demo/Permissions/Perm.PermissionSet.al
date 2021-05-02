permissionset 50200 "jdi SQL Demo Perm"
{
    Access = Public;
    Assignable = true;
    Caption = 'SQL API Demo';
    Permissions = codeunit "jdi SQL Demo Install" = X,
                  codeunit "jdi SQL Demo Upgrade" = X,
                  page "jdi SQL Demo sampleviewPage" = X,
                  table "jdi SQL Demo sampleview" = X,
                  tabledata "jdi SQL Demo sampleview" = RIMD;
}
