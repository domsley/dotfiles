local cmd = vim.api.nvim_command
local fn = vim.fn
local packer = nil

local function packer_verify()
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path })
    cmd 'packadd packer.nvim'
  end
end

local function packer_startup()
  if packer == nil then
    packer = require'packer'
    packer.init()
  end

  local use = packer.use
  packer.reset()

  -- Packer
  use 'wbthomason/packer.nvim'

  -- Language Servers
  use {
    'lspcontainers/lspcontainers.nvim',
    requires = {
      'neovim/nvim-lspconfig',
      'nvim-lua/lsp_extensions.nvim',
    },
    config = function ()
      require'Default.plugins.lsp'.init()
    end
  }

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = 'TSUpdate',
    config = function ()
      require'Default.plugins.treesitter'.init()
    end,
  }

  -- Completion
  use {
    'hrsh7th/nvim-compe',
    requires = {
      {
        'erkrnt/compe-tabnine',
        run = './install.sh'
      },
      'wellle/tmux-complete.vim',
      'L3MON4D3/LuaSnip',
      'onsails/lspkind-nvim'
    },
    config = function ()
      require'Default.plugins.compe'.init()
      require'Default.plugins.compe_tabnine'.init()
      require'Default.plugins.lspkind'.init()
    end
  }

  -- Telescope
  use 'nvim-lua/plenary.nvim'
  use 'nvim-lua/popup.nvim'
  use {
    'nvim-telescope/telescope.nvim',
    requires = 'rmagatti/session-lens',
    config = function ()
      require'Default.plugins.telescope'.init()
    end
  }

  -- Themes
  use 'folke/tokyonight.nvim'
  use {
    'cocopon/iceberg.vim',
    config = function ()
      require 'Default.plugins.theme'.init()
    end
  }

  -- Git Support
  use 'rhysd/git-messenger.vim'
  use {
    'lewis6991/gitsigns.nvim',
    config = function ()
      require'Default.plugins.gitsigns'.init()
    end
  }

  -- Sessions
  use {
    'rmagatti/auto-session',
    config = function ()
      require'Default.plugins.auto_session'.init()
    end
  }

  -- Utilities
  use {
    'lukas-reineke/indent-blankline.nvim',
    branch = 'lua'
  }
  use {
    'hoob3rt/lualine.nvim',
    config = function ()
      require 'Default.plugins.lualine'.init()
    end
  }
  use {
    'terrortylor/nvim-comment',
    config = function ()
      require 'Default.plugins.nvim_comment'.init()
    end
  }
  use 'romgrk/nvim-treesitter-context'
  use 'kyazdani42/nvim-web-devicons'
  use 'ThePrimeagen/vim-be-good'
  use 'posva/vim-vue'
  use {
    'voldikss/vim-floaterm',
    config = function ()
      require 'Default.plugins.floaterm'.init()
    end
  }
  use {
    'takac/vim-hardtime', -- see http://vimcasts.org/blog/2013/02/habit-breaking-habit-making
    config = function ()
      require'Default.plugins.hardtime'.init()
    end
  }

  use {
    'glepnir/dashboard-nvim',
    config = function()
      require 'Default.plugins.dashboard'.init()
    end
  }

  -- File Explorer
  use {
    'kyazdani42/nvim-tree.lua',
    config = function ()
      require 'Default.plugins.nvimtree'.init()
    end
  }

  -- VSCode like buffers
  use {
    'akinsho/nvim-bufferline.lua',
    config = function ()
      require 'Default.plugins.bufferline'.init()
    end
  }

  -- VimWiki + Zettelkasten
  use {
    'michal-h21/vim-zettel',
    requires = {
      {
        'junegunn/fzf',
        run = function () vim.fn['fzf#install']() end
      },
      'junegunn/fzf.vim',
      'vimwiki/vimwiki'
    },
    config = function ()
      require'Default.plugins.zettel'.init()
    end
  }
end

local function init()
  packer_verify()
  packer_startup()
end

return {
  init = init
}
