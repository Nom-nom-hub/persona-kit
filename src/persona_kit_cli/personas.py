#!/usr/bin/env python3
"""
Personas command module for Persona Kit CLI.

This module handles the /persona-kit.personas workflow for managing
team member personas and their communication styles.
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
    name="personas",
    help="Manage team personas and communication styles",
    add_completion=False,
)

class PersonaManager:
    """Handles persona management for projects."""

    def __init__(self, project_path: Path):
        self.project_path = Path(project_path)
        self.personas_dir = self.project_path / "persona-kit" / "personas"
        self.personas_config = self.personas_dir / "personas.json"

    def ensure_project_structure(self) -> bool:
        """Ensure the project structure exists."""
        try:
            self.personas_dir.mkdir(parents=True, exist_ok=True)
            return True
        except Exception as e:
            console.print(f"[red]Error creating project structure:[/red] {e}")
            return False

    def load_personas_config(self) -> Dict[str, Any]:
        """Load existing personas configuration."""
        if not self.personas_config.exists():
            return {"personas": {}, "version": "1.0"}

        try:
            with open(self.personas_config, 'r', encoding='utf-8') as f:
                return json.load(f)
        except Exception as e:
            console.print(f"[yellow]Warning: Could not load personas config:[/yellow] {e}")
            return {"personas": {}, "version": "1.0"}

    def save_personas_config(self, config: Dict[str, Any]) -> bool:
        """Save personas configuration."""
        try:
            with open(self.personas_config, 'w', encoding='utf-8') as f:
                json.dump(config, f, indent=2, ensure_ascii=False)
            return True
        except Exception as e:
            console.print(f"[red]Error saving personas config:[/red] {e}")
            return False

    def list_available_personas(self) -> List[str]:
        """List available persona types."""
        return [
            "product-manager",
            "developer",
            "designer",
            "qa-engineer",
            "stakeholder",
            "devops-engineer",
            "technical-lead",
            "business-analyst",
            "user-experience-researcher",
            "data-scientist"
        ]

    def create_persona_interactive(self, persona_type: str) -> Optional[Dict[str, Any]]:
        """Create a persona through interactive prompts."""
        console.print(f"\n[bold cyan]Creating {persona_type} persona[/bold cyan]")

        # Basic information
        name = Prompt.ask("Persona name/title")
        description = Prompt.ask("Brief description of this role")

        # Communication style
        console.print("\n[bold]Communication Style[/bold]")
        communication_style = Prompt.ask("How does this persona typically communicate? (formal, casual, technical, etc.)")

        # Key responsibilities
        console.print("\n[bold]Key Responsibilities[/bold]")
        responsibilities = Prompt.ask("What are the main responsibilities of this role?")

        # Goals and priorities
        console.print("\n[bold]Goals and Priorities[/bold]")
        goals = Prompt.ask("What are the primary goals and priorities for this role?")

        # Decision making approach
        console.print("\n[bold]Decision Making[/bold]")
        decision_approach = Prompt.ask("How does this persona typically make decisions?")

        # Common phrases or terminology
        console.print("\n[bold]Communication Patterns[/bold]")
        common_phrases = Prompt.ask("What kind of language or phrases does this persona commonly use?")

        # Create persona object
        persona = {
            "type": persona_type,
            "name": name,
            "description": description,
            "communication_style": communication_style,
            "responsibilities": responsibilities,
            "goals": goals,
            "decision_approach": decision_approach,
            "common_phrases": common_phrases,
            "created_at": str(Path.cwd()),  # Could use datetime
            "version": "1.0"
        }

        return persona

    def save_persona_file(self, persona: Dict[str, Any]) -> bool:
        """Save individual persona to markdown file."""
        persona_type = persona["type"]
        filename = f"{persona_type}.md"
        file_path = self.personas_dir / filename

        # Generate markdown content
        content = f"""# {persona['name']}

**Type:** {persona_type}
**Description:** {persona['description']}

## Communication Style

{persona['communication_style']}

## Key Responsibilities

{persona['responsibilities']}

## Goals and Priorities

{persona['goals']}

## Decision Making Approach

{persona['decision_approach']}

## Communication Patterns

{persona['common_phrases']}

## Usage Guidelines

When communicating as this persona:
- Maintain the specified communication style
- Focus on the defined responsibilities and goals
- Use the characteristic language patterns
- Make decisions according to the stated approach

