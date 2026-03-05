-- ============================================================
-- IT Support Triage Agent - Seed Data
-- Run this AFTER schema.sql
-- ============================================================

-- ============================================================
-- KNOWLEDGE BASE ARTICLES (20 articles)
-- ============================================================

-- Access & Identity (6 articles)

INSERT INTO kb_articles (article_id, title, category, subcategory, content, resolution_steps, automation_eligible, automation_level, tools_required) VALUES
('KB-1001', 'Password Reset - Self-Service via Okta', 'access_identity', 'password_reset',
'When a user forgets their password or needs a reset, the primary method is the Okta self-service portal. Users can access the portal at https://company.okta.com/signin/forgot-password and verify their identity using their registered MFA factor (Okta Verify push, SMS, or security question). Once verified, they can set a new password that meets company policy: minimum 12 characters, at least one uppercase, one lowercase, one number, and one special character. Passwords expire every 90 days. Users cannot reuse their last 12 passwords. If self-service is unavailable or the user cannot verify their identity, IT can perform an administrative reset via Azure AD which generates a temporary password sent via the user''s verified personal email. The temporary password expires in 24 hours and must be changed on first login.',
'1. Direct user to https://company.okta.com/signin/forgot-password
2. User selects their MFA verification method (Okta Verify push recommended)
3. User completes identity verification
4. User sets new password meeting policy requirements (12+ chars, mixed case, number, special char)
5. If self-service fails: IT performs admin reset via Azure AD portal
6. Temporary password sent to verified personal email (expires 24h)
7. User must change password on first login after admin reset
8. Verify user can log in to primary workstation and email',
true, 'L3', ARRAY['okta.verify_identity', 'azure_ad.reset_password']);

INSERT INTO kb_articles (article_id, title, category, subcategory, content, resolution_steps, automation_eligible, automation_level, tools_required) VALUES
('KB-1002', 'Account Lockout After Failed Attempts', 'access_identity', 'account_unlock',
'Azure Active Directory enforces an account lockout policy after 5 consecutive failed login attempts within a 10-minute window. When an account is locked, the user will see "Your account has been locked. Contact your IT admin to unlock it" or similar error messages on Windows login, web applications, and VPN. The lockout duration is 30 minutes, after which the account automatically unlocks. Common causes include: saved credentials on mobile devices with old passwords, browser password managers with stale entries, mapped drives or applications using cached credentials, and Outlook profiles with expired passwords. IT can manually unlock the account immediately through Azure AD admin portal or via PowerShell (Unlock-AzureADUser). After unlocking, advise the user to update saved credentials on all devices.',
'1. Verify user identity via Okta Verify push notification
2. Unlock account in Azure AD (Admin portal > Users > Select user > Unlock)
3. Check if password also needs reset (if lockout was due to forgotten password)
4. Advise user to update saved credentials on: mobile email apps, VPN client, browser password managers
5. If repeated lockouts: investigate source IPs in Azure AD sign-in logs for potential compromise
6. For persistent issues: check for service accounts or shared devices using old credentials',
true, 'L3', ARRAY['okta.verify_identity', 'azure_ad.unlock_account']);

INSERT INTO kb_articles (article_id, title, category, subcategory, content, resolution_steps, automation_eligible, automation_level, tools_required) VALUES
('KB-1003', 'MFA Setup and Troubleshooting', 'access_identity', 'mfa_setup',
'All employees are required to enroll in multi-factor authentication (MFA) via Okta. The primary method is Okta Verify (push notification to mobile app). Backup methods include SMS to registered phone number and security questions. Common issues: (1) Okta Verify push not arriving - check phone has internet connectivity, try pulling down to refresh in the app, ensure notifications are enabled for Okta Verify in phone settings. (2) New phone - user needs to re-enroll by visiting https://company.okta.com/enduser/settings and adding a new device under Security Methods. Old device should be removed after new device is verified. (3) Lost phone - IT can temporarily bypass MFA for 24 hours to allow the user to re-enroll. This requires L2 approval and is logged. (4) International travel - Okta Verify push works on Wi-Fi without cellular. SMS may not work internationally. Advise users to set up Okta Verify before traveling.',
'1. For push not arriving: Check phone internet connection, notifications enabled for Okta Verify, try force-close and reopen app
2. For new phone: User goes to https://company.okta.com/enduser/settings > Security Methods > Set up Okta Verify
3. For lost phone: Escalate to L2 for temporary MFA bypass (24 hours, logged)
4. For enrollment issues: Verify user''s Okta profile has correct phone number
5. For persistent failures: Check Okta system status page, verify user''s Okta license is active',
false, 'L2', ARRAY['okta.verify_identity']);

