#!/usr/bin/env bash

# if env var SHELL=zsh, then run zsh else run bash
if [ "$SHELL" = "zsh" ]; then
  zsh
else
  bash
fi