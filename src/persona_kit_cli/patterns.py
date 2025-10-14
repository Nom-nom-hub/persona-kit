#!/usr/bin/env python3
"""
Patterns command module for Persona Kit CLI.

This module handles the /persona-kit.patterns workflow for managing
communication and decision-making patterns.
"""

import os
import json
from pathlib import Path
from typing import Optional, Dict, Any, List

import typer
from rich.console import Console
from rich.panel import Panel
from rich.prompt import Prompt, Confirm
from rich.table import Table
from rich.text import Text

console = Console()

app = typer.Typer(
    name="patterns",
    help="Manage communication and decision-making patterns",
    add_completion=False,
)

class PatternManager:
    """Handles pattern management for projects."""

    def __init__(self, project_path: Path):
        self.project_path = Path(project_path)
        self.patterns_dir = self.project_path / "persona-kit" / "patterns"
        self.patterns_config = self.patterns_dir / "patterns.json"

    def ensure_project_structure(self) -> bool:
        """Ensure the project structure exists."""
        try:
            self.patterns_dir.mkdir(parents=True, exist_ok=True)
            return True
        except Exception as e:
            console.print(f"[red]Error creating project structure:[/red] {e}")
            return False

    def load_patterns_config(self) -> Dict[str, Any]:
        """Load existing patterns configuration."""
        if not self.patterns_config.exists():
            return {"patterns": {}, "version": "1.0"}

        try:
            with open(self.patterns_config, 'r', encoding='utf-8') as f:
                return json.load(f)
        except Exception as e:
            console.print(f"[yellow]Warning: Could not load patterns config:[/yellow] {e}")
            return {"patterns": {}, "version": "1.0"}

    def save_patterns_config(self, config: Dict[str, Any]) -> bool:
        """Save patterns configuration."""
        try:
            with open(self.patterns_config, 'w', encoding='utf-8') as f:
                json.dump(config, f, indent=2, ensure_ascii=False)
            return True
        except Exception as e:
            console.print(f"[red]Error saving patterns config:[/red] {e}")
            return False

    def list_available_pattern_types(self) -> List[str]:
        """List available pattern categories."""
        return [
            "communication",
            "decision-making",
            "feedback-loops",
            "conflict-resolution"
        ]

    def list_available_communication_patterns(self) -> List[str]:
        """List available communication pattern types."""
        return [
            "stakeholder-presentation",
            "structured-update",
            "daily-standup",
            "technical-documentation",
            "meeting-facilitation"
        ]

    def list_available_decision_patterns(self) -> List[str]:
        """List available decision-making pattern types."""
        return [
            "technical-architecture-decision",
            "feature-prioritization",
            "trade-off-decision",
            "risk-assessment",
            "resource-allocation"
        ]

    def create_pattern_interactive(self, category: str, pattern_type: str) -> Optional[Dict[str, Any]]:
        """Create a pattern through interactive prompts."""
        console.print(f"\n[bold cyan]Creating {category}/{pattern_type} pattern[/bold cyan]")

        # Basic information
        name = Prompt.ask("Pattern name/title")
        description = Prompt.ask("Brief description of this pattern")

        # When to use
        console.print("\n[bold]When to Use[/bold]")
        when_to_use = Prompt.ask("When should this pattern be applied?")

        # How to apply
        console.print("\n[bold]How to Apply[/bold]")
        how_to_apply = Prompt.ask("How should this pattern be implemented?")

        # Expected outcomes
        console.print("\n[bold]Expected Outcomes[/bold]")
        expected_outcomes = Prompt.ask("What results should this pattern produce?")

        # Examples
        console.print("\n[bold]Examples[/bold]")
        examples = Prompt.ask("Provide examples of this pattern in use")

        # Create pattern object
        pattern = {
            "category": category,
            "type": pattern_type,
            "name": name,
            "description": description,
            "when_to_use": when_to_use,
            "how_to_apply": how_to_apply,
            "expected_outcomes": expected_outcomes,
            "examples": examples,
            "created_at": str(Path.cwd()),  # Could use datetime
            "version": "1.0"
        }

        return pattern

    def save_pattern_file(self, pattern: Dict[str, Any]) -> bool:
        """Save individual pattern to markdown file."""
        category = pattern["category"]
        pattern_type = pattern["type"]
        filename = f"{pattern_type}.md"
        file_path = self.patterns_dir / category / filename

        # Ensure category directory exists
        file_path.parent.mkdir(parents=True, exist_ok=True)

        # Generate markdown content
        content = f"""# {pattern['name']}

**Category:** {category}
**Type:** {pattern_type}
**Description:** {pattern['description']}

## When to Use

{pattern['when_to_use']}

## How to Apply

{pattern['how_to_apply']}

## Expected Outcomes

{pattern['expected_outcomes']}

## Examples

{pattern['examples']}

## Usage Guidelines

When applying this pattern:
- Consider the context and ensure it matches "When to Use" criteria
- Follow the "How to Apply" steps carefully
- Monitor for the expected outcomes
- Adjust as needed based on team feedback

---
*Generated by Persona Kit CLI*
"""

        try:
            file_path.write_text(content, encoding='utf-8')
            return True
        except Exception as e:
            console.print(f"[red]Error saving pattern file:[/red] {e}")
            return False

    def list_patterns(self) -> None:
        """List all existing patterns."""
        config = self.load_patterns_config()

        if not config["patterns"]:
            console.print("[yellow]No patterns configured yet.[/yellow]")
            console.print("Use 'persona-kit patterns create' to add patterns.")
            return

        # Group patterns by category
        patterns_by_category = {}
        for pattern_key, pattern_data in config["patterns"].items():
            category = pattern_data.get("category", "uncategorized")
            if category not in patterns_by_category:
                patterns_by_category[category] = []
            patterns_by_category[category].append((pattern_key, pattern_data))

        for category, patterns in patterns_by_category.items():
            console.print(f"\n[bold cyan]{category.title()} Patterns[/bold cyan]")

            table = Table()
            table.add_column("Type", style="cyan")
            table.add_column("Name", style="white")
            table.add_column("Description", style="dim")
            table.add_column("Status", style="green")

            for pattern_key, pattern_data in patterns:
                status = "[green]✓[/green]" if self._pattern_file_exists(category, pattern_data["type"]) else "[red]Missing file[/red]"
                table.add_row(
                    pattern_data["type"],
                    pattern_data.get("name", "Unknown"),
                    pattern_data.get("description", "No description")[:50] + "..." if len(pattern_data.get("description", "")) > 50 else pattern_data.get("description", "No description"),
                    status
                )

            console.print(table)

    def _pattern_file_exists(self, category: str, pattern_type: str) -> bool:
        """Check if pattern markdown file exists."""
        file_path = self.patterns_dir / category / f"{pattern_type}.md"
        return file_path.exists()

    def show_pattern(self, category: str, pattern_type: str) -> None:
        """Show details of a specific pattern."""
        config = self.load_patterns_config()

        pattern_key = f"{category}/{pattern_type}"
        if pattern_key not in config["patterns"]:
            console.print(f"[red]Pattern '{pattern_key}' not found.[/red]")
            return

        pattern_data = config["patterns"][pattern_key]
        file_path = self.patterns_dir / category / f"{pattern_type}.md"

        # Show pattern info
        console.print(f"\n[bold cyan]{pattern_data['name']}[/bold cyan]")
        console.print(f"Category: {category}")
        console.print(f"Type: {pattern_type}")
        console.print(f"Description: {pattern_data['description']}\n")

        # Show sections
        sections = ["when_to_use", "how_to_apply", "expected_outcomes", "examples"]
        for section in sections:
            if section in pattern_data:
                console.print(f"[bold]{section.replace('_', ' ').title()}:[/bold]")
                console.print(f"{pattern_data[section]}\n")

        # Show file content if exists
        if file_path.exists():
            try:
                content = file_path.read_text(encoding='utf-8')
                console.print("Full documentation:")
                console.print("-" * 40)
                console.print(content)
            except Exception as e:
                console.print(f"[red]Error reading pattern file:[/red] {e}")
        else:
            console.print("[yellow]Pattern file not found on disk.[/yellow]")

