#!/usr/bin/env python3
"""
Workflows command module for Persona Kit CLI.

This module handles the /persona-kit.workflows workflow for managing
development workflows and processes.
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
    name="workflows",
    help="Manage development workflows and processes",
    add_completion=False,
)

class WorkflowManager:
    """Handles workflow management for projects."""

    def __init__(self, project_path: Path):
        self.project_path = Path(project_path)
        self.workflows_dir = self.project_path / "persona-kit" / "workflows"
        self.workflows_config = self.workflows_dir / "workflows.json"

    def ensure_project_structure(self) -> bool:
        """Ensure the project structure exists."""
        try:
            self.workflows_dir.mkdir(parents=True, exist_ok=True)
            return True
        except Exception as e:
            console.print(f"[red]Error creating project structure:[/red] {e}")
            return False

    def load_workflows_config(self) -> Dict[str, Any]:
        """Load existing workflows configuration."""
        if not self.workflows_config.exists():
            return {"workflows": {}, "version": "1.0"}

        try:
            with open(self.workflows_config, 'r', encoding='utf-8') as f:
                return json.load(f)
        except Exception as e:
            console.print(f"[yellow]Warning: Could not load workflows config:[/yellow] {e}")
            return {"workflows": {}, "version": "1.0"}

    def save_workflows_config(self, config: Dict[str, Any]) -> bool:
        """Save workflows configuration."""
        try:
            with open(self.workflows_config, 'w', encoding='utf-8') as f:
                json.dump(config, f, indent=2, ensure_ascii=False)
            return True
        except Exception as e:
            console.print(f"[red]Error saving workflows config:[/red] {e}")
            return False

    def list_available_workflow_types(self) -> List[str]:
        """List available workflow categories."""
        return [
            "feature-development",
            "bug-fixes",
            "design-reviews",
            "releases",
            "code-reviews",
            "testing",
            "deployment",
            "documentation"
        ]

    def create_workflow_interactive(self, workflow_type: str) -> Optional[Dict[str, Any]]:
        """Create a workflow through interactive prompts."""
        console.print(f"\n[bold cyan]Creating {workflow_type} workflow[/bold cyan]")

        # Basic information
        name = Prompt.ask("Workflow name/title")
        description = Prompt.ask("Brief description of this workflow")

        # Trigger conditions
        console.print("\n[bold]Trigger Conditions[/bold]")
        triggers = Prompt.ask("When should this workflow be initiated?")

        # Process steps
        console.print("\n[bold]Process Steps[/bold]")
        console.print("Enter each step (press Enter with empty line when done):")

        steps = []
        step_num = 1
        while True:
            step = Prompt.ask(f"Step {step_num}", default="")
            if not step:
                break
            steps.append(step)
            step_num += 1

        if not steps:
            console.print("[red]Error: Workflow must have at least one step.[/red]")
            return None

        # Required roles/personas
        console.print("\n[bold]Required Roles[/bold]")
        roles = Prompt.ask("Which personas/roles are typically involved in this workflow?")

        # Expected duration
        console.print("\n[bold]Timeline[/bold]")
        duration = Prompt.ask("What is the expected duration for this workflow?")

        # Success criteria
        console.print("\n[bold]Success Criteria[/bold]")
        success_criteria = Prompt.ask("How do you measure success for this workflow?")

        # Create workflow object
        workflow = {
            "type": workflow_type,
            "name": name,
            "description": description,
            "triggers": triggers,
            "steps": steps,
            "required_roles": roles,
            "expected_duration": duration,
            "success_criteria": success_criteria,
            "created_at": str(Path.cwd()),  # Could use datetime
            "version": "1.0"
        }

        return workflow

    def save_workflow_file(self, workflow: Dict[str, Any]) -> bool:
        """Save individual workflow to markdown file."""
        workflow_type = workflow["type"]
        filename = f"{workflow_type}.md"
        file_path = self.workflows_dir / filename

        # Generate markdown content
        content = f"""# {workflow['name']}

**Type:** {workflow_type}
**Description:** {workflow['description']}

## Trigger Conditions

{workflow['triggers']}

## Process Steps

"""

        for i, step in enumerate(workflow['steps'], 1):
            content += f"{i}. {step}\n"

        content += f"""
## Required Roles

