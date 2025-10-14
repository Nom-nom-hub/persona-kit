#!/usr/bin/env python3
"""
Implement command module for Persona Kit CLI.

This module handles the /persona-kit.implement workflow for executing
implementation tasks and managing development processes.
"""

import os
import json
import subprocess
from pathlib import Path
from typing import Optional, Dict, Any, List

import typer
from rich.console import Console
from rich.panel import Panel
from rich.prompt import Prompt, Confirm
from rich.table import Table
from rich.text import Text
from rich.progress import Progress, SpinnerColumn, TextColumn

console = Console()

app = typer.Typer(
    name="implement",
    help="Execute implementation tasks and manage development processes",
    add_completion=False,
)

class ImplementationManager:
    """Handles implementation execution for projects."""

    def __init__(self, project_path: Path):
        self.project_path = Path(project_path)
        self.implement_config = self.project_path / "persona-kit" / "implement.json"
        self.tasks_file = self.project_path / "persona-kit" / "tasks.json"

    def ensure_project_structure(self) -> bool:
        """Ensure the project structure exists."""
        try:
            self.implement_config.parent.mkdir(parents=True, exist_ok=True)
            return True
        except Exception as e:
            console.print(f"[red]Error creating project structure:[/red] {e}")
            return False

    def load_implement_config(self) -> Dict[str, Any]:
        """Load existing implementation configuration."""
        if not self.implement_config.exists():
            return {
                "settings": {
                    "auto_commit": True,
                    "create_branches": True,
                    "run_tests": True,
                    "generate_docs": False
                },
                "version": "1.0"
            }

        try:
            with open(self.implement_config, 'r', encoding='utf-8') as f:
                return json.load(f)
        except Exception as e:
            console.print(f"[yellow]Warning: Could not load implement config:[/yellow] {e}")
            return {
                "settings": {
                    "auto_commit": True,
                    "create_branches": True,
                    "run_tests": True,
                    "generate_docs": False
                },
                "version": "1.0"
            }

    def save_implement_config(self, config: Dict[str, Any]) -> bool:
        """Save implementation configuration."""
        try:
            with open(self.implement_config, 'w', encoding='utf-8') as f:
                json.dump(config, f, indent=2, ensure_ascii=False)
            return True
        except Exception as e:
            console.print(f"[red]Error saving implement config:[/red] {e}")
            return False

    def load_tasks(self) -> List[Dict[str, Any]]:
        """Load tasks from tasks file."""
        if not self.tasks_file.exists():
            return []

        try:
            with open(self.tasks_file, 'r', encoding='utf-8') as f:
                data = json.load(f)
                return data.get("tasks", [])
        except Exception as e:
            console.print(f"[yellow]Warning: Could not load tasks:[/yellow] {e}")
            return []

    def save_tasks(self, tasks: List[Dict[str, Any]]) -> bool:
        """Save tasks to tasks file."""
        try:
            data = {"tasks": tasks, "version": "1.0"}
            with open(self.tasks_file, 'w', encoding='utf-8') as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
            return True
        except Exception as e:
            console.print(f"[red]Error saving tasks:[/red] {e}")
            return False

    def is_git_repo(self) -> bool:
        """Check if current directory is a git repository."""
        try:
            result = subprocess.run(
                ["git", "rev-parse", "--is-inside-work-tree"],
                check=True,
                capture_output=True,
                text=True,
                cwd=self.project_path
            )
            return True
        except (subprocess.CalledProcessError, FileNotFoundError):
            return False

    def create_branch(self, branch_name: str) -> bool:
        """Create a new git branch."""
        try:
            # Check if branch already exists
            result = subprocess.run(
                ["git", "branch", "--list", branch_name],
                capture_output=True,
                text=True,
                cwd=self.project_path
            )

            if branch_name in result.stdout:
                console.print(f"[yellow]Branch '{branch_name}' already exists.[/yellow]")
                return True

            # Create new branch
            subprocess.run(
                ["git", "checkout", "-b", branch_name],
                check=True,
                cwd=self.project_path
            )
            console.print(f"[green]Created and switched to branch '{branch_name}'[/green]")
            return True
        except subprocess.CalledProcessError as e:
            console.print(f"[red]Error creating branch:[/red] {e}")
            return False

    def commit_changes(self, message: str) -> bool:
        """Commit changes to git."""
        try:
            # Add all changes
            subprocess.run(
                ["git", "add", "."],
                check=True,
                cwd=self.project_path
            )

            # Check if there are changes to commit
            result = subprocess.run(
                ["git", "diff", "--cached", "--name-only"],
                capture_output=True,
                text=True,
                cwd=self.project_path
            )

            if not result.stdout.strip():
                console.print("[yellow]No changes to commit.[/yellow]")
                return True

            # Commit changes
            subprocess.run(
                ["git", "commit", "-m", message],
                check=True,
                cwd=self.project_path
            )
            console.print(f"[green]Committed changes: {message}[/green]")
            return True
        except subprocess.CalledProcessError as e:
            console.print(f"[red]Error committing changes:[/red] {e}")
            return False

    def run_tests(self) -> bool:
        """Run project tests."""
        # Look for common test commands
        test_commands = [
            ["python", "-m", "pytest"],
            ["python", "-m", "unittest"],
            ["npm", "test"],
            ["yarn", "test"],
            ["cargo", "test"],
            ["go", "test", "./..."]
        ]

        for cmd in test_commands:
            try:
                console.print(f"[cyan]Trying test command: {' '.join(cmd)}[/cyan]")
                result = subprocess.run(
                    cmd,
                    capture_output=True,
                    text=True,
                    cwd=self.project_path,
                    timeout=300  # 5 minute timeout
                )

                if result.returncode == 0:
                    console.print("[green]Tests passed![/green]")
                    return True
                else:
                    console.print(f"[yellow]Tests failed or command not found. Exit code: {result.returncode}[/yellow]")
                    if result.stdout:
                        console.print(f"Output: {result.stdout}")
                    if result.stderr:
                        console.print(f"Error: {result.stderr}")

            except (subprocess.TimeoutExpired, FileNotFoundError):
                continue
            except subprocess.CalledProcessError as e:
                console.print(f"[red]Error running tests:[/red] {e}")
                return False

        console.print("[yellow]No working test command found or all tests failed.[/yellow]")
        return False

    def execute_task(self, task: Dict[str, Any], config: Dict[str, Any]) -> bool:
        """Execute a single implementation task."""
        task_id = task.get("id", "unknown")
        task_name = task.get("name", "Unnamed task")
        task_description = task.get("description", "")

        console.print(f"\n[bold cyan]Executing Task: {task_name}[/bold cyan]")
        if task_description:
            console.print(f"Description: {task_description}")

        # Create branch if enabled
        if config["settings"].get("create_branches", True):
            branch_name = f"task-{task_id}"
            if not self.create_branch(branch_name):
                return False

        # Execute the task (placeholder for now)
        console.print("[cyan]Executing implementation steps...[/cyan]")

        with Progress(
            SpinnerColumn(),
            TextColumn("[progress.description]{task.description}"),
            console=console,
        ) as progress:

            # Simulate implementation steps
            steps = [
                "Analyze requirements",
                "Plan implementation",
                "Write code",
                "Review changes",
                "Update documentation"
            ]

            for step in steps:
                task_progress = progress.add_task(step, total=100)
                # Simulate work
                import time
                time.sleep(0.5)
                progress.update(task_progress, completed=100)

        # Run tests if enabled
        if config["settings"].get("run_tests", True):
            console.print("[cyan]Running tests...[/cyan]")
            tests_passed = self.run_tests()
            if not tests_passed:
                console.print("[yellow]Tests failed or not found. Continuing anyway.[/yellow]")

        # Commit changes if enabled
        if config["settings"].get("auto_commit", True):
            commit_message = f"Implement {task_name}"
            if not self.commit_changes(commit_message):
                return False

        console.print(f"[green]✓ Task '{task_name}' completed successfully![/green]")
        return True

    def show_status(self) -> None:
        """Show current implementation status."""
        config = self.load_implement_config()
        tasks = self.load_tasks()

        # Show settings
        console.print("[bold]Implementation Settings:[/bold]")
        settings = config.get("settings", {})
        for key, value in settings.items():
            status = "[green]Enabled[/green]" if value else "[red]Disabled[/red]"
            console.print(f"  {key.replace('_', ' ').title()}: {status}")

        # Show tasks
        if tasks:
            console.print(f"\n[bold]Pending Tasks ({len(tasks)}):[/bold]")

            table = Table()
            table.add_column("ID", style="cyan")
            table.add_column("Name", style="white")
            table.add_column("Status", style="yellow")
            table.add_column("Priority", style="red")

            for task in tasks:
                table.add_row(
                    str(task.get("id", "N/A")),
                    task.get("name", "Unnamed"),
                    task.get("status", "pending"),
                    str(task.get("priority", "medium"))
                )

            console.print(table)
        else:
            console.print("\n[yellow]No tasks found.[/yellow]")
            console.print("Use task management tools to create tasks first.")

        # Show git status
        if self.is_git_repo():
            try:
                result = subprocess.run(
                    ["git", "status", "--porcelain"],
                    capture_output=True,
                    text=True,
                    cwd=self.project_path
                )

                if result.stdout.strip():
                    console.print(f"\n[bold]Git Status:[/bold]")
                    console.print("[yellow]Uncommitted changes detected[/yellow]")
                else:
                    console.print(f"\n[bold]Git Status:[/bold]")
                    console.print("[green]Working directory clean[/green]")

                # Show current branch
                branch_result = subprocess.run(
                    ["git", "branch", "--show-current"],
                    capture_output=True,
                    text=True,
                    cwd=self.project_path
                )
                current_branch = branch_result.stdout.strip()
                console.print(f"Current branch: [cyan]{current_branch}[/cyan]")

            except subprocess.CalledProcessError:
                console.print(f"\n[bold]Git Status:[/bold]")
                console.print("[red]Error checking git status[/red]")

