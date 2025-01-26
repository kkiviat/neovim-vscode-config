vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.keymap.set("i", "fd", "<Esc>", { noremap = true })
vim.keymap.set("i", "df", "<Esc>", { noremap = true })
vim.keymap.set("n", ";", ":", { noremap = true })
vim.keymap.set("n", "Y", "yy", { noremap = true })


local find_next_matching_line = function(start_line, pattern)
	-- returns first line starting from start_line that matches pattern
	local lines_after = vim.api.nvim_buf_get_lines(0, start_line, -1, false)
	for i, line in ipairs(lines_after) do
		if line:find(pattern) then
			return start_line + i - 1
		end
	end
	return -1
end
local find_previous_matching_line = function(start_line, pattern)
	-- returns first line starting from start_line going backwards that matches patternjj
	local lines_before = vim.api.nvim_buf_get_lines(0, 0, start_line + 1, true)
 	for i=1, #lines_before do
 		line = lines_before[#lines_before - i + 1] -- 1-based indexing
 		if line:find(pattern) then
 			return start_line - i + 1
 		end
 	end
	return -1
end


if vim.g.vscode then
local vscode = require('vscode')  
-- ========================
-- General
-- ========================

vim.keymap.set('n', "<leader>tl", function()
	vscode.call("workbench.action.toggleLightDarkThemes")
end)

vim.keymap.set('n', "<leader>ff", function()
	vscode.call("workbench.action.files.openFile")
end)
-- pane management
vim.keymap.set('n', "<leader>wh", function()
	vscode.call("workbench.action.splitEditorDown")
end)
vim.keymap.set('n', "<leader>wv", function()
	vscode.call("workbench.action.splitEditorRight")
end)
-- rename symbol
vim.keymap.set('n', "<leader>lr", function()
	vscode.call("editor.action.rename")
end)
-- show references
vim.keymap.set('n', "<leader>lx", function()
	vscode.call("editor.action.goToReferences")
end)
-- replace string in file
vim.keymap.set('n', "<leader>rf", function()
	vscode.call("editor.action.startFindReplaceAction")
end)
-- finding
vim.keymap.set('n', "<leader>sf", function()
	vscode.call("workbench.action.findInFiles")
end)

-- navigation
vim.keymap.set('n', "<leader>,", function()
	vscode.call("workbench.action.navigateBack")
end)
vim.keymap.set('n', "<leader>.", function()
	vscode.call("workbench.action.navigateForward")
end)
vim.keymap.set('n', "<leader>b", function()
	vscode.call("workbench.action.quickOpen")
end)
-- ========================
-- Matlab
-- ========================
vim.keymap.set('n', "<leader>mm", function()
	vscode.call("matlab.openCommandWindow")
end)
vim.keymap.set({'n', 'x'}, "<leader>mr", function()
	vscode.call("matlab.runSelection")
end)
vim.keymap.set({'n', 'x'}, "<leader>er", function()
	vscode.call("matlab.runSelection")
end)
vim.keymap.set('n', "<leader>mf", function()
	vscode.call("matlab.runFile")
end)

-- Run current line and return to editor and move to next line
local matlab_eval_line = function()
	local curr_line = vim.fn.line(".") - 1  -- 0-indexed
	vscode.call("matlab.runSelection", {
	   range = { curr_line, curr_line },
	})
	vscode.action("workbench.action.focusPreviousGroup")	
	vim.cmd('norm! j')
end
vim.keymap.set('n', "<leader>ml", matlab_eval_line )
vim.keymap.set('n', "<leader>el", matlab_eval_line )

-- execute current code cell delimited with %%
local matlab_find_cell = function()
	local curr_line = vim.fn.line(".") - 1  -- 0-indexed
	end_line = find_next_matching_line(curr_line + 1, '^%%%%')
	if end_line == -1 then
		end_line = vim.api.nvim_buf_line_count(0) - 1
	else
		end_line = end_line - 1 -- don't include the next cell start
	end
 	start_line = find_previous_matching_line(curr_line, '^%%%%')
	if start_line == -1 then start_line = 0 end
	return start_line, end_line
end
local matlab_run_cell = function()
	local start_line, end_line = matlab_find_cell()
	vscode.call("matlab.runSelection", {
	   range = { start_line, end_line },
	})
	vscode.action("workbench.action.focusPreviousGroup")	
end
vim.keymap.set('n', "<leader>mc", matlab_run_cell)
vim.keymap.set('n', "<leader>ec", matlab_run_cell)

-- navigate between code cells delimited with %%
local matlab_next_cell = function()
	local curr_line = vim.fn.line(".") - 1  -- 0-indexed
	next_line = find_next_matching_line(curr_line + 1, '^%%%%')
	if next_line == -1 then return end
	vim.cmd('norm! ' .. next_line + 1 .. 'G')
end
local matlab_previous_cell = function()
	local curr_line = vim.fn.line(".") - 1  -- 0-indexed
	previous_line = find_previous_matching_line(curr_line - 1, '^%%%%')
	if previous_line == -1 then return end
	vim.cmd('norm! ' .. previous_line + 1 .. 'G')
end
vim.keymap.set({ "n", "x", "i" }, "<M-p>", matlab_previous_cell)
vim.keymap.set({ "n", "x", "i" }, "<M-n>", matlab_next_cell)
end -- if vim.g.vscode