INSERT INTO kb_articles (article_id, title, category, subcategory, content, resolution_steps, automation_eligible, automation_level, tools_required) VALUES
('KB-1004', 'New Employee Account Provisioning', 'access_identity', 'account_provision',
'New employee onboarding requires provisioning across multiple systems. The standard onboarding checklist is triggered by HR completing the new hire record in Workday, which initiates automated provisioning for Azure AD account, company email, and base Slack channels. Manual provisioning steps include: VPN certificate generation (requires InfoSec approval for remote workers), department-specific application access (e.g., Figma for Design, Tableau for Analytics), shared drive and SharePoint site permissions, printer and badge access for on-site employees, and laptop enrollment in Intune/SCCM for endpoint management. Standard provisioning SLA is 2 business days before start date. Rush provisioning (same-day) requires manager and IT Director approval. Common issues: Workday record incomplete (missing department code, manager, or start date), license pool exhausted for specific applications, VPN cert generation backlog during high-hire periods.',
'1. Verify Workday record is complete (department, manager, title, start date, location)
2. Confirm Azure AD account auto-provisioned (check Workday > Azure AD sync logs)
3. Create email distribution group memberships per department template
4. Provision VPN certificate if remote/hybrid (requires InfoSec approval form)
5. Set up department-specific applications per role matrix
6. Assign shared drive and SharePoint permissions per department template
7. For on-site: submit badge access request + assign nearest printer
8. Verify laptop is enrolled in Intune and base software deployed
9. Send welcome email with login instructions and IT orientation calendar invite',
false, 'L1', NULL);

INSERT INTO kb_articles (article_id, title, category, subcategory, content, resolution_steps, automation_eligible, automation_level, tools_required) VALUES
('KB-1005', 'Shared Mailbox Access Request', 'access_identity', 'mailbox_access',
'Shared mailboxes in Exchange Online are used for team email addresses (e.g., support@company.com, finance@company.com). Access is managed through Azure AD security groups. To request access, the employee''s manager must submit an approval via the IT portal or email IT with the shared mailbox name and the employee''s email. Access is typically granted within 4 hours during business hours. Once added to the security group, the shared mailbox appears automatically in the user''s Outlook within 30 minutes (may require Outlook restart). Users have Send As and Send on Behalf permissions by default. Full access vs delegate access depends on the mailbox configuration. Auto-mapping can be disabled if the user doesn''t want the mailbox appearing in their Outlook profile. Removal of access follows the same process, initiated by the manager.',
'1. Verify request comes from or is approved by the employee''s manager
2. Identify the shared mailbox security group in Azure AD
3. Add user to the security group (Azure AD > Groups > Add member)
4. Wait 30 minutes for Exchange Online sync
5. User should restart Outlook to see the shared mailbox
6. If not appearing: check user''s Exchange Online license, try removing and re-adding profile
7. For Send As issues: verify mailbox permissions in Exchange Admin Center',
false, 'L2', NULL);

INSERT INTO kb_articles (article_id, title, category, subcategory, content, resolution_steps, automation_eligible, automation_level, tools_required) VALUES
('KB-1006', 'AD Group Membership Changes', 'access_identity', 'group_membership',
'Active Directory security groups control access to network resources, applications, and file shares. Changes to group membership require documented approval from the group owner (typically a department head or application admin) and are considered sensitive operations due to the potential for privilege escalation. Standard process: requester submits a ticket with the group name, justification, and duration (permanent or time-bound). The group owner approves. L2 agent executes the change. All changes are logged to the audit trail with the ticket ID, approver, and timestamp. High-sensitivity groups (Domain Admins, VPN-FullAccess, FinanceData-ReadWrite) require additional approval from IT Security. Quarterly access reviews are conducted to verify group membership accuracy. Time-bound access is automatically revoked via scheduled task.',
'1. Verify ticket includes: group name, user to add/remove, justification, duration (permanent/time-bound)
2. Identify group owner and confirm approval is documented
3. For high-sensitivity groups (Domain Admins, VPN-FullAccess, etc.): require IT Security approval
4. Execute change in Azure AD (or on-prem AD if hybrid group)
5. Document change in audit log: ticket ID, group, user, action, approver, timestamp
6. For time-bound access: set calendar reminder or scheduled task for revocation
7. Notify requester and user of completed change',
false, 'L1', NULL);

