<script lang="ts">
	  import { fly } from 'svelte/transition';

    // Import the Header component for displaying user information
    import Header from './Header.svelte';

    // Define the structure of the form's state
    interface FormState {
        answers: Record<string, string>;  // Stores form answers as key-value pairs
        name: string;                     // User's name
        birthday: string;                 // User's birthday
        step: number;                     // Current step in the form
        error: string;                    // Current error message, if any
    }

    // Define the questions array with validation rules
    const QUESTIONS = [
        {
            question: 'What is your name?',
            id: 'name',
            type: 'text',
            // Validation function checks if name is not empty
            validation: (value: string) => value.trim().length > 0 ? '' : 'Please enter a valid name'
        },
        {
            question: 'What is your birthday?',
            id: 'birthday',
            type: 'date',
            // Validation function checks if date is valid and in the past
            validation: (value: string) => {
                const date = new Date(value);
                const today = new Date();
                return date && date < today ? '' : 'Please enter a valid date'
            }
        }
    ] as const;  // Make the array readonly

    // Create a type from the QUESTIONS array elements
    type Question = typeof QUESTIONS[number];

    // Initialize form state using Svelte's state management
    let formState = $state<FormState>({
        answers: {},
        name: '',
        birthday: '',
        step: 0,
        error: ''
    });

    // Validate a single form step
    function validateStep(id: string, value: string): string {
        const question = QUESTIONS.find(q => q.id === id);
        return question ? question.validation(value) : 'Invalid question';
    }

    // Move to the next step if validation passes
    function nextStep(id: string) {
        const validationError = validateStep(id, formState.answers[id]);

        if (validationError) {
            formState.error = validationError;
            return;
        }

        formState.error = '';
        // Increment step, but don't exceed questions length
        formState.step = Math.min(formState.step + 1, QUESTIONS.length);
    }

    // Move to the previous step
    function previousStep() {
        formState.error = '';
        // Decrement step, but don't go below 0
        formState.step = Math.max(formState.step - 1, 0);
    }

    // Calculate progress percentage
    function getProgress(): number {
        return ((formState.step + 1) / QUESTIONS.length) * 100;
    }

    // Lifecycle hooks using Svelte's effect system
    $effect(() => {
        console.log('on mounted');
        // Cleanup function runs when component is destroyed
        return () => {
            console.log('on unmounted');
        }
    });

    // Watch for changes in form step
    $effect(() => {
        console.log('formState', formState.step);
    });
</script>

<main>
    <!-- Display Header with user's name or 'Guest' if not provided -->
    <Header name={formState.answers.name ?? 'Guest'} />

    {#if formState.step >= QUESTIONS.length}
        <!-- Show completion message when all questions are answered -->
        <div class="completion">
            <p>Thank you for completing the form!</p>
            <div class="summary">
                <p>Name: {formState.answers.name}</p>
                <p>Birthday: {new Date(formState.answers.birthday).toLocaleDateString()}</p>
            </div>
        </div>
    {:else}
        <!-- Show progress bar and current form step -->
        <div class="progress-container">
            <div class="progress-bar" style="width: {getProgress()}%"></div>
            <p class="step-indicator">Step {formState.step + 1} of {QUESTIONS.length}</p>
        </div>

        <!-- Render current question -->
        {#each QUESTIONS as question, index (question.id)}
            {#if formState.step === index}
              <div
                in:fly={{ x: 200, duration: 200, opacity: 0, delay: 200 }}
                out:fly={{ x: -200, duration: 200, opacity: 0 }}
              >
                {@render formStep(question)}
              </div>
            {/if}
        {/each}

        <!-- Display error message if any -->
        {#if formState.error}
            <p class="error">{formState.error}</p>
        {/if}
    {/if}
</main>

<!-- Form step template -->
{#snippet formStep(question: Question)}
    <article class="form-step">
        <form 
            onsubmit={() => nextStep(question.id)}
            class="form-content"
        >
            <div class="input-group">
                <label for={question.id}>{question.question}</label>
                <!-- Bind input value to formState.answers -->
                <input
                    {...question}
                    required
                    bind:value={formState.answers[question.id]}
                    class="form-input"
                />
            </div>

            <div class="button-group">
                <!-- Show Previous button if not on first step -->
                {#if formState.step > 0}
                    <button 
                        type="button"
                        onclick={previousStep}
                        class="btn btn-secondary"
                    >
                        Previous
                    </button>
                {/if}

                <!-- Show Submit on last step, otherwise Next -->
                <button 
                    type="submit"
                    class="btn btn-primary"
                >
                    {formState.step === QUESTIONS.length - 1 ? 'Submit' : 'Next'}
                </button>
            </div>
        </form>
    </article>
{/snippet}

<style>
    main {
        max-width: 600px;
        margin: 0 auto;
        padding: 2rem;
    }

    .progress-container {
        width: 100%;
        height: 8px;
        background-color: #eee;
        border-radius: 4px;
        margin: 1rem 0;
        overflow: hidden;
    }

    .progress-bar {
        height: 100%;
        background-color: #4CAF50;
        transition: width 0.3s ease;
    }

    .step-indicator {
        text-align: center;
        color: #666;
        margin: 0.5rem 0;
    }

    .form-step {
        margin: 2rem 0;
    }

    .form-content {
        display: flex;
        flex-direction: column;
        gap: 1.5rem;
    }

    .input-group {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }

    .form-input {
        padding: 0.5rem;
        border: 1px solid #ccc;
        border-radius: 4px;
        font-size: 1rem;
    }

    .button-group {
        display: flex;
        gap: 1rem;
        justify-content: flex-end;
    }

    .btn {
        padding: 0.5rem 1rem;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 1rem;
        transition: background-color 0.2s;
    }

    .btn-primary {
        background-color: #4CAF50;
        color: white;
    }

    .btn-primary:hover {
        background-color: #45a049;
    }

    .btn-secondary {
        background-color: #f0f0f0;
        color: #333;
    }

    .btn-secondary:hover {
        background-color: #e0e0e0;
    }

    .error {
        color: #d32f2f;
        margin-top: 1rem;
        font-size: 0.875rem;
    }

    .completion {
        text-align: center;
        padding: 2rem;
    }

    .summary {
        margin-top: 1rem;
        padding: 1rem;
        background-color: #f5f5f5;
        border-radius: 4px;
    }
</style>
