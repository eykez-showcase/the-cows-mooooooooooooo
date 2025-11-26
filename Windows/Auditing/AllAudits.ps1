# Get all subcategories
$subcats = auditpol /list /subcategory:* | Select-String "^\s+\S"

foreach ($sub in $subcats) {
    $subName = $sub.ToString().Trim()
    auditpol /set /subcategory:"$subName" /success:enable /failure:enable
}
