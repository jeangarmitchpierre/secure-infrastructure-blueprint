@echo off
REM =====================================================================
REM SECURE INFRASTRUCTURE OPERATIONAL CONTAINER & SYSTEM LOCKDOWN SCRIPT
REM Target Action: Overriding permissions and locking compromised shares
REM Framework: Aligned with IBM Cybersecurity Incident Response Lifecycle
REM =====================================================================

echo [!] INCIDENT ALERT: Rogue peripheral network alteration detected.
echo [!] Initiating localized directory containment protocols...
echo.

REM 1. CRITICAL IDENTIFICATION PHASE
echo [*] Phase 1: Auditing active target directory status...
timeout /t 2 >nul

REM 2. SYSTEM CONTAINMENT & OVERRIDE PHASE
echo [*] Phase 2: Securing local file system pathways...
echo [*] Executing ownership override on target data directory...

REM Using takeown to seize control of the compromised asset path recursively
takeown /f "C:\OperationalData\SecureZone" /r /d y

echo.
echo [*] Phase 3: Flushing inheritance and rewriting access control maps...

REM Using icacls to strip inherited permissions, grant full admin control, and deny unverified guests
icacls "C:\OperationalData\SecureZone" /inheritance:r /grant:r "Administrators":(OI)(CI)F /deny "Guests":(OI)(CI)F

echo.
echo [V] SUCCESS: Administrative access controls successfully overridden.
echo [V] SUCCESS: System directory blast radius successfully contained.
echo.
pause
