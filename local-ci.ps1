param(
    [ValidateSet('all', 'lint', 'typecheck', 'test')]
    [string]$Check = 'all'
)

$ErrorActionPreference = 'Stop'
$Image = 'logicluminaries-local-ci:latest'

& docker build -f local-ci.dockerfile -t $Image .
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$ProjectPath = (Get-Location).Path
& docker run --rm --mount "type=bind,source=$ProjectPath,target=/app" -w /app $Image $Check
exit $LASTEXITCODE
