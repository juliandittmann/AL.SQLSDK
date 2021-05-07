permissionset 50150 "jdi SQL Test SDK"
{
    Access = Public;
    Assignable = true;
    Caption = 'SQL SDK Test';
    Permissions = codeunit "jdi SQL Test Helper" = X,
                  codeunit "jdi SQL Test Install" = X,
                  codeunit "jdi SQL Test Upgrade" = X,
                  codeunit "jdi SQL Test Default" = X;
}