@app.command()
def list(
    project_path: str = typer.Argument(".", help="Path to the project directory"),
):
    """List all configured patterns."""
    project_path = Path(project_path).resolve()

    if not project_path.exists():
        console.print(f"[red]Error:[/red] Project path does not exist: {project_path}")
        raise typer.Exit(1)

    manager = PatternManager(project_path)

    if not manager.ensure_project_structure():
        raise typer.Exit(1)

    manager.list_patterns()

@app.command()
def create(
    category: str = typer.Argument(..., help="Pattern category (communication, decision-making, etc.)"),
    pattern_type: str = typer.Argument(..., help="Type of pattern to create"),
    project_path: str = typer.Argument(".", help="Path to the project directory"),
    interactive: bool = typer.Option(True, "--interactive/--non-interactive", help="Use interactive mode"),
):
    """Create a new pattern."""
    project_path = Path(project_path).resolve()

    if not project_path.exists():
        console.print(f"[red]Error:[/red] Project path does not exist: {project_path}")
        raise typer.Exit(1)

    manager = PatternManager(project_path)

    if not manager.ensure_project_structure():
        raise typer.Exit(1)

    # Validate category
    available_categories = manager.list_available_pattern_types()
    if category not in available_categories:
        console.print(f"[red]Error:[/red] Invalid pattern category '{category}'")
        console.print(f"Available categories: {', '.join(available_categories)}")
        raise typer.Exit(1)

    # Validate pattern type based on category
    if category == "communication":
        available_types = manager.list_available_communication_patterns()
    elif category == "decision-making":
        available_types = manager.list_available_decision_patterns()
    else:
        available_types = []

    if pattern_type not in available_types and available_types:
        console.print(f"[red]Error:[/red] Invalid pattern type '{pattern_type}' for category '{category}'")
        console.print(f"Available types: {', '.join(available_types)}")
        raise typer.Exit(1)

    # Load existing config
    config = manager.load_patterns_config()

    # Check if pattern already exists
    pattern_key = f"{category}/{pattern_type}"
    if pattern_key in config["patterns"]:
        console.print(f"[yellow]Pattern '{pattern_key}' already exists.[/yellow]")
        if not Confirm.ask("Do you want to overwrite it?"):
            console.print("Operation cancelled.")
            return

    if interactive:
        pattern = manager.create_pattern_interactive(category, pattern_type)
        if pattern:
            # Update config
            config["patterns"][pattern_key] = pattern

            # Save config and file
            if manager.save_patterns_config(config) and manager.save_pattern_file(pattern):
                console.print(f"\n[bold green]✓ Pattern '{pattern_key}' created successfully![/bold green]")
            else:
                console.print(f"\n[red]Failed to save pattern '{pattern_key}'.[/red]")
                raise typer.Exit(1)
        else:
            console.print(f"\n[red]Failed to create pattern '{pattern_key}'.[/red]")
            raise typer.Exit(1)
    else:
        console.print("[cyan]Non-interactive mode not yet implemented.[/cyan]")
        console.print("Use --interactive flag for now.")
        raise typer.Exit(1)

