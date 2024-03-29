{ pkgs, ... }: {
  startPlugins = [
    (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: with p; [
      bash
      beancount
      bibtex
      c
      cmake
      comment
      cpp
      css
      cuda
      diff
      dockerfile
      fish
      glsl
      go
      graphql
      haskell
      hjson
      html
      http
      java
      javascript
      jq
      jsdoc
      json
      json5
      jsonc
      latex
      ledger
      llvm
      lua
      make
      markdown
      markdown_inline
      nix
      norg
      ocaml
      org
      pascal
      php
      phpdoc
      python
      ql
      regex
      ruby
      rust
      scala
      scheme
      scss
      sparql
      supercollider
      svelte
      todotxt
      toml
      tsx
      typescript
      vim
      vue
      yaml
    ]))
    pkgs.vimPlugins.nvim-treesitter-context
    pkgs.vimPlugins.nvim-treesitter-textobjects
    pkgs.vimPlugins.nvim-ts-autotag
  ];
}