---
*Generated by Persona Kit CLI*
"""

        try:
            file_path.write_text(content, encoding='utf-8')
            return True
        except Exception as e:
            console.print(f"[red]Error saving persona file:[/red] {e}")
            return False

    def list_personas(self) -> None:
        """List all existing personas."""
        config = self.load_personas_config()

        if not config["personas"]:
            console.print("[yellow]No personas configured yet.[/yellow]")
            console.print("Use 'persona-kit personas create' to add personas.")
            return

        table = Table(title="Project Personas")
        table.add_column("Type", style="cyan")
        table.add_column("Name", style="white")
        table.add_column("Description", style="dim")
        table.add_column("Status", style="green")

        for persona_type, persona_data in config["personas"].items():
            status = "[green]✓[/green]" if self._persona_file_exists(persona_type) else "[red]Missing file[/red]"
            table.add_row(
                persona_type,
                persona_data.get("name", "Unknown"),
                persona_data.get("description", "No description")[:50] + "..." if len(persona_data.get("description", "")) > 50 else persona_data.get("description", "No description"),
                status
            )

        console.print(table)

    def _persona_file_exists(self, persona_type: str) -> bool:
        """Check if persona markdown file exists."""
        file_path = self.personas_dir / f"{persona_type}.md"
        return file_path.exists()

    def show_persona(self, persona_type: str) -> None:
        """Show details of a specific persona."""
        config = self.load_personas_config()

        if persona_type not in config["personas"]:
            console.print(f"[red]Persona '{persona_type}' not found.[/red]")
            return

        persona_data = config["personas"][persona_type]
        file_path = self.personas_dir / f"{persona_type}.md"

        # Show persona info
        console.print(f"\n[bold cyan]{persona_data['name']}[/bold cyan]")
        console.print(f"Type: {persona_type}")
        console.print(f"Description: {persona_data['description']}\n")

        # Show file content if exists
        if file_path.exists():
            try:
                content = file_path.read_text(encoding='utf-8')
                console.print("File content:")
                console.print("-" * 40)
                console.print(content)
            except Exception as e:
                console.print(f"[red]Error reading persona file:[/red] {e}")
        else:
            console.print("[yellow]Persona file not found on disk.[/yellow]")

@app.command()
def list(
    project_path: str = typer.Argument(".", help="Path to the project directory"),
):
    """List all configured personas."""
    project_path = Path(project_path).resolve()

    if not project_path.exists():
        console.print(f"[red]Error:[/red] Project path does not exist: {project_path}")
        raise typer.Exit(1)

    manager = PersonaManager(project_path)

    if not manager.ensure_project_structure():
        raise typer.Exit(1)

    manager.list_personas()

@app.command()
def create(
    persona_type: str = typer.Argument(..., help="Type of persona to create"),
    project_path: str = typer.Argument(".", help="Path to the project directory"),
    interactive: bool = typer.Option(True, "--interactive/--non-interactive", help="Use interactive mode"),
):
    """Create a new persona."""
    project_path = Path(project_path).resolve()

    if not project_path.exists():
        console.print(f"[red]Error:[/red] Project path does not exist: {project_path}")
        raise typer.Exit(1)

    manager = PersonaManager(project_path)

    if not manager.ensure_project_structure():
        raise typer.Exit(1)

    # Validate persona type
    available_types = manager.list_available_personas()
    if persona_type not in available_types:
        console.print(f"[red]Error:[/red] Invalid persona type '{persona_type}'")
        console.print(f"Available types: {', '.join(available_types)}")
        raise typer.Exit(1)

    # Load existing config
    config = manager.load_personas_config()

    # Check if persona already exists
    if persona_type in config["personas"]:
        console.print(f"[yellow]Persona '{persona_type}' already exists.[/yellow]")
        if not Confirm.ask("Do you want to overwrite it?"):
            console.print("Operation cancelled.")
            return

    if interactive:
        persona = manager.create_persona_interactive(persona_type)
        if persona:
            # Update config
            config["personas"][persona_type] = persona

            # Save config and file
            if manager.save_personas_config(config) and manager.save_persona_file(persona):
                console.print(f"\n[bold green]✓ Persona '{persona_type}' created successfully![/bold green]")
            else:
                console.print(f"\n[red]Failed to save persona '{persona_type}'.[/red]")
                raise typer.Exit(1)
        else:
            console.print(f"\n[red]Failed to create persona '{persona_type}'.[/red]")
            raise typer.Exit(1)
    else:
        console.print("[cyan]Non-interactive mode not yet implemented.[/cyan]")
        console.print("Use --interactive flag for now.")
        raise typer.Exit(1)

@app.command()
def show(
    persona_type: str = typer.Argument(..., help="Type of persona to show"),
    project_path: str = typer.Argument(".", help="Path to the project directory"),
):
    """Show details of a specific persona."""
    project_path = Path(project_path).resolve()

    if not project_path.exists():
        console.print(f"[red]Error:[/red] Project path does not exist: {project_path}")
        raise typer.Exit(1)

    manager = PersonaManager(project_path)

    if not manager.ensure_project_structure():
        raise typer.Exit(1)

    manager.show_persona(persona_type)

@app.command()
def validate(
    project_path: str = typer.Argument(".", help="Path to the project directory"),
):
    """Validate all personas in the project."""
    project_path = Path(project_path).resolve()

    if not project_path.exists():
        console.print(f"[red]Error:[/red] Project path does not exist: {project_path}")
        raise typer.Exit(1)

    manager = PersonaManager(project_path)

    if not manager.ensure_project_structure():
        raise typer.Exit(1)

    config = manager.load_personas_config()

    if not config["personas"]:
        console.print("[yellow]No personas configured.[/yellow]")
        console.print("Use 'persona-kit personas create' to add personas.")
        raise typer.Exit(1)

    console.print("[bold]Validating personas...[/bold]\n")

    table = Table(title="Persona Validation")
    table.add_column("Persona", style="cyan")
    table.add_column("Config", style="white")
    table.add_column("File", style="white")
    table.add_column("Status", style="white")

    all_valid = True

    for persona_type in config["personas"]:
        config_ok = "[green]✓[/green]" if persona_type in config["personas"] else "[red]✗[/red]"
        file_ok = "[green]✓[/green]" if manager._persona_file_exists(persona_type) else "[red]✗[/red]"

        # Overall status
        if config_ok == "[green]✓[/green]" and file_ok == "[green]✓[/green]":
            status = "[green]Valid[/green]"
        else:
            status = "[red]Invalid[/red]"
            all_valid = False

        table.add_row(persona_type, config_ok, file_ok, status)

    console.print(table)

    if all_valid:
        console.print("\n[bold green]✓ All personas are valid![/bold green]")
    else:
        console.print("\n[yellow]Some personas have issues that need to be resolved.[/yellow]")

def main():
    """Main entry point for personas command."""
    app()

if __name__ == "__main__":
    main()