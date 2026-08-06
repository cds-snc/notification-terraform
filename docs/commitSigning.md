# Commit Signing. yes

We are enforcing signed commits across CDS Notify repositories. A signed commit lets GitHub cryptographically verify it really came from you, shown as the green **Verified** badge on commits/PRs.

Reference docs from GitHub:
- [About commit signature verification](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification)
- [Signing commits with SSH keys](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits-with-ssh-keys)
- [Signing commits with GPG keys](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits)

> ℹ️ **You already have an SSH key.** Everyone signs into GitHub via SSO using an SSH key for git auth already. Signing commits with that same key is the fastest path - GitHub just needs you to also register it as a **Signing Key** (separate from the **Authentication Key** use you already have). You do **not** need to generate a new key pair for this.

> ⭐ **SSH is the preferred signing method for CDS Notify repos.** It reuses the key you already have, has no agent/`pinentry` headaches, and is what the [Set up SSH signing](#scenario-a-set-up-ssh-signing) scenario below walks you through. GPG still works and is fully supported, but if you're choosing a method or want to simplify, choose SSH.

## Which scenario are you in?

Run this once to find out:

```bash
git config --get commit.gpgsign
git config --get gpg.format
```

| `commit.gpgsign` | `gpg.format` | Scenario | What to do |
|---|---|---|---|
| blank | blank | **A - Not signing at all** | Jump to [Set up SSH signing](#scenario-a-set-up-ssh-signing) (recommended) |
| `true` | blank or `openpgp` | **B - Already signing with GPG** | Jump to [Check your GPG setup](#scenario-b-check-your-gpg-setup) |
| `true` | `ssh` | **C - Already signing with SSH** | Jump to [Verify your SSH setup](#scenario-c-verify-your-ssh-setup) |

## Scenario A: Set up SSH signing

**✅ Recommended.** You're not signing commits yet. Since you already have an SSH key for GitHub, reuse it - no GPG required.

### Step 1: Add your SSH key to GitHub as a signing key

GitHub separates *Authentication* and *Signing* permissions. You need to add your existing public key to GitHub under the **Signing Key** type.

1. Copy your local public SSH key to your clipboard:
   ```bash
   pbcopy < ~/.ssh/id_ed25519.pub
   ```
   *(If using an RSA key, replace with `~/.ssh/id_rsa.pub`)*
2. Go to **GitHub.com → Settings → SSH and GPG keys**.
3. Click **New SSH Key**.
4. Set **Title** to something identifiable (e.g., `MacBook (Signing)`).
5. Change the **Key type** dropdown from *Authentication Key* to **Signing Key**.
6. Paste your key in the **Key** field and click **Add SSH key**.
7. *(If applicable)* Click **Configure SSO / Authorize** next to the new key to authorize it for your organization.

### Step 2: Configure Git locally to auto-sign commits

Run these three commands in Terminal to tell Git to use your SSH key for signing:

```bash
# 1. Set Git signature format to SSH
git config --global gpg.format ssh

# 2. Point Git to your public SSH key
git config --global user.signingkey ~/.ssh/id_ed25519.pub

# 3. Enable automatic commit signing globally
git config --global commit.gpgsign true
```

### Step 3: Set up local signature verification

This prevents Git from throwing `gpg.ssh.allowedSignersFile needs to be configured` when checking local commit logs.

1. Create an allowed signers file with your Git email and public SSH key:
   ```bash
   echo "$(git config user.email) $(cat ~/.ssh/id_ed25519.pub)" >> ~/.ssh/allowed_signers
   ```
2. Tell Git where to look for allowed signers:
   ```bash
   git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers
   ```

### ⚡ One-liner quick fix

If you've already added the signing key to GitHub and just need to configure a local Mac in one go, paste this into Terminal:

```bash
git config --global gpg.format ssh && \
git config --global user.signingkey ~/.ssh/id_ed25519.pub && \
git config --global commit.gpgsign true && \
echo "$(git config user.email) $(cat ~/.ssh/id_ed25519.pub)" >> ~/.ssh/allowed_signers && \
git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers
```

Then jump to [Test your setup](#test-your-setup) below.

## Scenario B: Check your GPG setup

You're already configured for GPG signing. Run this quick diagnostic before deciding whether to keep it.

**1. Test GPG agent and passphrase prompt**
```bash
echo "test" | gpg --clearsign
```
* **Pass:** Outputs `-----BEGIN PGP SIGNED MESSAGE-----` (or prompts for your passphrase cleanly).
* **Fail:** Throws `gpg: signing failed: Inappropriate ioctl for device` or `no pinentry`.

**2. Verify Git is configured to auto-sign**
```bash
git config --get commit.gpgsign
git config --get user.signingkey
```
* **Pass:** `commit.gpgsign` returns `true` and `user.signingkey` returns a key ID (e.g., `3AA5C34371567BD2`).
* **Fail:** Either command returns blank.

**3. Test an actual signed commit locally**
```bash
git commit --allow-empty -m "test gpg signature"
git log -1 --show-signature
```
* **Pass:** Output shows `gpg: Good signature from...`
* **Fail:** Output shows `gpg: double check your gpg installation` or no signature info.

> **Verdict**
> * **All 3 passed?** Your GPG setup works, but SSH is still the preferred method for this org - see [switching to SSH](#want-to-switch-from-gpg-to-ssh) below, or continue to the GitHub check if you'd rather stick with GPG.
> * **Any failed?** Don't bother troubleshooting `gpg-agent` or `pinentry` - just switch to **SSH signing**, it takes under 2 minutes and reuses the SSH key you already have. See [switching to SSH](#want-to-switch-from-gpg-to-ssh) below.

### Want to switch from GPG to SSH?

Switching takes under 2 minutes and doesn't require removing your GPG key from GitHub - just follow [Scenario A](#scenario-a-set-up-ssh-signing) above. Once `gpg.format` is set to `ssh`, Git will sign new commits with your SSH key instead, regardless of any GPG key still on file.

### Make sure GitHub actually has your GPG public key

A valid local signature is not enough - GitHub only shows **Verified** if it already has the matching public key. This is the step people most often miss.

1. List your local GPG key ID (matches `user.signingkey` from above):
   ```bash
   gpg --list-secret-keys --keyid-format=long
   ```
2. Check what GitHub already has on file: go to **GitHub.com → Settings → SSH and GPG keys** and look under **GPG keys**.
3. If your key ID isn't listed there, export and add it:
   ```bash
   gpg --armor --export <YOUR_KEY_ID>
   ```
   Copy the full `-----BEGIN PGP PUBLIC KEY BLOCK-----` output, then in GitHub click **New GPG key** and paste it in.

Then continue to [Test your setup](#test-your-setup).

## Scenario C: Verify your SSH setup

You're already using the recommended method (`gpg.format = ssh`) locally. The part people miss here is confirming the key is registered on GitHub specifically as a **Signing Key**, not just an **Authentication Key** - it's easy to have one without the other.

1. Check which SSH signing keys GitHub already has on file for you:
   ```bash
   gh api user/ssh_signing_keys -q '.[].title'
   ```
   If this comes back empty, GitHub has no signing key for you yet, even if you use SSH to push/pull every day.
2. If your key isn't listed, add it: copy your public key (`pbcopy < ~/.ssh/id_ed25519.pub`), go to **GitHub.com → Settings → SSH and GPG keys → New SSH key**, and set **Key type** to **Signing Key** (see [Scenario A, Step 1](#step-1-add-your-ssh-key-to-github-as-a-signing-key) for the full walkthrough).

Then continue to [Test your setup](#test-your-setup) below.

## Test your setup

Run an empty test commit locally:

```bash
git commit --allow-empty -m "test signed commit"
git log -1 --show-signature
```

* **Local check:** Output should say `Good "git" signature for...` (SSH) or `gpg: Good signature from...` (GPG).
* **GitHub check:** Push the commit to GitHub. Your commit log on GitHub.com will now show the green **Verified** badge.

Delete the test commit/branch once confirmed.

## Repo enforcement

Once your team has confirmed their local setup works, repo admins can enforce this at the branch level: **Settings → Branches → Branch protection rule → Require signed commits**. This rejects any unsigned push outright instead of relying on after-the-fact audits.
