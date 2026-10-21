return {
	cmd = { "vscode-eslint-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_markers = {
		{
			"eslint.config.js",
			"eslint.config.mjs",
			"eslint.config.cjs",
			"eslint.config.ts",
			"eslint.config.mts",
			"eslint.config.cts",
			".eslintrc",
			".eslintrc.js",
			".eslintrc.cjs",
			".eslintrc.json",
			".eslintrc.yaml",
			".eslintrc.yml",
		},
		"package.json",
		".git",
	},
	workspace_required = true,
	settings = {
		validate = "on",
		run = "onType",
		-- Prettier handles formatting; ESLint fixes stay explicit code actions.
		format = false,
		codeActionOnSave = { enable = false, mode = "all" },
		workingDirectory = { mode = "auto" },
		nodePath = "",
		quiet = false,
		onIgnoredFiles = "off",
		rulesCustomizations = {},
		problems = { shortenToSingleLine = false },
		codeAction = {
			disableRuleComment = { enable = true, location = "separateLine" },
			showDocumentation = { enable = true },
		},
	},
	before_init = function(_, config)
		config.settings.workspaceFolder = {
			uri = vim.uri_from_fname(config.root_dir),
			name = vim.fn.fnamemodify(config.root_dir, ":t"),
		}
	end,
	handlers = {
		["eslint/openDoc"] = function(_, result)
			if result then
				vim.ui.open(result.url)
			end
			return {}
		end,
		["eslint/confirmESLintExecution"] = function()
			return 4 -- Allow the project's ESLint library to run.
		end,
		["eslint/probeFailed"] = function()
			return {}
		end,
		["eslint/noLibrary"] = function()
			vim.notify("ESLint: install eslint in the project to enable linting", vim.log.levels.WARN)
			return {}
		end,
	},
}
