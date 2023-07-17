{pkgs, inputs, ... }:

{
	programs.vscode = {
		package = pkgs.unstable.vscodium;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    extensions = with pkgs.vscode-extensions; [
      catppuccin.catppuccin-vsc
      vscodevim.vim
      gruntfuggly.todo-tree
      ms-python.python
      ms-toolsai.jupyter
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.jupyter-renderers
      ms-toolsai.jupyter-keymap
    ];
    userSettings = builtins.fromJSON (builtins.readFile ../../dotfiles/.config/Code/User/settings.json);
	};
  

}
