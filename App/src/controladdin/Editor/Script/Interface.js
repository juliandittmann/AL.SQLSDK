/**
 * Called from NAV
 */

function CreateControl()
{
    SqlEditor.show();
}

/**
 * Called from NAV
 * @param {Text} Code 
 */
function SetCode(Code){
    SqlEditor.setCode(Code);
}

function GetModifedCode(){
    SqlEditor.save();
}
