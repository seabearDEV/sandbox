<script lang="ts">
  // Component Imports
  import Header from './header.svelte';

  // Component Variables
  let name = $state('Kory');
  let status: 'OPEN'| 'CLOSED' = $state('OPEN');

  let full_name = $derived(`${name} Hoopes`);

  function onclick() {
    status = status === 'OPEN' ? 'CLOSED' : 'OPEN';
  }

</script>

<Header {name} fake_name="Bobby" />

<h2>{full_name}</h2>

<input type="text" bind:value={name} />

<p>The store is now {status}</p>
<button {onclick}>Toggle Status</button>