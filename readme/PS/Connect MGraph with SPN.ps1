$certificateLocation="c:\temp\"
$certificateName="mycert.pfx"
$certificateFullPath= $certificateLocation+$certificateName
$base64certificateFullPath=$certificateLocation+"mycert_base64.crt"

# Create Certificate of your password
# -NotAfter (Get-Date).AddMonths(24)).Thumbprint Valid for 24mnths
$pwd = "CertificatePassword"
$thumb = (New-SelfSignedCertificate -DnsName $certificateName -CertStoreLocation "cert:\LocalMachine\My"  -KeyExportPolicy Exportable -Provider "Microsoft Enhanced RSA and AES Cryptographic Provider" -NotAfter (Get-Date).AddMonths(24)).Thumbprint
$pwd = ConvertTo-SecureString -String $pwd -Force -AsPlainText
Export-PfxCertificate -cert "cert:\localmachine\my\$thumb" -FilePath $certificateFullPath -Password $pwd

#convert the certificate to Base64
$cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate($certificateFullPath, $pwd)
$keyValue = [System.Convert]::ToBase64String($cert.GetRawCertData()) | Out-File $base64certificateFullPath

## Upload yout certificate to Azure AD/Entra & Copy Thumbprint
## API permissions User.Read.All & User.ReadBasic.All

$tenantID = "TENANT_ID"
$applicationID = "APPLICATION_CLIENT_ID"
$thumbprint = "THUMBPRINT"
 
#Connect-MgGraph -ClientID $applicationID -TenantId $tenantID -CertificateThumbprint $thumbprint -nowelcome