#!/bin/bash

find . -type f \( -iname "*.spcpu" -o -iname "*.spinc" \) -exec vim {} +
