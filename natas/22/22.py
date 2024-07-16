import requests
from requests.auth import HTTPBasicAuth 

response = requests.get('http://natas22.natas.labs.overthewire.org/?revelio', auth=HTTPBasicAuth('user', 'password'), allow_redirects=False)

# Die URL nach allen Redirects
print("Final URL:", response.url)

# Statuscode der endgültigen antwort
print("Final Status Code:", response.status_code)

# Alle Redirects
for resp in response.history:
    print("Redirected from:", resp.url, "Status Code:", resp.status_code)