{workflow['required_roles']}

## Expected Duration

{workflow['expected_duration']}

## Success Criteria

{workflow['success_criteria']}

## Usage Guidelines

When executing this workflow:
- Ensure all trigger conditions are met before starting
- Follow each step in sequence
- Involve the required roles/personas as specified
- Monitor progress against expected duration
- Verify success criteria are met upon completion

---
*Generated by Persona Kit CLI*
"""

        try:
            file_path.write_text(content, encoding='utf-8')
            return True
        except Exception as e:
            console.print(f"[red]Error saving workflow file:[/red] {e}")
            return False

    def list_workflows(self) -> None:
        """List all existing workflows."""
        config = self.load_workflows_config()

        if not config["workflows"]:
            console.print("[yellow]No workflows configured yet.[/yellow]")
            console.print("Use 'persona-kit workflows create' to add workflows.")
            return

        table = Table(title="Project Workflows")
        table.add_column("Type", style="cyan")
        table.add_column("Name", style="white")
        table.add_column("Description", style="dim")
        table.add_column("Steps", style="green")
        table.add_column("Status", style="green")

        for workflow_type, workflow_data in config["workflows"].items():
            steps_count = len(workflow_data.get("steps", []))
            status = "[green]✓[/green]" if self._workflow_file_exists(workflow_type) else "[red]Missing file[/red]"
            table.add_row(
                workflow_type,
                workflow_data.get("name", "Unknown"),
                workflow_data.get("description", "No description")[:50] + "..." if len(workflow_data.get("description", "")) > 50 else workflow_data.get("description", "No description"),
                str(steps_count),
                status
            )

        console.print(table)

    def _workflow_file_exists(self, workflow_type: str) -> bool:
        """Check if workflow markdown file exists."""
        file_path = self.workflows_dir / f"{workflow_type}.md"
        return file_path.exists()

    def show_workflow(self, workflow_type: str) -> None:
        """Show details of a specific workflow."""
        config = self.load_workflows_config()

        if workflow_type not in config["workflows"]:
            console.print(f"[red]Workflow '{workflow_type}' not found.[/red]")
            return

        workflow_data = config["workflows"][workflow_type]
        file_path = self.workflows_dir / f"{workflow_type}.md"

        # Show workflow info
        console.print(f"\n[bold cyan]{workflow_data['name']}[/bold cyan]")
        console.print(f"Type: {workflow_type}")
        console.print(f"Description: {workflow_data['description']}\n")

        # Show sections
        sections = ["triggers", "required_roles", "expected_duration", "success_criteria"]
        for section in sections:
            if section in workflow_data:
                console.print(f"[bold]{section.replace('_', ' ').title()}:[/bold]")
                console.print(f"{workflow_data[section]}\n")

        # Show steps
        if "steps" in workflow_data:
            console.print("[bold]Process Steps:[/bold]")
            for i, step in enumerate(workflow_data["steps"], 1):
                console.print(f"{i}. {step}")
            console.print()

        # Show file content if exists
        if file_path.exists():
            try:
                content = file_path.read_text(encoding='utf-8')
                console.print("Full documentation:")
                console.print("-" * 40)
                console.print(content)
            except Exception as e:
                console.print(f"[red]Error reading workflow file:[/red] {e}")
        else:
            console.print("[yellow]Workflow file not found on disk.[/yellow]")

@app.command()
def list(
    project_path: str = typer.Argument(".", help="Path to the project directory"),
):
    """List all configured workflows."""
    project_path = Path(project_path).resolve()

    if not project_path.exists():
        console.print(f"[red]Error:[/red] Project path does not exist: {project_path}")
        raise typer.Exit(1)

    manager = WorkflowManager(project_path)

    if not manager.ensure_project_structure():
        raise typer.Exit(1)

    manager.list_workflows()

@app.command()
def create(
    workflow_type: str = typer.Argument(..., help="Type of workflow to create"),
    project_path: str = typer.Argument(".", help="Path to the project directory"),
    interactive: bool = typer.Option(True, "--interactive/--non-interactive", help="Use interactive mode"),
):
    """Create a new workflow."""
    project_path = Path(project_path).resolve()

    if not project_path.exists():
        console.print(f"[red]Error:[/red] Project path does not exist: {project_path}")
        raise typer.Exit(1)

    manager = WorkflowManager(project_path)

    if not manager.ensure_project_structure():
        raise typer.Exit(1)

    # Validate workflow type
    available_types = manager.list_available_workflow_types()
    if workflow_type not in available_types:
        console.print(f"[red]Error:[/red] Invalid workflow type '{workflow_type}'")
        console.print(f"Available types: {', '.join(available_types)}")
        raise typer.Exit(1)

    # Load existing config
    config = manager.load_workflows_config()

    # Check if workflow already exists
    if workflow_type in config["workflows"]:
        console.print(f"[yellow]Workflow '{workflow_type}' already exists.[/yellow]")
        if not Confirm.ask("Do you want to overwrite it?"):
            console.print("Operation cancelled.")
            return

    if interactive:
        workflow = manager.create_workflow_interactive(workflow_type)
        if workflow:
            # Update config
            config["workflows"][workflow_type] = workflow

            # Save config and file
            if manager.save_workflows_config(config) and manager.save_workflow_file(workflow):
                console.print(f"\n[bold green]✓ Workflow '{workflow_type}' created successfully![/bold green]")
            else:
                console.print(f"\n[red]Failed to save workflow '{workflow_type}'.[/red]")
                raise typer.Exit(1)
        else:
            console.print(f"\n[red]Failed to create workflow '{workflow_type}'.[/red]")
            raise typer.Exit(1)
    else:
        console.print("[cyan]Non-interactive mode not yet implemented.[/cyan]")
        console.print("Use --interactive flag for now.")
        raise typer.Exit(1)

@app.command()
def show(
    workflow_type: str = typer.Argument(..., help="Type of workflow to show"),
    project_path: str = typer.Argument(".", help="Path to the project directory"),
):
    """Show details of a specific workflow."""
    project_path = Path(project_path).resolve()

    if not project_path.exists():
        console.print(f"[red]Error:[/red] Project path does not exist: {project_path}")
        raise typer.Exit(1)

    manager = WorkflowManager(project_path)

    if not manager.ensure_project_structure():
        raise typer.Exit(1)

    manager.show_workflow(workflow_type)

@app.command()
def validate(
    project_path: str = typer.Argument(".", help="Path to the project directory"),
):
    """Validate all workflows in the project."""
    project_path = Path(project_path).resolve()

    if not project_path.exists():
        console.print(f"[red]Error:[/red] Project path does not exist: {project_path}")
        raise typer.Exit(1)

    manager = WorkflowManager(project_path)

    if not manager.ensure_project_structure():
        raise typer.Exit(1)

    config = manager.load_workflows_config()

    if not config["workflows"]:
        console.print("[yellow]No workflows configured.[/yellow]")
        console.print("Use 'persona-kit workflows create' to add workflows.")
        raise typer.Exit(1)

    console.print("[bold]Validating workflows...[/bold]\n")

    table = Table(title="Workflow Validation")
    table.add_column("Workflow", style="cyan")
    table.add_column("Config", style="white")
    table.add_column("File", style="white")
    table.add_column("Steps", style="white")
    table.add_column("Status", style="white")

    all_valid = True

    for workflow_type, workflow_data in config["workflows"].items():
        config_ok = "[green]✓[/green]" if workflow_type in config["workflows"] else "[red]✗[/red]"
        file_ok = "[green]✓[/green]" if manager._workflow_file_exists(workflow_type) else "[red]✗[/red]"
        steps_count = len(workflow_data.get("steps", []))
        steps_ok = "[green]✓[/green]" if steps_count > 0 else "[red]✗[/red]"

        # Overall status
        if config_ok == "[green]✓[/green]" and file_ok == "[green]✓[/green]" and steps_ok == "[green]✓[/green]":
            status = "[green]Valid[/green]"
        else:
            status = "[red]Invalid[/red]"
            all_valid = False

        table.add_row(workflow_type, config_ok, file_ok, steps_ok, status)

    console.print(table)

    if all_valid:
        console.print("\n[bold green]✓ All workflows are valid![/bold green]")
    else:
        console.print("\n[yellow]Some workflows have issues that need to be resolved.[/yellow]")

def main():
    """Main entry point for workflows command."""
    app()

if __name__ == "__main__":
    main()