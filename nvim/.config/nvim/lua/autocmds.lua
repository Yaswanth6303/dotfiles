require "nvchad.autocmds"

vim.filetype.add {
  filename = {
    ["BUILD"] = "bzl",
    ["BUILD.bazel"] = "bzl",
    ["WORKSPACE"] = "bzl",
    ["WORKSPACE.bazel"] = "bzl",
  },
  pattern = {
    [".*%.bzl"] = "bzl",
    [".*%.bazel"] = "bzl",
  },
}
