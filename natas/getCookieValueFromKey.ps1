function getCookieValueFromKey {
    param (
        [Parameter(Mandatory = $true)]
        [Microsoft.PowerShell.Commands.WebRequestSession]
        $sessVar,
        [Parameter(Mandatory = $true)]
        [string]
        $key
    )
    $cookies = $sessVar.Cookies.GetCookies($url)
    $sessionCookie = $cookies | Where-Object { $_.Name -eq "$key" }

    if ($sessionCookie) {
        $sessionId = $sessionCookie.Value
        return $sessionId
    }
}