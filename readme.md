# neovim-flake

In this repo you can find my personal **nvim** dotfiles. The project uses nix
flakes, with the support of the **[nixvim](https://github.com/nix-community/nixvim/tree/main)** distribution.
This project utilizes **nixvim** to provide a streamlined Neovim experience. It
is designed to enhance your development workflow with a variety of features. 

![nvim screenshot](./screenshot.png)

## Features

- **Language Server Protocols** for several languages. This helps go from editor to IDE, with features like:
  - Code completion suggestions based on context and syntax.
  - Real-time error checking and linting as you type.
  - Intelligent code navigation, including go-to definition and find references.
  - Refactoring tools that simplify code modifications and improvements.
  - Hover documentation that provides quick access to function and variable descriptions.
  - Support for code formatting to maintain consistent style across projects.
- **Tree-sitter** integration: This provides advanced syntax highlighting and 
  parsing capabilities, enabling features such as accurate and context-aware 
  code highlighting and navigation.
- AI tools integration: *Copilot* and *ChatGPT*.
- All the advantages of nix and flakes. For example:
  - reproducibility
  - declarative configuration and dependencies
  - pinning of dependencies
- Snippets and completion:
  - Quick insertion of commonly used code patterns, reducing repetitive typing.


## Usage

If for some reason you want to run my nvim config you can execute the following
nix run command:

```bash
nix run github:haztecaso/neovim-flake
```

To access the package, you can include this flake as an input:

```nix
{
    inputs = {
        neovim-flake.url = "github:dc-tec/neovim-flake"
    };
}
```

Then add the following to your configuration:

```nix
environment.systemPackages = [
    inputs.nixvim.packages.x86_64-linux.default
];
```

## Reference

This configuration takes heavy inspiration from [redyf/Neve](https://github.com/redyf/Neve/tree/main).
