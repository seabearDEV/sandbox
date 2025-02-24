<script lang="ts">
	import { onMount } from 'svelte';
	import Header from './header.svelte';

	let mounted = false;

	onMount(() => {
		mounted = true;
	});
</script>

{#if mounted}
	<wa-page>
	<header slot="header" class="header">
		<Header />
	</header>
</wa-page>
{/if}

<style>
	.header {
		background-color: #333;
		color: white;
		padding: 1rem;
		text-align: center;
	}
</style>