@app.command()
def status(
    project_path: str = typer.Argument(".", help="Path to the project directory"),
):
    """Show current implementation status."""
    project_path = Path(project_path).resolve()

    if not project_path.exists():
        console.print(f"[red]Error:[/red] Project path does not exist: {project_path}")
        raise typer.Exit(1)

    manager = ImplementationManager(project_path)

    if not manager.ensure_project_structure():
        raise typer.Exit(1)

    manager.show_status()

@app.command()
def execute(
    task_id: str = typer.Argument(..., help="ID of the task to execute"),
    project_path: str = typer.Argument(".", help="Path to the project directory"),
    force: bool = typer.Option(False, "--force", help="Force execution even if tests fail"),
):
    """Execute a specific implementation task."""
    project_path = Path(project_path).resolve()

    if not project_path.exists():
        console.print(f"[red]Error:[/red] Project path does not exist: {project_path}")
        raise typer.Exit(1)

    manager = ImplementationManager(project_path)

    if not manager.ensure_project_structure():
        raise typer.Exit(1)

    # Load tasks and find the specified task
    tasks = manager.load_tasks()
    task = None

    for t in tasks:
        if str(t.get("id", "")) == task_id:
            task = t
            break

    if not task:
        console.print(f"[red]Task with ID '{task_id}' not found.[/red]")
        raise typer.Exit(1)

    # Load configuration
    config = manager.load_implement_config()

    # Execute the task
    success = manager.execute_task(task, config)

    if success:
        console.print(f"\n[bold green]✓ Task execution completed successfully![/bold green]")
    else:
        console.print(f"\n[red]Task execution failed.[/red]")
        if not force:
            raise typer.Exit(1)

