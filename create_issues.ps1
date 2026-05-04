$issues = Get-Content -Raw -Path "issues.json" | ConvertFrom-Json
$count = 0
foreach ($issue in $issues) {
    $count++
    Write-Host "Creating issue $count/50: $($issue.title)"
    gh issue create --title $issue.title --body $issue.body
    Start-Sleep -Milliseconds 500
}
Write-Host "All issues created."
