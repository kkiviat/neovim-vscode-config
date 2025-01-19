This is my neovim config for use with the [vscode-neovim](https://github.com/vscode-neovim/vscode-neovim) extension and the [vscode MATLAB](https://github.com/mathworks/MATLAB-extension-for-vscode) extension. It defines some functions and keybindings to add support for executing individual lines and code cells in a MATLAB file, as well as shortcuts to navigate between code cells with `<M-n>` and `<M-p>`.

Note: To use the `<M-n>` and `<M-p>` keybindings, you have to set up a passthrough in VSCode by adding the following to your `keybindings.json`:
```
{
    {
        "command": "vscode-neovim.send",
        "key": "alt+p",
        "args": "<M-p>",
    } ,
    {
        "command": "vscode-neovim.send",
        "key": "alt+n",
        "args": "<M-n>",
    },
}
```
