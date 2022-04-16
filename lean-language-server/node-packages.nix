# This file has been generated by node2nix 1.9.0. Do not edit!

{nodeEnv, fetchurl, fetchgit, nix-gitignore, stdenv, lib, globalBuildInputs ? []}:

let
  sources = {
    "@types/node-16.11.27" = {
      name = "_at_types_slash_node";
      packageName = "@types/node";
      version = "16.11.27";
      src = fetchurl {
        url = "https://registry.npmjs.org/@types/node/-/node-16.11.27.tgz";
        sha512 = "C1pD3kgLoZ56Uuy5lhfOxie4aZlA3UMGLX9rXteq4WitEZH6Rl80mwactt9QG0w0gLFlN/kLBTFnGXtDVWvWQw==";
      };
    };
    "@types/node-9.6.61" = {
      name = "_at_types_slash_node";
      packageName = "@types/node";
      version = "9.6.61";
      src = fetchurl {
        url = "https://registry.npmjs.org/@types/node/-/node-9.6.61.tgz";
        sha512 = "/aKAdg5c8n468cYLy2eQrcR5k6chlbNwZNGUj3TboyPa2hcO2QAJcfymlqPzMiRj8B6nYKXjzQz36minFE0RwQ==";
      };
    };
    "lean-client-js-core-3.0.0" = {
      name = "lean-client-js-core";
      packageName = "lean-client-js-core";
      version = "3.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/lean-client-js-core/-/lean-client-js-core-3.0.0.tgz";
        sha512 = "6CRq/lqN5lusK1TtYWMTigMMjswZ2scJT5HDVa9bb3p28iFVMHBFQxQnWytiBzV9AVGSjSikbYri3uwUW6qB0Q==";
      };
    };
    "lean-client-js-node-3.0.0" = {
      name = "lean-client-js-node";
      packageName = "lean-client-js-node";
      version = "3.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/lean-client-js-node/-/lean-client-js-node-3.0.0.tgz";
        sha512 = "VU3F/BhCTrpsk/8Jnm5vs9JWba64qN9Y5Z5ItHcdo8vSgo5VDaNz+7o0ZWGJw1Gc90XgCJtMi2iuFyW0CV+TJQ==";
      };
    };
    "vscode-jsonrpc-6.0.0" = {
      name = "vscode-jsonrpc";
      packageName = "vscode-jsonrpc";
      version = "6.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-jsonrpc/-/vscode-jsonrpc-6.0.0.tgz";
        sha512 = "wnJA4BnEjOSyFMvjZdpiOwhSq9uDoK8e/kpRJDTaMYzwlkrhG1fwDIZI94CLsLzlCK5cIbMMtFlJlfR57Lavmg==";
      };
    };
    "vscode-languageserver-7.0.0" = {
      name = "vscode-languageserver";
      packageName = "vscode-languageserver";
      version = "7.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver/-/vscode-languageserver-7.0.0.tgz";
        sha512 = "60HTx5ID+fLRcgdHfmz0LDZAXYEV68fzwG0JWwEPBode9NuMYTIxuYXPg4ngO8i8+Ou0lM7y6GzaYWbiDL0drw==";
      };
    };
    "vscode-languageserver-protocol-3.16.0" = {
      name = "vscode-languageserver-protocol";
      packageName = "vscode-languageserver-protocol";
      version = "3.16.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-protocol/-/vscode-languageserver-protocol-3.16.0.tgz";
        sha512 = "sdeUoAawceQdgIfTI+sdcwkiK2KU+2cbEYA0agzM2uqaUy2UpnnGHtWTHVEtS0ES4zHU0eMFRGN+oQgDxlD66A==";
      };
    };
    "vscode-languageserver-textdocument-1.0.4" = {
      name = "vscode-languageserver-textdocument";
      packageName = "vscode-languageserver-textdocument";
      version = "1.0.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-textdocument/-/vscode-languageserver-textdocument-1.0.4.tgz";
        sha512 = "/xhqXP/2A2RSs+J8JNXpiiNVvvNM0oTosNVmQnunlKvq9o4mupHOBAnnzH0lwIPKazXKvAKsVp1kr+H/K4lgoQ==";
      };
    };
    "vscode-languageserver-types-3.16.0" = {
      name = "vscode-languageserver-types";
      packageName = "vscode-languageserver-types";
      version = "3.16.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-types/-/vscode-languageserver-types-3.16.0.tgz";
        sha512 = "k8luDIWJWyenLc5ToFQQMaSrqCHiLwyKPHKPQZ5zz21vM+vIVUSvsRpcbiECH4WR88K2XZqc4ScRcZ7nk/jbeA==";
      };
    };
    "vscode-uri-3.0.3" = {
      name = "vscode-uri";
      packageName = "vscode-uri";
      version = "3.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-uri/-/vscode-uri-3.0.3.tgz";
        sha512 = "EcswR2S8bpR7fD0YPeS7r2xXExrScVMxg4MedACaWHEtx9ftCF/qHG1xGkolzTPcEmjTavCQgbVzHUIdTMzFGA==";
      };
    };
  };
in
{
  lean-language-server = nodeEnv.buildNodePackage {
    name = "lean-language-server";
    packageName = "lean-language-server";
    version = "3.1.1";
    src = fetchurl {
      url = "https://registry.npmjs.org/lean-language-server/-/lean-language-server-3.1.1.tgz";
      sha512 = "hC+1lj+9WdwQJlZqlmD/Aa+Wsj/xrirIpqDzupx+p8SOX2i0GAicmHqfMZlqO5RPGitq58Q1KMsRqGeDA6v1Ew==";
    };
    dependencies = [
      sources."@types/node-16.11.27"
      (sources."lean-client-js-core-3.0.0" // {
        dependencies = [
          sources."@types/node-9.6.61"
        ];
      })
      (sources."lean-client-js-node-3.0.0" // {
        dependencies = [
          sources."@types/node-9.6.61"
        ];
      })
      sources."vscode-jsonrpc-6.0.0"
      sources."vscode-languageserver-7.0.0"
      sources."vscode-languageserver-protocol-3.16.0"
      sources."vscode-languageserver-textdocument-1.0.4"
      sources."vscode-languageserver-types-3.16.0"
      sources."vscode-uri-3.0.3"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "Language Server Protocol server for Lean 3";
      homepage = "https://github.com/leanprover/lean-client-js#readme";
      license = "Apache-2.0";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };
}
