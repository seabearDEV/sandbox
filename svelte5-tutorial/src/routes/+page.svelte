<script lang="ts">
  import Header from './Header.svelte';

  let formState = $state({
    name: "",
    birthday: "",
    step: 0,
    error: ''
  });
</script>

<main>
  <Header name={formState.name} />

  <p>Step: {formState.step + 1}</p>

  {@render formStep({
    question: 'What is your name',
    id: 'name',
    type: 'text'
  })}

  

  {#if formState.error}
    <p class="error">{formState.error}</p>
  {/if}

</main>

{#snippet formStep({question, id, type}: {
  type: string;
  id: string;
  question: string;
})}
  <article>
    <div>
      <label for={id}>{question}</label>
      <input type={type} {id} bind:value={formState[id]}>
    </div>
  </article> 
{/snippet}

<style>
  .error {
    color: red;
  }
</style>