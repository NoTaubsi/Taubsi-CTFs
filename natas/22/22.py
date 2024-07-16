import requests
from requests.auth import HTTPBasicAuth 

response = requests.get('http://natas22.natas.labs.overthewire.org/?revelio', auth=HTTPBasicAuth('natas22', '***REMOVED***'), allow_redirects=False)

# Die endgültige URL nach allen Weiterleitungen
print("Final URL:", response.url)

# Statuscode der endgültigen Antwort
print("Final Status Code:", response.status_code)

# Alle Weiterleitungen (History)
for resp in response.history:
    print("Redirected from:", resp.url, "Status Code:", resp.status_code)