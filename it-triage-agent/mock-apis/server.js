const express = require('express');
const app = express();
app.use(express.json());

// ============================================================
// MOCK TOOL ENDPOINTS
// These simulate real enterprise APIs. In production, these
// would be replaced with actual Azure AD, Okta, SCCM calls.
// ============================================================

// Password Reset
app.post('/api/tools/azure_ad/reset_password', (req, res) => {
  const { user_id, user_email } = req.body;
  setTimeout(() => {
    res.json({
      success: true,
      tool: 'azure_ad.reset_password',
      action: 'password_reset',
      user_id,
      temp_password_sent: true,
      delivery_method: 'secure_email',
      expires_in: '24_hours',
      message: `Password reset for ${user_email || user_id}. Temporary password sent via secure channel.`,
      timestamp: new Date().toISOString(),
      _mock: true,
      _note: 'MOCK API - In production, this calls Microsoft Graph API with Password Admin service principal'
    });
  }, 800);
});

// Account Unlock
app.post('/api/tools/azure_ad/unlock_account', (req, res) => {
  const { user_id } = req.body;
  setTimeout(() => {
    res.json({
      success: true,
      tool: 'azure_ad.unlock_account',
      action: 'account_unlock',
      user_id,
      was_locked: true,
      failed_attempts: 5,
      lockout_duration_remaining: '18 minutes',
      message: `Account unlocked for ${user_id}. Previous lockout due to 5 failed login attempts.`,
      timestamp: new Date().toISOString(),
      _mock: true,
      _note: 'MOCK API - In production, calls Microsoft Graph API'
    });
  }, 600);
});

// Identity Verification (Okta)
app.post('/api/tools/okta/verify_identity', (req, res) => {
  const { user_id } = req.body;
  setTimeout(() => {
    res.json({
      success: true,
      tool: 'okta.verify_identity',
      action: 'identity_verification',
      user_id,
      method: 'push_notification',
      verified: true,
      factor: 'Okta Verify (push)',
      message: `Identity verified for ${user_id} via Okta Verify push notification.`,
      timestamp: new Date().toISOString(),
      _mock: true,
      _note: 'MOCK API - In production, sends real Okta Verify push and waits for user response'
    });
  }, 1200);
});

// CMDB Asset Query
app.post('/api/tools/cmdb/query_asset', (req, res) => {
  const { user_id } = req.body;
  res.json({
    success: true,
    tool: 'cmdb.query_asset',
    user_id,
    assets: [{
      asset_id: 'LAPTOP-8847',
      type: 'Laptop',
      model: 'Dell Latitude 5540',
      os: 'Windows 11 Enterprise 23H2',
      vpn_client: 'Cisco AnyConnect 4.10.07062',
      last_seen: new Date(Date.now() - 3600000).toISOString(),
      department: 'Engineering',
      location: 'Remote'
    }],
    timestamp: new Date().toISOString(),
    _mock: true
  });
});

// Software Deployment
app.post('/api/tools/sccm/deploy_software', (req, res) => {
  const { user_id, software_name, device_id } = req.body;
  setTimeout(() => {
    res.json({
      success: true,
      tool: 'sccm.deploy_software',
      action: 'software_deployment',
      deployment_id: `DEP-${Date.now()}`,
      software: software_name || 'Cisco AnyConnect 4.10.08029',
      target_device: device_id || 'LAPTOP-8847',
      status: 'queued',
      estimated_completion: '15 minutes',
      message: `Deployment of ${software_name || 'software'} queued for ${device_id || 'device'}. ETA: 15 minutes.`,
      timestamp: new Date().toISOString(),
      _mock: true,
      _note: 'MOCK API - In production, triggers SCCM/Intune deployment'
    });
  }, 500);
});

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'healthy', mock_apis: true, version: '1.0.0' });
});

// List available tools
app.get('/api/tools', (req, res) => {
  res.json({
    tools: [
      { name: 'azure_ad.reset_password', method: 'POST', path: '/api/tools/azure_ad/reset_password', risk: 'low' },
      { name: 'azure_ad.unlock_account', method: 'POST', path: '/api/tools/azure_ad/unlock_account', risk: 'low' },
      { name: 'okta.verify_identity', method: 'POST', path: '/api/tools/okta/verify_identity', risk: 'low' },
      { name: 'cmdb.query_asset', method: 'POST', path: '/api/tools/cmdb/query_asset', risk: 'low' },
      { name: 'sccm.deploy_software', method: 'POST', path: '/api/tools/sccm/deploy_software', risk: 'medium' }
    ]
  });
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`Mock IT Tools API running on port ${PORT}`);
  console.log('Available endpoints:');
  console.log('  POST /api/tools/azure_ad/reset_password');
  console.log('  POST /api/tools/azure_ad/unlock_account');
  console.log('  POST /api/tools/okta/verify_identity');
  console.log('  POST /api/tools/cmdb/query_asset');
  console.log('  POST /api/tools/sccm/deploy_software');
  console.log('  GET  /api/health');
  console.log('  GET  /api/tools');
});
