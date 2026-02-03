# Neovim Flutter Development - Shortcuts Reference

## 🎯 Leader Key
**Leader Key**: `<Space>` (Spacebar)

---

## 📁 File & Navigation

### File Operations
- `<leader>w` - Save file
- `<leader>q` - Quit current buffer
- `<leader>Q` - Force quit all buffers

### File Explorer (NvimTree)
- `<leader>e` - Toggle file explorer

### Fuzzy Finding (Telescope)
- `<leader>ff` - Find files
- `<leader>fw` - Live grep (search text in files)
- `<leader>fb` - Browse open buffers
- `<leader>fh` - Search help tags

### Terminal
- `<leader>h` - Toggle terminal
- `<Esc>` - Exit terminal mode (in terminal)

---

## 🚀 Flutter Development

### Core Flutter Commands
- `<leader>fr` - Flutter Run
- `<leader>fq` - Flutter Quit
- `<leader>fd` - Flutter Devices (list available devices)
- `<leader>fl` - Toggle Flutter Log
- `<leader>fR` - Flutter Restart (hot restart)
- `<leader>R` - Flutter Hot Reload (quick reload)
- `<leader>fo` - Toggle Flutter Outline
- `<leader>ft` - Open Flutter Dev Tools
- `<leader>fc` - Clear Flutter Log

---

## 🎨 Code Snippets & Templates

### Widget Templates (Type and press Tab)
- `stless` - StatelessWidget template
- `stful` - StatefulWidget template
- `scaffold` - Scaffold with AppBar template
- `column` - Column widget template
- `row` - Row widget template
- `container` - Container with decoration template

### Snippet Navigation
- `<leader>ss` - Expand snippet or jump to next placeholder (Insert mode)
- `<leader>sl` - List available snippets
- `<Tab>` - Next completion item or snippet placeholder
- `<Shift-Tab>` - Previous completion item or snippet placeholder

---

## 🔍 LSP (Language Server Protocol)

### Code Navigation
- `K` - Show hover documentation
- `gd` - Go to definition
- `gr` - Go to references
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol

---

## ✏️ Code Completion

### Completion Controls
- `<Ctrl-Space>` - Trigger completion manually
- `<Ctrl-b>` - Scroll completion docs up
- `<Ctrl-f>` - Scroll completion docs down
- `<Ctrl-e>` - Abort completion
- `<Enter>` - Confirm completion selection
- `<Tab>` - Select next completion item
- `<Shift-Tab>` - Select previous completion item

---

## 🧭 Movement & Navigation

### Enhanced Scrolling
- `<Ctrl-d>` - Half page down (centered)
- `<Ctrl-u>` - Half page up (centered)
- `n` - Next search result (centered)
- `N` - Previous search result (centered)

### Text Objects (Treesitter)
- `af` - Select outer function
- `if` - Select inner function
- `ac` - Select outer class
- `ic` - Select inner class

---

## ✂️ Editing & Text Manipulation

### Line Movement (Visual mode)
- `J` - Move selected lines down
- `K` - Move selected lines up

### Comments
- `gcc` - Toggle comment on current line
- `gc` - Toggle comment (works with motions)
- `gco` - Insert comment below
- `gcO` - Insert comment above
- `gcA` - Insert comment at end of line

### Surround Operations (vim-surround)
- `ys{motion}{char}` - Add surrounding character
- `ds{char}` - Delete surrounding character
- `cs{old}{new}` - Change surrounding character

---

## 🎮 General Vim Navigation

### Basic Movement
- `h j k l` - Left, Down, Up, Right
- `w` - Next word
- `b` - Previous word
- `0` - Beginning of line
- `$` - End of line
- `gg` - Go to first line
- `G` - Go to last line

### Search
- `/` - Search forward
- `?` - Search backward
- `*` - Search for word under cursor
- `#` - Search backward for word under cursor

### Visual Mode
- `v` - Visual mode (character selection)
- `V` - Visual line mode
- `<Ctrl-v>` - Visual block mode

---

## 🎨 Interface Controls

### Window Management
- `<Ctrl-w>h` - Move to left window
- `<Ctrl-w>j` - Move to bottom window
- `<Ctrl-w>k` - Move to top window
- `<Ctrl-w>l` - Move to right window
- `<Ctrl-w>v` - Vertical split
- `<Ctrl-w>s` - Horizontal split

---

## 🔧 Configuration Features

### Auto-Features Enabled
- **Auto-completion** - Intelligent code completion
- **Syntax highlighting** - Enhanced with Treesitter
- **Auto-pairs** - Automatic bracket/quote pairing
- **Git integration** - Shows git changes in gutter
- **Indent guides** - Colorful indentation lines
- **Closing tags** - Shows closing widget tags in comments

### Color Scheme
- **Theme**: Eldritch (dark theme optimized for coding)
- **Icons**: Enabled with nvim-web-devicons
- **Statusline**: Lualine with theme integration

---

## 💡 Tips & Tricks

1. **Which-Key Menu**: Press `<Space>` and wait to see available commands
2. **Completion**: Start typing and completion will appear automatically
3. **Snippets**: Type template name and press Tab to expand
4. **Flutter Development**: Use `<leader>f` + key for all Flutter commands
5. **File Navigation**: Use `<leader>ff` to quickly find any file
6. **Terminal Integration**: Toggle terminal with `<leader>h` for quick commands

---

## 🚨 Emergency Commands

- `<Esc><Esc>` - Clear highlights and return to normal mode
- `:q!` - Force quit without saving
- `:w!` - Force save
- `u` - Undo
- `<Ctrl-r>` - Redo

---

*This configuration is optimized for Flutter/Dart development with enhanced productivity features.*