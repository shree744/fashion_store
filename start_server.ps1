param(
    [switch]$Debug
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$workspace = Resolve-Path $scriptDir
$maven_path = "$workspace\apache-maven-3.9.6"
$tomcat_path = "$workspace\apache-tomcat-10.1.18"

if (-not (Test-Path $maven_path) -and $env:MAVEN_HOME) {
    $maven_path = $env:MAVEN_HOME
}

if (-not (Test-Path $tomcat_path) -and $env:TOMCAT_HOME) {
    $tomcat_path = $env:TOMCAT_HOME
}

# fallback search for locally installed Tomcat
if (-not (Test-Path $tomcat_path)) {
    $candidatePaths = @(
        "C:\tomcat\apache-tomcat-10.1.54",
        "C:\Users\$env:USERNAME\OneDrive\apache-tomcat-10.1.36",
        "C:\apache-tomcat-*"
    )

    foreach ($candidate in $candidatePaths) {
        if ($candidate -match '\*') {
            $found = Get-ChildItem -Path $candidate -Directory -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($found) {
                $tomcat_path = $found.FullName
                break
            }
        }
        else {
            if (Test-Path $candidate -PathType Container) {
                $tomcat_path = $candidate
                break
            }
        }
    }
}

if (-not (Test-Path $tomcat_path)) {
    Write-Host "Tomcat path not found. Please set TOMCAT_HOME to your Tomcat installation."
    Write-Host "Found candidate folders:"
    Get-ChildItem -Path 'C:\' -Filter 'apache-tomcat*' -Directory -Recurse -ErrorAction SilentlyContinue | Select-Object FullName
    exit 1
}

$skipBuild = $false
# fallback search for Maven in PATH
if (-not (Test-Path $maven_path)) {
    $mvnCommand = Get-Command mvn -ErrorAction SilentlyContinue
    if ($mvnCommand) {
        Write-Host "Found Maven executable in PATH: $($mvnCommand.Source)"
        $maven_path = Split-Path -Parent $mvnCommand.Source
    }
    elseif (Test-Path "$workspace\target\FashionStore.war") {
        Write-Host "Maven not found, but existing WAR detected. Skipping build."
        $skipBuild = $true
    }
    else {
        Write-Host "Maven path not found. Please set MAVEN_HOME, install Maven, or add mvn to PATH."
        Write-Host "Expected local location: $maven_path"
        exit 1
    }
}

# 1. Kill any existing server on port 8080
$port = 8080
try {
    $process = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
    if ($process) {
        Write-Host "Killing existing server on port $port..."
        Stop-Process -Id $process.OwningProcess -Force -ErrorAction SilentlyContinue
    }
}
catch {
    # Ignore errors if no process is found
}

# 2. Set JAVA_HOME if not already set
if (-not $env:JAVA_HOME) {
    $env:JAVA_HOME = "C:\Program Files\Java\jdk-25.0.2"
}

# 3. Build project with Maven if needed
if ($skipBuild) {
    Write-Host "Skipping build because existing WAR is available."
}
else {
    Write-Host "Building project..."
    if (Test-Path $maven_path) {
        $env:Path += ";$maven_path\bin"
    }
    mvn clean package -DskipTests
}

# 4. Copy WAR to Tomcat
Write-Host "Deploying to Tomcat..."
if (!(Test-Path "$tomcat_path\webapps")) {
    New-Item -ItemType Directory -Path "$tomcat_path\webapps" -Force
}
Copy-Item "target\FashionStore.war" -Destination "$tomcat_path\webapps\FashionStore.war" -Force

# 5. Start Tomcat
Write-Host "Starting Tomcat at $tomcat_path..."
$env:CATALINA_HOME = $tomcat_path
if ($Debug) {
    Write-Host "Starting Tomcat in JPDA debug mode..."
    Start-Process -FilePath "$tomcat_path\bin\catalina.bat" -ArgumentList "jpda start" -WindowStyle Normal
    Write-Host "Tomcat debug started on port 8000."
}
else {
    Start-Process -FilePath "$tomcat_path\bin\startup.bat" -WindowStyle Normal
}

Write-Host "Done! Server is launching. Open http://localhost:8080/FashionStore once Tomcat has started."
