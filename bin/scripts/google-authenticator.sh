#!/bin/sh

google-authenticator --time-based --disallow-reuse --force --rate-limit=3 --rate-time=30 --minimal-window
