<!-- TypeScript-->
<script lang="ts">
	// Svelte Imports
	import { onMount } from 'svelte';

	// Component Imports
	import Header from './header.svelte';

	// Component Variables
	let mounted = false;

	onMount(() => {
		mounted = true;
	});
</script>

<!-- Content -->
<Header />

