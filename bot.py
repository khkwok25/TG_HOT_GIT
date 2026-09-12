"""Backward-compatible entry point; the implementation lives in github_bot.py."""

from github_bot import push_github_highlights
import asyncio


if __name__ == "__main__":
    asyncio.run(push_github_highlights())