-- Connectivity (4 articles)

INSERT INTO kb_articles (article_id, title, category, subcategory, content, resolution_steps, automation_eligible, automation_level, tools_required) VALUES
('KB-2001', 'VPN Connection Troubleshooting', 'connectivity', 'vpn_troubleshoot',
'The company uses Cisco AnyConnect for VPN connectivity. Supported versions are 4.10.x and above. Known issue: AnyConnect 4.9.x and earlier versions crash on macOS Sonoma (14.x) and have intermittent disconnects on Windows 11 23H2. If a user reports VPN disconnections every 5-10 minutes, the most likely cause is an outdated client version. Other common issues: (1) "Connection attempt has failed" - check internet connectivity first, then try TCP fallback (AnyConnect > Settings > Enable TCP instead of UDP). (2) Certificate expired - VPN certificates expire annually, check expiration in AnyConnect > Settings > Certificate. (3) DNS resolution failures after connecting - clear DNS cache (ipconfig /flushdns on Windows, sudo dscacheutil -flushcache on macOS). (4) Split tunnel not working - verify the VPN profile is set to split-tunnel, not full-tunnel. Full-tunnel routes all traffic through VPN and slows down internet. Contact network team if profile appears incorrect.',
'1. Check AnyConnect version (must be 4.10.x or higher)
2. If 4.9.x or lower: deploy update via SCCM/Intune (KB-2002)
3. Check VPN certificate expiration date
4. Try TCP fallback: AnyConnect > Settings > Allow TCP instead of UDP
5. Clear DNS cache: ipconfig /flushdns (Win) or sudo dscacheutil -flushcache (Mac)
6. Check CMDB for device info and OS version to correlate with known issues
7. If persistent: collect AnyConnect diagnostic log (DART bundle) and escalate to Network Ops',
true, 'L2', ARRAY['cmdb.query_asset', 'sccm.deploy_software']);

INSERT INTO kb_articles (article_id, title, category, subcategory, content, resolution_steps, automation_eligible, automation_level, tools_required) VALUES
('KB-2002', 'VPN Client Update Deployment', 'connectivity', 'vpn_update',
'VPN client updates are deployed via SCCM for Windows devices and Jamf for macOS devices. The current approved version is Cisco AnyConnect 4.10.08029. Updates are packaged and tested by the endpoint engineering team before deployment. For individual deployments (requested via ticket), the process is: (1) Verify device is online and reachable in SCCM/Jamf. (2) Create a targeted deployment for the specific device. (3) The update typically downloads and installs within 15 minutes. (4) A reboot may be required - warn the user to save work. (5) After reboot, verify AnyConnect version in the client. For mass deployments, updates are rolled out in rings: Ring 0 (IT staff, 1 day), Ring 1 (Early adopters, 3 days), Ring 2 (General population, 1 week). Rollback procedure: if the new version causes issues, the previous version can be reinstalled via SCCM task sequence.',
'1. Verify device ID in CMDB and confirm it is managed by SCCM/Jamf
2. Check current AnyConnect version on the device
3. Create targeted SCCM deployment for AnyConnect 4.10.08029
4. Notify user: "Update will install in ~15 min. Please save your work. Reboot may be required."
5. Monitor deployment status in SCCM console
6. After completion: verify new version in AnyConnect client info
7. If deployment fails: check SCCM client health on device, verify disk space (500MB free needed)',
true, 'L2', ARRAY['sccm.deploy_software']);

