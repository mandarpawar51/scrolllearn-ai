# Security Guidelines 🔐

## 🚨 CRITICAL - Never Commit These Files

**NEVER** commit files containing:
- API keys or secrets
- Personal information
- Database credentials
- Authentication tokens
- Private keys or certificates

## 📁 Files to NEVER Commit

```
# API Configuration Files
lib/config/api_keys.dart
lib/config/secrets.dart
.env
.env.local
.env.production

# Platform-specific service files
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
firebase_options.dart

# Any file with "secret", "key", or "credential" in the name
```

## ✅ Safe Development Practices

### 1. API Key Management
- Store API keys in app settings (FlutterSecureStorage)
- Never hardcode keys in source code
- Use environment variables for development
- Rotate keys regularly

### 2. Code Reviews
- Always review changes before committing
- Check for accidentally committed secrets
- Use tools like `git-secrets` to scan commits

### 3. Repository Settings
- Make repository private if it contains sensitive logic
- Enable branch protection rules
- Require pull request reviews

## 🛠️ Tools to Help

### Git Hooks (Recommended)
```bash
# Install git-secrets
brew install git-secrets  # macOS
# or download from: https://github.com/awslabs/git-secrets

# Configure for your repo
git secrets --register-aws
git secrets --install
```

### VS Code Extensions
- GitLens - Git supercharged
- Git History
- Thunder Client (for API testing)

## 🚨 If You Accidentally Commit Secrets

1. **Immediately rotate/revoke the exposed keys**
2. **Remove from git history**:
   ```bash
   git filter-branch --force --index-filter \
   'git rm --cached --ignore-unmatch path/to/secret/file' \
   --prune-empty --tag-name-filter cat -- --all
   ```
3. **Force push** (if safe to do so)
4. **Notify team members** to re-clone

## 📞 Reporting Security Issues

If you find a security vulnerability:
1. **DO NOT** open a public issue
2. Email: [your-email@example.com]
3. Include detailed description
4. Allow time for fix before disclosure

## 🔍 Security Checklist

Before each commit:
- [ ] No API keys in code
- [ ] No hardcoded URLs with credentials
- [ ] No personal information
- [ ] No database connection strings
- [ ] .gitignore is up to date
- [ ] Sensitive files are properly excluded

Remember: **Security is everyone's responsibility!** 🛡️