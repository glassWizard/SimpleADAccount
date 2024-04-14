$FILE_PATH = "C:\Scripts\Powershell\student_example\accounts.csv"                            #Location Of User Data File
$COMPLETED_PATH = "C:\Scripts\Powershell\student_example\processed\accounts.csv"             #Location of Where to Move The Completed File To
$TARGET_OU = "OU=NewUsers,DC=myCompany,DC=Local"                                             #The OU to create the user account at
$COMPANY_EMAIL = "@mycompany.com"                                                            #The email suffix to use
$DEFAULT_PW = "FirstPW0001"                                                                  #The Default First Password To Use. 

$userfile = import-csv $FILE_PATH
foreach ($user in $userfile) {
    
    $name = $user.FirstName + " " + $user.LastName
    $samAccountNAme = $user.FirstName + "." + $user.LastName
    $email = $samAccountNAme + $COMPANY_EMAIL
    $pass = ConvertTo-SecureString -String $DEFAULT_PW -AsPlainText -Force


    New-ADUser -Name $name -GivenName $user.FirstName -Surname $user.LastName -EmailAddress $email -SamAccountName $samAccountNAme -UserPrincipalName $email `
    -Title $user.JobTitle -DisplayName $name -ChangePasswordAtLogon $true -EmployeeID $user.EmployeeId -Department $user.Department -Path $TARGET_OU -AccountPassword $pass -Enabled $true -Verbose
}

Move-Item -Path $FILE_PATH -Destination $COMPLETED_PATH