INSERT INTO kb_articles (article_id, title, category, subcategory, content, resolution_steps, automation_eligible, automation_level, tools_required) VALUES
('KB-2003', 'Wi-Fi Connectivity Issues - Office', 'connectivity', 'wifi_office',
'The corporate Wi-Fi network (SSID: CorpNet-Secure) uses 802.1X authentication with machine certificates. When a device cannot connect, the most common causes are: (1) Certificate expired or missing - device certificates are auto-enrolled via Intune but can fail if the device hasn''t synced recently. Run "certlm.msc" on Windows to check. (2) Device not domain-joined - only domain-joined or Intune-enrolled devices can authenticate to CorpNet-Secure. BYOD devices should use the guest network (CorpNet-Guest) with MFA authentication. (3) Cached credentials stale - forget the network and rejoin (Settings > Network > Wi-Fi > CorpNet-Secure > Forget, then reconnect). (4) IP address conflict - run "ipconfig /release" then "ipconfig /renew". (5) Building-specific outages - check the office status page or contact Facilities for any ongoing network issues in the specific building or floor.',
'1. Forget the CorpNet-Secure network and rejoin
2. Check device certificate: run certlm.msc, look for a valid machine cert under Personal > Certificates
3. Verify device is domain-joined (Settings > Accounts > Access work or school)
4. If BYOD: direct to CorpNet-Guest with MFA
5. Try ipconfig /release then ipconfig /renew
6. Check office network status page for building outages
7. If persistent: try a different Wi-Fi access point (move to another area of the building)',
false, 'L1', NULL);

INSERT INTO kb_articles (article_id, title, category, subcategory, content, resolution_steps, automation_eligible, automation_level, tools_required) VALUES
('KB-2004', 'Network Drive Mapping Failures', 'connectivity', 'network_drive',
'Network drives (shared folders) are mapped automatically via Group Policy for domain-joined devices when connected to the corporate network (on-site or via VPN). Common mapping paths follow the format \\\\fileserver01\\DepartmentShare. When drives fail to map, typical causes include: (1) VPN not connected - network drives require VPN for remote users, confirm VPN is active and connected. (2) Expired credentials - if the user recently changed their password, cached credentials may be stale. Open Credential Manager (Windows) and remove saved entries for the file server, then reconnect. (3) DNS resolution - try accessing the drive by IP address (e.g., \\\\10.0.50.20\\DepartmentShare) instead of hostname. If IP works but hostname doesn''t, it''s a DNS issue - flush DNS cache. (4) Server maintenance - check with the infrastructure team if the file server is under maintenance or has been migrated. (5) Permission changes - if the user recently changed roles or departments, their group membership may have changed, removing drive access.',
'1. Confirm VPN is connected (if remote) or device is on corporate network (if on-site)
2. Try net use \\\\fileserver01\\DepartmentShare /user:domain\\username to test
3. Open Credential Manager > Windows Credentials > remove entries for fileserver01
4. Run ipconfig /flushdns then retry
5. Try accessing by IP address instead of hostname
6. Check user''s AD group membership matches expected department groups
7. If server-side: escalate to Infrastructure team with file server name and error details',
false, 'L1', NULL);

-- Software (4 articles)

INSERT INTO kb_articles (article_id, title, category, subcategory, content, resolution_steps, automation_eligible, automation_level, tools_required) VALUES
('KB-3001', 'Standard Software Catalog', 'software', 'software_catalog',
'The IT-approved software catalog lists applications that have been security reviewed and licensed for company use. Software installation requests outside this catalog require a separate security review (2-3 week process). Pre-approved software available for self-service installation via the Company Portal app: VS Code, Slack Desktop, Zoom, Microsoft Teams, 7-Zip, Notepad++, PuTTY, WinSCP. Department-restricted software (requires role verification): Figma Desktop - Design and Product teams only (50 licenses), Tableau Desktop - Analytics and Data Science teams only (30 licenses), Adobe Creative Cloud - Marketing and Design teams only (25 licenses), AutoCAD - Engineering teams only (10 licenses), Salesforce CLI - Sales Engineering only. For restricted software, the agent must verify the user''s department/role entitlement before approving installation. License pools are tracked in the CMDB. If a pool is exhausted, the request is escalated to the department head for budget approval of additional licenses.',
'1. Check if requested software is in the approved catalog
2. For standard catalog apps: user can self-install via Company Portal (no ticket needed)
3. For department-restricted software: verify user''s department/role in Azure AD
4. Check license availability in CMDB (or license tracking spreadsheet)
5. If entitled and license available: deploy via SCCM/Intune
6. If entitled but no license: escalate to department head for license approval
7. If not in catalog: inform user of the security review process (2-3 weeks)',
true, 'L2', ARRAY['sccm.deploy_software']);

