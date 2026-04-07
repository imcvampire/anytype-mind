#!/usr/bin/env python3
"""Post-MCP-call validation for Anytype objects.

Checks that objects created or updated via MCP have required properties
and relations per the type schema.
"""
import json
import sys


REQUIRED_PROPERTIES = {
    "work_note": ["description", "status", "quarter"],
    "incident": ["description", "status", "quarter", "ticket", "severity", "incident_role"],
    "one_on_one": ["description", "quarter"],
    "decision": ["description", "status"],
    "person": ["description", "title"],
    "team": ["description"],
    "competency": ["description"],
    "pr_analysis": ["description", "related_person", "review_cycle"],
    "review_brief": ["description", "review_cycle"],
    "brain_note": ["description"],
    "brag_entry": ["description", "quarter"],
    "thinking_note": ["description"],
}


def main():
    try:
        input_data = json.load(sys.stdin)
    except (ValueError, EOFError, OSError):
        sys.exit(0)

    tool_name = input_data.get("tool_name", "")
    if not isinstance(tool_name, str):
        sys.exit(0)

    if "create" not in tool_name.lower() and "update" not in tool_name.lower():
        sys.exit(0)

    tool_input = input_data.get("tool_input")
    if not isinstance(tool_input, dict):
        sys.exit(0)

    warnings = []

    type_key = tool_input.get("type_key", "")
    properties = tool_input.get("properties", {})
    name = tool_input.get("name", "")
    description = tool_input.get("description", "") or properties.get("description", "")

    if not description and "create" in tool_name.lower():
        warnings.append("Missing `description` — every object needs a ~150 char description")

    if type_key in REQUIRED_PROPERTIES:
        for prop in REQUIRED_PROPERTIES[type_key]:
            if prop == "description":
                continue
            if prop not in properties and prop not in tool_input:
                warnings.append(f"Missing `{prop}` property for type `{type_key}`")

    if warnings:
        hint_list = "\n".join(f"  - {w}" for w in warnings)
        output = {
            "hookSpecificOutput": {
                "hookEventName": "PostToolUse",
                "additionalContext": f"Anytype object validation warnings for `{name or type_key}`:\n{hint_list}\nFix these before moving on."
            }
        }
        json.dump(output, sys.stdout)
        sys.stdout.flush()

    sys.exit(0)

if __name__ == "__main__":
    try:
        main()
    except Exception:
        sys.exit(0)
