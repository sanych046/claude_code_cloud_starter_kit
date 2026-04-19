# ☁️ Claude Code + Ollama Cloud Bridge

This project enables a hybrid environment where **Ollama** runs in Docker (serving as a bridge to cloud LLMs) and **Claude Code** runs locally on your **Fedora** system. This setup allows you to leverage powerful cloud models without needing high-end local hardware.

---

## 🏗️ Architecture

- **Ollama (Docker Container):** Acts as a proxy server connecting to cloud models (e.g., MiniMax, DeepSeek, Gemma).
- **Claude Code (Host Machine):** The Anthropic CLI agent running directly on Fedora 42, providing full access to your terminal and project files.
- **Persistence:** All Ollama configurations and models are stored in the local `./ollama_data` directory.

---

## 🚀 Quick Start Guide

### Step 1: Infrastructure Setup (Docker)
Clone the repository and launch the management script:

```bash
git clone https://github.com/sanych046/claude_code_cloud_starter_kit.git
cd claude_code_cloud_starter_kit
chmod +x manage.sh
./manage.sh
```

**Action:** Select **Option 1 (Start)** from the menu to launch Ollama and initialize the `ollama_data` folder.

### Step 2: Ollama Cloud Authorization
To access cloud models for free, you must authorize your instance:

1. Run the login command:
   ```bash
   docker exec -it ollama-cloud-bridge ollama login
   ```
2. Copy the provided code, follow the link in your browser, and complete the authorization.
3. Once successful, your container can access models with the `:cloud` suffix.

### Step 3: Install Claude Code (Host)
Install the agent directly on your Fedora system to ensure it has proper file system access:

```bash
# Install Node.js (if not already present)
sudo dnf install nodejs

# Install Claude Code globally
npm install -g @anthropic-ai/claude-code
```

---

## 🛠️ Working with Models

Since the Ollama container acts as a server, you only need to "activate" a model once via the Docker CLI before using it in Claude Code.

### 1. Activating a Cloud Model
To download and run a cloud model, execute the following command in your terminal:

```bash
# Example: For Gemma 4 31B Cloud
docker exec -it ollama-cloud-bridge ollama run gemma4:31b-cloud
```

**Other available cloud models:**
- `glm-5.1:cloud`
- `qwen3-coder-next:cloud`
- `qwen3-next:80b-cloud`
- `qwen3.5:cloud`

*Once you see the `success` message, the model is ready. You can exit the Ollama chat with `Ctrl+D`; the model remains available via API.*

### 2. Configuring Claude Code
Now, launch Claude Code in your project directory and point it to the Ollama bridge:

```bash
# Start the agent
claude
```

Inside the Claude CLI, run these commands to switch the provider:
```bash
/status                      # Check current connection
/config set provider ollama   # Switch to Ollama provider
/config set model gemma4:31b-cloud  # Set the specific cloud model
```

---

## 💻 Project Workflow

1. **Navigate** to your project: 
   ```bash
   cd ~/my-projects/cool-app
   ```
2. **Start** the agent: 
   ```bash
   claude
   ```
3. **Configure** (if not automatic):
   ```bash
   /config set provider ollama
   /config set model minimax:cloud
   ```

**Pro Tip: One-liner launch**
You can also launch Claude with environment variables:
```bash
CLAUDE_CONFIG_SET_MODEL=gemma4:31b-cloud \
CLAUDE_CONFIG_SET_PROVIDER=ollama \
CLAUDE_CONFIG_SET_OLLAMA_URL=http://localhost:11434 \
ANTHROPIC_API_KEY=your_key_here \
claude
```

---

## 🕹️ Management (`manage.sh`)

The included `manage.sh` script simplifies container orchestration:

| Option | Command | Description |
| :--- | :--- | :--- |
| **1** | **Start** | Launches the container in the background and creates directories. |
| **2** | **Stop & Down** | Stops the container and clears models from RAM/VRAM. |
| **3** | **Status** | View current container status. |
| **4** | **Logs** | View the real-time logs of the service. |
| **5** | **Models List** | Lists all downloaded/available models in the container. |
| **6** | **Run Model** | Quick-select and launch a cloud model. |
| **7** | **Full Clean** | Deletes the container and the `ollama_data` folder for a fresh install. |

---

## 📋 Fedora 42 Implementation Notes

- **Permissions:** If Docker encounters permission issues, run the manager with:
  ```bash
  sudo ./manage.sh
  ```
- **Resource Management:** Always use the **Stop** option in `manage.sh` after finishing your session to free up system memory.
- **Firewall:** The bridge uses port `11434`. This is typically handled automatically by Docker for localhost, but ensure it's open if you encounter connection issues.
- **Alias:** For quicker access, add this to your `.bashrc`:
  ```bash
  alias ollama-mgr='~/path-to-repo/claude_code_cloud_starter_kit/manage.sh'
  ```

> **Note:** Using cloud models via the Ollama Cloud Bridge allows you to develop with state-of-the-art LLMs without requiring a powerful local GPU, as the heavy lifting is done on the provider's servers.