INSERT INTO kb_articles (article_id, title, category, subcategory, content, resolution_steps, automation_eligible, automation_level, tools_required) VALUES
('KB-3002', 'Software Install Request Process', 'software', 'software_install',
'All software installation requests follow a standard workflow to ensure compliance and license management. Step 1: User submits a ticket specifying the software name and business justification. Step 2: Agent checks the software catalog (KB-3001) to determine if the software is approved. Step 3: For approved software, verify the user''s entitlement (department/role match) and license availability. Step 4: If requires manager approval (non-standard or restricted), route approval request to the user''s direct manager via email or Slack. Manager approval timeout is 72 hours, after which the request is auto-escalated to the department head. Step 5: Once approved, deploy via SCCM (Windows) or Jamf (macOS). The deployment is queued and typically completes within 15-30 minutes. Step 6: Notify the user of installation completion and provide any first-launch instructions (license activation, sign-in URL, etc.). Record the deployment in the CMDB for license tracking.',
'1. Identify the requested software and check catalog (KB-3001)
2. Verify user department and role in Azure AD
3. Check license pool availability
4. If approved catalog + entitled + license available: deploy via SCCM/Intune
5. If requires manager approval: send approval request, wait for response (72h timeout)
6. On approval: create SCCM deployment targeted at user''s device
7. Notify user of deployment with ETA and first-launch instructions
8. Update CMDB with license assignment',
true, 'L2', ARRAY['sccm.deploy_software']);

INSERT INTO kb_articles (article_id, title, category, subcategory, content, resolution_steps, automation_eligible, automation_level, tools_required) VALUES
('KB-3003', 'Microsoft Office Update Failures', 'software', 'office_update',
'Microsoft Office (Microsoft 365 Apps) is configured for automatic updates through the Semi-Annual Enterprise Channel. Updates are managed centrally via Intune and should apply automatically. When updates fail, common causes include: (1) Disk space - Office updates require at least 3GB free space on the system drive. (2) Corrupted Office installation - run Office Quick Repair first (Control Panel > Programs > Microsoft 365 > Modify > Quick Repair). If Quick Repair fails, run Online Repair (requires internet, takes ~30 min). (3) Update service stuck - restart the Microsoft Office Click-to-Run Service (services.msc > ClickToRunSvc > Restart). (4) Network proxy blocking - some proxy configurations block Office CDN URLs. Test by connecting via VPN or a different network. (5) Version conflict - if the user has both MSI-based and Click-to-Run Office installed, they conflict. Remove the MSI version. Update logs are located at %localappdata%\\Microsoft\\Office\\Updates.',
'1. Check available disk space (need 3GB+ free on C: drive)
2. Run Quick Repair: Control Panel > Programs > Microsoft 365 > Modify > Quick Repair
3. If Quick Repair fails: run Online Repair (30 min, requires internet)
4. Restart Click-to-Run service: services.msc > ClickToRunSvc > Restart
5. Manually trigger update: Open any Office app > File > Account > Update Now
6. Check for proxy/firewall blocking Office CDN (officecdn.microsoft.com)
7. If persistent: collect update logs from %localappdata%\\Microsoft\\Office\\Updates and escalate',
false, 'L1', NULL);

INSERT INTO kb_articles (article_id, title, category, subcategory, content, resolution_steps, automation_eligible, automation_level, tools_required) VALUES
('KB-3004', 'Adobe Creative Cloud License Activation', 'software', 'adobe_license',
'Adobe Creative Cloud (CC) is licensed for the Marketing and Design departments only, with 25 named-user licenses. Activation requires the user to sign in with their company email at https://account.adobe.com. If the user sees "Your license has expired" or "This product is not licensed," the common causes are: (1) User''s email not added to the Adobe Admin Console - IT must add the user via admin.adobe.com > Users > Add User. (2) License pool exhausted - all 25 licenses assigned. Escalate to Marketing department head for approval of additional licenses ($600/user/year). (3) Wrong email - user trying to sign in with personal email instead of company email. (4) Cached license state - sign out of Adobe CC, clear credentials (Creative Cloud > Account > Sign Out), restart the app, and sign in again. (5) For new installs, deploy via Company Portal or SCCM. The Creative Cloud desktop app manages individual app installs from there.',
'1. Verify user is in Marketing or Design department (Azure AD group check)
2. Check Adobe Admin Console for license assignment (admin.adobe.com)
3. If not assigned: add user to Adobe Admin Console (requires available license)
4. If license pool exhausted: escalate to department head for budget approval
5. If already assigned but not working: user should sign out of Adobe CC, clear cached credentials, sign in again with company email
6. For new install: deploy Creative Cloud Desktop via SCCM, user installs individual apps from there',
false, 'L2', NULL);