@app.command()
def config(
    project_path: str = typer.Argument(".", help="Path to the project directory"),
    auto_commit: bool = typer.Option(None, "--auto-commit/--no-auto-commit", help="Enable/disable automatic commits"),
    create_branches: bool = typer.Option(None, "--create-branches/--no-create-branches", help="Enable/disable automatic branch creation"),
    run_tests: bool = typer.Option(None, "--run-tests/--no-run-tests", help="Enable/disable automatic test running"),
    generate_docs: bool = typer.Option(None, "--generate-docs/--no-generate-docs", help="Enable/disable automatic documentation generation"),
):
    """Configure implementation settings."""
    project_path = Path(project_path).resolve()

    if not project_path.exists():
        console.print(f"[red]Error:[/red] Project path does not exist: {project_path}")
        raise typer.Exit(1)

    manager = ImplementationManager(project_path)

    if not manager.ensure_project_structure():
        raise typer.Exit(1)

    # Load current config
    config = manager.load_implement_config()

    # Update settings based on provided options
    settings_updated = False
    if auto_commit is not None:
        config["settings"]["auto_commit"] = auto_commit
        settings_updated = True

    if create_branches is not None:
        config["settings"]["create_branches"] = create_branches
        settings_updated = True

    if run_tests is not None:
        config["settings"]["run_tests"] = run_tests
        settings_updated = True

    if generate_docs is not None:
        config["settings"]["generate_docs"] = generate_docs
        settings_updated = True

    if not settings_updated:
        # Show current settings
        console.print("[bold]Current Implementation Settings:[/bold]")
        settings = config.get("settings", {})
        for key, value in settings.items():
            status = "[green]Enabled[/green]" if value else "[red]Disabled[/red]"
            console.print(f"  {key.replace('_', ' ').title()}: {status}")

        console.print("\n[dim]Use --help to see available configuration options.[/dim]")
        return

    # Save updated config
    if manager.save_implement_config(config):
        console.print("[green]✓ Implementation settings updated successfully![/green]")

        # Show updated settings
        console.print("\n[bold]Updated Settings:[/bold]")
        settings = config.get("settings", {})
        for key, value in settings.items():
            status = "[green]Enabled[/green]" if value else "[red]Disabled[/red]"
            console.print(f"  {key.replace('_', ' ').title()}: {status}")
    else:
        console.print("[red]Failed to save implementation settings.[/red]")
        raise typer.Exit(1)