@app.command()
def show(
    category: str = typer.Argument(..., help="Pattern category"),
    pattern_type: str = typer.Argument(..., help="Pattern type to show"),
    project_path: str = typer.Argument(".", help="Path to the project directory"),
):
    """Show details of a specific pattern."""
    project_path = Path(project_path).resolve()

    if not project_path.exists():
        console.print(f"[red]Error:[/red] Project path does not exist: {project_path}")
        raise typer.Exit(1)

    manager = PatternManager(project_path)

    if not manager.ensure_project_structure():
        raise typer.Exit(1)

    manager.show_pattern(category, pattern_type)

@app.command()
def validate(
    project_path: str = typer.Argument(".", help="Path to the project directory"),
):
    """Validate all patterns in the project."""
    project_path = Path(project_path).resolve()

    if not project_path.exists():
        console.print(f"[red]Error:[/red] Project path does not exist: {project_path}")
        raise typer.Exit(1)

    manager = PatternManager(project_path)

    if not manager.ensure_project_structure():
        raise typer.Exit(1)

    config = manager.load_patterns_config()

    if not config["patterns"]:
        console.print("[yellow]No patterns configured.[/yellow]")
        console.print("Use 'persona-kit patterns create' to add patterns.")
        raise typer.Exit(1)

    console.print("[bold]Validating patterns...[/bold]\n")

    table = Table(title="Pattern Validation")
    table.add_column("Pattern", style="cyan")
    table.add_column("Config", style="white")
    table.add_column("File", style="white")
    table.add_column("Status", style="white")

    all_valid = True

    for pattern_key, pattern_data in config["patterns"].items():
        category, pattern_type = pattern_key.split('/', 1)
        config_ok = "[green]✓[/green]" if pattern_key in config["patterns"] else "[red]✗[/red]"
        file_ok = "[green]✓[/green]" if manager._pattern_file_exists(category, pattern_type) else "[red]✗[/red]"

        # Overall status
        if config_ok == "[green]✓[/green]" and file_ok == "[green]✓[/green]":
            status = "[green]Valid[/green]"
        else:
            status = "[red]Invalid[/red]"
            all_valid = False

        table.add_row(pattern_key, config_ok, file_ok, status)

    console.print(table)

    if all_valid:
        console.print("\n[bold green]✓ All patterns are valid![/bold green]")
    else:
        console.print("\n[yellow]Some patterns have issues that need to be resolved.[/yellow]")

def main():
    """Main entry point for patterns command."""
    app()

if __name__ == "__main__":
    main()