// Import the Plugin class from Obsidian's API
import { Plugin } from "obsidian";

// Define a plugin class that extends Obsidian's base Plugin class
export default class ObsidianPluginTemplate extends Plugin {
  // Declare a property to store the status bar element
  statusBarElement: HTMLSpanElement;

  // Called when the plugin is loaded
  onload() {
    // Create a new span element in Obsidian's status bar
    this.statusBarElement = this.addStatusBarItem().createEl("span");

    // Initialize the line count for the current active file
    this.readActiveFileAndUpdateLineCount();

    // Register an event listener for when the editor content changes
    // This ensures the line count updates in real-time as the user types
    this.app.workspace.on("editor-change", (editor) => {
      const content = editor.getDoc().getValue();
      this.updateLineCount(content);
    });

    // Register an event listener for when the user switches between different files
    // This ensures the line count updates when changing to a different file
    this.app.workspace.on("active-leaf-change", () => {
      this.readActiveFileAndUpdateLineCount();
    });
  }

  // Called when the plugin is disabled or Obsidian is closed
  onunload() {
    // Remove the status bar element to clean up
    this.statusBarElement.remove();
  }

  // Helper method to read the current file's content and update the line count
  private async readActiveFileAndUpdateLineCount() {
    // Get the currently active file
    const file = this.app.workspace.getActiveFile();
    if (file) {
      // If there is an active file, read its content
      const content = await this.app.vault.read(file);
      this.updateLineCount(content);
    } else {
      // If no file is active, show 0 lines
      this.updateLineCount(undefined);
    }
  }

  // Helper method to calculate and display the line count
  private updateLineCount(fileContent?: string) {
    // Calculate the number of lines by splitting on newline characters
    // If no content is provided, default to 0 lines
    const count = fileContent ? fileContent.split(/\r\n|\r|\n/).length : 0;

    // Use proper singular/plural form of "line" based on count
    const linesWord = count === 1 ? "line" : "lines";

    // Update the status bar text with the current line count
    this.statusBarElement.textContent = `${count} ${linesWord}`;
  }
}
