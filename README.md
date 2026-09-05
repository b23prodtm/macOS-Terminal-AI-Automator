**macOS Terminal AI Automator**

Bring AI and automation to your macOS Terminal.
	•	ai → Ask anything. Get quick answers without leaving your CLI.
	•	ag → Automate boring stuff like creating folders, batch renaming, compressing files, and more.

No more memorizing commands – just tell the AI what you need.

⸻

**Features**
	•	AI in your Terminal – Ask for commands, snippets, or explanations instantly.
	•	Automation on demand – One-liners to handle repetitive tasks.
	•	Lightweight & Fast – No extra setup beyond Python.

⸻

🛠 Requirements
	•	macOS
	•	Python 3.x
	•	Groq API Key (Free) → Get yours here
	•	Internet connection

⸻

**Install (Option A — Automated Setup Script)**

The fastest way to get going is the bundled setup script. From the repo root:

git clone https://github.com/b23prodtm/macOS-Terminal-AI-Automator.git
cd macOS-Terminal-AI-Automator
./scripts/setup.sh

`scripts/setup.sh` will:
	•	Verify Python 3 and a supported shell (zsh/bash) are available
	•	Install the required Python dependencies (`groq`, `rich`) via `pip3 install --user -r requirements.txt`
	•	Make `scripts/ai.py` and `scripts/ag.py` executable
	•	Add `ai` / `ag` aliases to your `~/.zshrc` or `~/.bash_profile`
	•	Optionally prompt you to save your `GROQ_API_KEY`

After it finishes, reload your shell (`source ~/.zshrc`) and you're ready to go.

⸻

**Install (Option B — macOS .pkg Installer)**

Prefer a native installer? Build and install a `.pkg` package:

# Build the package (must be run on macOS)
./pkg/build_pkg.sh

# Install it (double-click the .pkg in Finder, or from the terminal)
sudo installer -pkg dist/macos-terminal-ai-automator-1.0.0.pkg -target /

The `.pkg` installs:
	•	`ai.py` / `ag.py` → `/usr/local/lib/macos-terminal-ai-automator/`
	•	`ai` / `ag` launcher commands → `/usr/local/bin/`
	•	A postinstall script that installs the Python dependencies (`groq`, `rich`) for you

Since `/usr/local/bin` is on the default macOS `PATH`, you can immediately run `ai` and `ag` from any terminal after installation — no aliases needed. You'll still need to set your `GROQ_API_KEY` (see below).

⸻

🔑 Setting Up Groq API Key

To use the AI features, you need a Groq API key:
	Sign up and get your API key → [Groq Console](https://console.groq.com/keys)
	Open your shell config file:

nano ~/.zshrc


	Add this line (replace YOUR_KEY with your actual key):

export GROQ_API_KEY="YOUR_KEY"


	Save and reload your shell:

source ~/.zshrc



✅ Now the scripts can access your API key automatically.

⸻

**Usage**

Once installed (via either option above), just run:

ai "how do I kill a process by name?"
ag "create 10 folders in Documents with a .txt file inside each"

Or, without installing, you can always run the scripts directly with Python:

python3 scripts/ai.py "how do I kill a process by name?"
python3 scripts/ag.py "create 10 folders in Documents with a .txt file inside each"


⸻

 **Make It Easier (Add Shortcuts Manually)**

If you installed via the `.pkg` (Option B) or ran `scripts/setup.sh` (Option A), `ai` and `ag` are already set up — you can skip this section.

If you'd rather configure shortcuts by hand, add these lines to your ~/.zshrc:

alias ai="python /absolute/path/to/macos-terminal-ai-automator/scripts/ai.py"
alias ag="python /absolute/path/to/macos-terminal-ai-automator/scripts/ag.py"

Reload your shell:

source ~/.zshrc

 Now just type:

ai "what's the command to check disk space?"
ag "compress all PDFs in Documents"


⸻

**Example Use Cases**

ai "Give me a Python script to batch rename files"
ai "Show me how to list files sorted by size"

ag "Create 5 folders in Desktop and put a text file in each"
ag "Zip all images in Pictures"


⸻

When Prompted

Sometimes the tool will ask:

So... what now? Run it? Edit it? Skip it?
👉

Here’s what to type:
	•	run → Executes immediately (also works with: execute, go, send)
	•	edit → Opens file in editor (works with: open, fix)
	•	skip → Does nothing, just saves file (works with: nah, no)

⸻
