# Markdown-preview

This plugin allows you to have a preview in PDF of a readme file being edit from Neovim


## Dependencies
In order to work the conversion from markdown to pdf it uses [Pandoc](https://pandoc.org/) to convert to pdf it uses `pdflatex` check the needed libraries in your distro repositories
To display de PDF uses [Zathura](https://pwmt.org/projects/zathura/)

## Install

Using lazy
```lua
return {
  "adalessa/markdown-preview.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = true,
  ft = "markdown",
}
```
# How
This plugin provides 2 commands `MarkdownPreviewStart` and `MarkdownPreviewStop`

If you take a look into the file `lua/markdown-preview/init.lua` it exposes 3 methods
`start`, `stop` and `setup`

The `steup` function takes care of registering the user commands and allow the easy execution of the plugin.

The `start` function generates a new temporary file which will be use to convert the file to and will be read by `Zathura`. The start also registers an auto-command which every time you save the file will trigger the conversion again.
Also it stores the id of the auto-command so when the `stop` function is call can delete the auto-command for the respective buffer

One note of the process the `Zathura` window is up to you to manually close it, it will not be automatically closed when the `stop` is executed.
If you close the window but does not run the `stop` the conversion will be still be happening in the background.

To avoid blocks after save I use `plenary` async jobs which allow to run the conversion in this case and not stop the user to interact with the editor.

# Self Promotion
I run the Youtube channel [Alpha Developer](https://youtube.com/@Alpha_Dev) which I create content in Spanish and also live-stream.