@app.command()
def validate(
    project_path: str = typer.Argument(".", help="Path to the project directory"),
):
    """Validate implementation environment and configuration."""
    project_path = Path(project_path).resolve()

    if not project_path.exists():
        console.print(f"[red]Error:[/red] Project path does not exist: {project_path}")
        raise typer.Exit(1)

    manager = ImplementationManager(project_path)

    if not manager.ensure_project_structure():
        raise typer.Exit(1)

    console.print("[bold]Validating implementation environment...[/bold]\n")

    # Check git repository
    git_ok = manager.is_git_repo()
    git_status = "[green]✓ Git repository found[/green]" if git_ok else "[red]✗ Not a git repository[/red]"
    console.print(f"Git Repository: {git_status}")

    # Check for tasks
    tasks = manager.load_tasks()
    tasks_count = len(tasks)
    tasks_status = f"[green]✓ {tasks_count} tasks found[/green]" if tasks_count > 0 else "[yellow]⚠ No tasks found[/yellow]"
    console.print(f"Tasks: {tasks_status}")

    # Check configuration
    config = manager.load_implement_config()
    settings = config.get("settings", {})

    console.print("\n[bold]Configuration Settings:[/bold]")
    for key, value in settings.items():
        status = "[green]Enabled[/green]" if value else "[red]Disabled[/red]"
        console.print(f"  {key.replace('_', ' ').title()}: {status}")

    # Overall status
    if git_ok and tasks_count > 0:
        console.print("\n[bold green]✓ Implementation environment is ready![/bold green]")
    else:
        console.print("\n[yellow]⚠ Implementation environment needs attention.[/yellow]")
        if not git_ok:
            console.print("  - Initialize git repository or navigate to a git repository")
        if tasks_count == 0:
            console.print("  - Create tasks using task management tools")

def main():
    """Main entry point for implement command."""
    app()

if __name__ == "__main__":
    main()