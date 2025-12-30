# terraform-git-wrapper

A zero-config Terraform wrapper that automatically injects Git metadata as variables. The wrapper replaces `terraform` in your PATH, making it completely transparent to use.

## Installation

### One-Line Installer (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/<org>/tf-git/main/install.sh | bash
```

**Important:** After installation, make sure `~/.local/bin` is in your PATH. Add this to your `~/.bashrc` or `~/.zshrc`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

### Manual Installation

#### Step 1: Find and rename the real Terraform binary

```bash
# Find where terraform is installed
which terraform

# Example output: /usr/local/bin/terraform
# Rename it to terraform-real
sudo mv /usr/local/bin/terraform /usr/local/bin/terraform-real
```

#### Step 2: Install the wrapper

```bash
# Clone the repository
git clone https://github.com/<org>/tf-git.git
cd tf-git

# Install to ~/.local/bin
mkdir -p ~/.local/bin
cp terraform ~/.local/bin/terraform
chmod +x ~/.local/bin/terraform

# Make sure ~/.local/bin is in PATH
export PATH="$HOME/.local/bin:$PATH"
```

## Uninstallation

To remove the wrapper and optionally restore the original terraform:

```bash
curl -fsSL https://raw.githubusercontent.com/<org>/tf-git/main/uninstall.sh | bash
```

Or run manually:

```bash
./uninstall.sh
```

## Usage

### Basic Usage

Just use `terraform` as normal - the wrapper is completely transparent:

```bash
terraform apply
terraform plan
terraform destroy
# ... any terraform command
```

### Automatic Terraform Tagging (Optional)

If you want Terraform-native automatic tagging using provider `default_tags`:

1. **Run the init command:**
   ```bash
   tf-git init
   ```

2. **Review the generated file:**
   The command creates `tf-git.auto.tf` with:
   - Variable definitions for Git metadata
   - Provider block with `default_tags` configured

3. **Commit the generated file:**
   ```bash
   git add tf-git.auto.tf
   git commit -m "Enable tf-git Terraform tagging"
   ```

4. **Run Terraform as normal:**
   ```bash
   terraform apply
   ```

The generated file is:
- ✅ Safe to delete
- ✅ Clearly labeled as generated
- ✅ Only created on request
- ✅ Automatically detected by Terraform (`.auto.tf` files are loaded automatically)

**Provider Detection:** The init command automatically detects your cloud provider (AWS, Azure, or GCP) by scanning existing `.tf` files and generates the appropriate provider configuration.

## How It Works

When you run `terraform apply`, what actually happens is:

```
terraform (wrapper)
  → inject git vars
  → terraform-real apply
```

The wrapper automatically extracts Git metadata and exports it as Terraform variables:

- `TF_VAR_git_sha` - Current commit SHA
- `TF_VAR_git_branch` - Current branch name  
- `TF_VAR_git_repo` - Remote origin URL

Terraform is completely unaware of the wrapper.

## Terraform Configuration

### Option 1: Automatic Tagging (Recommended)

Run `tf-git init` to automatically generate `tf-git.auto.tf` with provider `default_tags`. This applies tags to all resources automatically.

### Option 2: Manual Configuration

If you prefer manual tagging, define the variables in your Terraform code:

```hcl
variable "git_sha" {
  type = string
  default = ""
}

variable "git_branch" {
  type = string
  default = ""
}

variable "git_repo" {
  type = string
  default = ""
}

locals {
  default_tags = {
    git_sha    = var.git_sha
    git_branch = var.git_branch
    git_repo   = var.git_repo
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "example"
  location = "westeurope"
  tags     = local.default_tags
}
```

## Requirements

- Git repository
- Terraform installed (will be renamed to `terraform-real`)
- Bash shell