-- Security (3 articles)

INSERT INTO kb_articles (article_id, title, category, subcategory, content, resolution_steps, automation_eligible, automation_level, tools_required) VALUES
('KB-4001', 'Phishing Email Reporting Procedure', 'security', 'phishing_report',
'Phishing remains the number one attack vector. All employees are trained to report suspicious emails immediately. CRITICAL: Do NOT click any links, do NOT download attachments, do NOT reply to the sender. To report: (1) In Outlook, use the "Report Phishing" button in the toolbar (installed by IT). This automatically forwards the email with full headers to the SecOps team. (2) If the button is unavailable, forward the email as an attachment (not inline) to security@company.com. Include "PHISHING REPORT" in the subject line. (3) If the user already clicked a link or entered credentials, this becomes a P1 security incident: the user should immediately change their password from a known-safe device, notify their manager, and IT will initiate the compromised account procedure (force password reset, revoke active sessions, check Azure AD sign-in logs for suspicious activity). SecOps responds to phishing reports within 15 minutes during business hours. They will analyze the email, check if other employees received the same email, and block the sender domain if confirmed malicious.',
'THIS IS A SECURITY INCIDENT - DO NOT AUTO-RESOLVE
1. IMMEDIATELY escalate to SecOps team (#secops channel or security@company.com)
2. Acknowledge the user: "Thank you for reporting this. Do NOT click any links or reply to the email."
3. If user clicked a link or entered credentials: escalate as P1 compromised account
4. SecOps will: analyze email headers, check for other recipients, block sender domain
5. Do NOT attempt to investigate or analyze the email yourself
6. Document: reporter name, time reported, email subject line, sender address',
false, 'L0', NULL);

INSERT INTO kb_articles (article_id, title, category, subcategory, content, resolution_steps, automation_eligible, automation_level, tools_required) VALUES
('KB-4002', 'Suspected Malware Infection', 'security', 'malware_report',
'If a user suspects their device is infected with malware (unexpected pop-ups, slow performance with high CPU/network usage, unfamiliar programs running, files encrypted/renamed, antivirus alerts), the response protocol is: (1) DISCONNECT from the network immediately - unplug ethernet cable and disable Wi-Fi. This prevents lateral movement and data exfiltration. (2) Do NOT attempt to clean the infection manually. Do NOT run third-party cleaning tools. Do NOT restart the device (this can destroy forensic evidence). (3) Contact IT Security immediately via phone (ext. 5555) or Slack #secops. (4) The incident response team will: remotely capture a forensic image of the device, analyze running processes and network connections, determine the scope of infection, and coordinate remediation. (5) The user will be issued a temporary loaner device while their device is being investigated. Investigation SLA is 4 hours for triage, 24 hours for full analysis. (6) If malware is confirmed, the incident response plan includes: blocking IOCs across the organization, scanning all endpoints for similar indicators, notifying affected users, and filing a regulatory report if data was exfiltrated.',
'THIS IS A SECURITY INCIDENT - DO NOT AUTO-RESOLVE
1. IMMEDIATELY escalate to SecOps/Incident Response (#secops or phone ext. 5555)
2. Instruct user: "DISCONNECT from network now (unplug ethernet, disable Wi-Fi). Do NOT restart. Do NOT try to clean it."
3. Do NOT attempt remote access to the potentially infected device
4. SecOps will handle: forensic imaging, investigation, remediation
5. Arrange temporary loaner device for the user if needed
6. Document: device ID, user name, symptoms described, time of first observation',
false, 'L0', NULL);

INSERT INTO kb_articles (article_id, title, category, subcategory, content, resolution_steps, automation_eligible, automation_level, tools_required) VALUES
('KB-4003', 'Data Loss Prevention Alert Response', 'security', 'dlp_alert',
'Data Loss Prevention (DLP) policies in Microsoft 365 monitor for sensitive data (PII, financial records, source code, confidential documents) being shared externally. When a DLP policy blocks an action, the user sees a notification explaining which policy was triggered. Common scenarios: (1) Email blocked - the email contains sensitive data (SSN, credit card numbers, medical records) being sent to an external recipient. User should review the content, redact or remove the sensitive data, and resend. (2) SharePoint/OneDrive sharing blocked - the file contains sensitive content and external sharing is restricted. User should check if the recipient is internal or if the data can be shared in a different format. (3) False positive - if the content is not actually sensitive (e.g., a test credit card number, or a document that has been declassified), the user can submit an exception request via the DLP notification with a business justification. Exception requests are reviewed by the Compliance team within 24 hours. Repeated DLP violations trigger a notification to the user''s manager and a compliance review.',
'1. Determine which DLP policy was triggered (check the user''s DLP notification)
2. If the content IS sensitive: help user redact/remove the sensitive data and retry
3. If the content is NOT sensitive (false positive): guide user to submit exception request via the DLP notification
4. Exception requests go to Compliance team (24-hour review SLA)
5. For repeated violations: escalate to user''s manager and Compliance for review
6. Do NOT override DLP policies - only Compliance admins can create exceptions',
false, 'L1', NULL);

-- Hardware & Other (3 articles)

INSERT INTO kb_articles (article_id, title, category, subcategory, content, resolution_steps, automation_eligible, automation_level, tools_required) VALUES
('KB-5001', 'Laptop Docking Station Issues', 'hardware', 'docking_station',
'The company standard docking stations are Dell WD19TBS (Thunderbolt) and Dell WD19S (USB-C). Common issues: (1) No display output - verify the laptop is connected to the docking station via Thunderbolt/USB-C (not USB-A). Check that monitors are powered on and set to the correct input. Try disconnecting and reconnecting the Thunderbolt cable. (2) Intermittent disconnects - the Dell WD19 series requires firmware version 1.08 or higher. Older firmware causes periodic disconnects especially with dual 4K monitors. Check firmware: open Dell Command Update on the laptop, or check the docking station firmware via Dell''s support page using the service tag. Update via Dell Command Update or download from Dell.com. (3) USB devices not recognized - try a different USB port on the dock. If no USB ports work, disconnect the dock from power for 30 seconds (hard reset), then reconnect. (4) Ethernet not working - verify the dock firmware (network issues often fixed in 1.06+ updates), check if the laptop has the Realtek USB-C Ethernet driver installed. (5) For MacBook users: Dell docks work with macOS but require DisplayLink driver for more than one external display.',
'1. Check connection: use Thunderbolt/USB-C port, not USB-A
2. Verify dock firmware version (Dell Command Update or Dell support page)
3. If firmware below 1.08: update via Dell Command Update
4. For no display: try different cable, check monitor input source
5. For intermittent disconnects: update firmware, try connecting only one monitor to test
6. For USB issues: hard reset dock (disconnect power 30 seconds)
7. For MacBook: install DisplayLink driver for multi-monitor support',
false, 'L1', NULL);

INSERT INTO kb_articles (article_id, title, category, subcategory, content, resolution_steps, automation_eligible, automation_level, tools_required) VALUES
('KB-5002', 'New Equipment Request', 'hardware', 'equipment_request',
'Equipment requests (laptops, monitors, peripherals, mobile devices) are submitted through the IT Equipment Portal at https://itportal.company.com/equipment. All requests require manager approval. Standard equipment is pre-configured and ships within 3-5 business days for US locations, 5-10 for international. Standard laptop options: Dell Latitude 5540 (general staff), Dell Latitude 7440 (management), MacBook Pro 14" M3 (Design/Engineering, requires VP approval). Standard monitors: Dell U2723QE (27" 4K). Peripherals: Logitech MX Keys keyboard, Logitech MX Master 3 mouse, Jabra Evolve2 85 headset. Non-standard equipment (gaming peripherals, standing desk converters, specialized hardware) requires IT Director approval and may have longer lead times. Equipment is asset-tagged and tracked in the CMDB. When an employee leaves or transfers, equipment must be returned to IT within 5 business days.',
'1. Direct user to IT Equipment Portal: https://itportal.company.com/equipment
2. Verify the request matches standard equipment catalog
3. For standard items: manager approval sufficient
4. For non-standard items: requires IT Director approval
5. MacBook Pro requests: requires VP approval
6. After approval: procurement creates PO, typical delivery 3-5 business days (US)
7. IT sets up and enrolls device in Intune before shipping to user',
false, 'L0', NULL);

INSERT INTO kb_articles (article_id, title, category, subcategory, content, resolution_steps, automation_eligible, automation_level, tools_required) VALUES
('KB-5003', 'Printer Connection Troubleshooting', 'hardware', 'printer_issue',
'Corporate printers are network printers managed through a print server. Printer names follow the format PRN-[Building]-[Floor]-[Number] (e.g., PRN-HQ1-3-02). Common issues: (1) Printer not found - verify the user is on the corporate network (VPN connected if remote, but printing over VPN is not supported - use local printer or print-to-PDF and print on-site later). Try adding the printer manually via Settings > Printers > Add Printer > search for the printer name. (2) Print jobs stuck in queue - open print queue (right-click printer > See what''s printing), cancel all documents, restart Print Spooler service (services.msc > Print Spooler > Restart). (3) Print quality issues - typically a hardware issue with the printer itself. Check toner levels via the printer''s web interface (http://[printer-IP]/status). Submit a facilities request for toner replacement or maintenance. (4) Secure Print not releasing - the company uses PaperCut for secure printing. User must tap their badge at the printer to release jobs. If badge not working, try entering the PaperCut PIN manually on the printer display.',
'1. Verify user is on corporate network (printing not supported over VPN)
2. Try adding printer manually: Settings > Printers > Add > search for printer name
3. For stuck jobs: clear print queue, restart Print Spooler service
4. For quality issues: check toner via printer web interface, submit facilities request
5. For Secure Print: ensure user has PaperCut account, try manual PIN entry
6. If printer is completely offline: check printer power/network cable, contact Facilities',
false, 'L1', NULL);


-- ============================================================
-- POLICY RULES (5 rules)
-- ============================================================

INSERT INTO policy_rules (intent, max_automation_level, requires_approval, approval_channel, confidence_threshold, tools_allowed, escalation_target, notes) VALUES
('password_reset', 'L3', false, NULL, 0.850, ARRAY['okta.verify_identity', 'azure_ad.reset_password'], '#tier2-support',
'Fully autonomous after identity verification. Highest volume, lowest risk. Agent verifies identity via Okta push, then resets password via Azure AD. No human approval needed.');

INSERT INTO policy_rules (intent, max_automation_level, requires_approval, approval_channel, confidence_threshold, tools_allowed, escalation_target, notes) VALUES
('account_unlock', 'L3', false, NULL, 0.850, ARRAY['okta.verify_identity', 'azure_ad.unlock_account'], '#tier2-support',
'Fully autonomous after identity verification. Account unlock is a safe, reversible operation. Agent verifies identity via Okta push, then unlocks via Azure AD.');

INSERT INTO policy_rules (intent, max_automation_level, requires_approval, approval_channel, confidence_threshold, tools_allowed, escalation_target, notes) VALUES
('vpn_troubleshoot', 'L2', true, '#agent-approvals', 0.800, ARRAY['cmdb.query_asset', 'sccm.deploy_software'], '#network-ops',
'Agent proposes fix, human approves before software deployment. VPN client updates require L1 approval because they trigger a reboot and have rollback implications.');

INSERT INTO policy_rules (intent, max_automation_level, requires_approval, approval_channel, confidence_threshold, tools_allowed, escalation_target, notes) VALUES
('software_install', 'L2', true, '#agent-approvals', 0.800, ARRAY['sccm.deploy_software'], '#tier2-support',
'Check entitlement + license availability. Manager approval required for department-restricted software. Agent does policy check and license verification before proposing deployment.');

INSERT INTO policy_rules (intent, max_automation_level, requires_approval, approval_channel, confidence_threshold, tools_allowed, escalation_target, notes) VALUES
('security_incident', 'L0', true, NULL, 0.000, ARRAY[]::TEXT[], '#secops',
'NEVER auto-resolve. Always escalate to SecOps with full context. No tool execution allowed. This applies to: phishing_report, malware_report, unauthorized_access, data_breach. The confidence threshold is 0.0 meaning any confidence level triggers escalation.');
