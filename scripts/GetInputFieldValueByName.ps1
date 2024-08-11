function GetInputFieldValueByName {
    param (
        [Parameter(Mandatory = $true)]
        [Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject]$iwrResponse,
        [Parameter(Mandatory = $true)]
        [string]$FieldName
    )
    $csrf = $iwrResponse.InputFields.FindByName("$FieldName").Value;
    if (!$csrf) {
        write-host "CSRF Empty";
        exit
    }
    return $csrf
}