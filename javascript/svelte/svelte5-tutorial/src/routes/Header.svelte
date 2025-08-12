<script lang="ts">
    // Import the Snippet type from Svelte for type checking
    import type { Snippet } from "svelte";

    // Import state management utilities from local state.svelte file
    import { createState, SuperState } from './state.svelte';

    // Define and destructure the component props using Svelte's $props
    // The component expects a 'name' prop of type string
    let { name } = $props<{name: string}>();

    // Create an instance of the basic state management
    // This likely contains a value property and an up method
    const myState = createState();

    // Create an instance of the more complex state management class
    // This is a class-based implementation with value and up properties
    const superState = new SuperState();
</script>

<div class="header">
    <h1>
        <!-- Display the user's name if provided, otherwise fallback to 'User' -->
        {name ? name : 'User'}'s Form
    </h1>

    <div class="button-container">
        <!-- Button that directly uses myState's up method as event handler -->
        <!-- Displays the current value from myState -->
        <button 
            class="state-button" 
            onclick={myState.up}
        >
            {myState.value}
        </button>

        <!-- Button that calls superState's up method via arrow function -->
        <!-- Displays the current value from superState -->
        <button 
            class="state-button" 
            onclick={() => superState.up()}
        >
            {superState.value}
        </button>
    </div>
</div>

<style>
    .header {
        padding: 1rem 0;
        margin-bottom: 2rem;
        border-bottom: 1px solid #eee;
    }

    h1 {
        margin: 0;
        font-size: 1.5rem;
        color: #333;
        font-weight: 600;
    }

    .button-container {
        display: flex;
        gap: 1rem;
        margin-top: 1rem;
    }

    .state-button {
        padding: 0.5rem 1rem;
        border: 1px solid #ccc;
        border-radius: 4px;
        background-color: #fff;
        cursor: pointer;
        transition: background-color 0.2s;
    }

    .state-button:hover {
        background-color: #f0f0f0;
    }
</style>
