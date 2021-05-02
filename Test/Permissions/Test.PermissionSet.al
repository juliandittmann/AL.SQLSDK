permissionset 50150 "jdi SQL API Test"
{
    Access = Public;
    Assignable = true;
    Caption = 'SQL API Test';
    Permissions = codeunit "jdi SQL API Test Helper" = X,
                  codeunit "jdi SQL API Test Install" = X,
                  codeunit "jdi SQL API Test Upgrade" = X,
                  codeunit "jdi SQL API Test Default" = X;
}
