// Class-based state implementation using Svelte's state management
export class SuperState {
  // Initialize a reactive state variable with value 0
  // Using $state makes this property reactive in Svelte
  value = $state(0);

  // Method to increment the value by 1
  up() {
    this.value += 1;
  }
}

// Function-based state implementation
export function createState() {
  // Initialize a private reactive state variable with value 0
  let value = $state(0);

  // Function to increment the value by 1
  function up() {
    value += 1;
  }

  // Return an object with getter/setter for value and up method
  return {
    // Getter method to access the current value
    get value() {
      return value;
    },
    // Setter method to update the value
    set value(newValue) {
      value = newValue;
    },
    // Method to increment the value
    up
  }
}
