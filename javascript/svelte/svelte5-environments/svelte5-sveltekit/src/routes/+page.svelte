<script lang="ts">
	import { onMount } from 'svelte';

	import Header from './header.svelte';
	import Navigation from './navigation.svelte';

	const navigation = [
		{
			name: 'General',
			panel: 'general'
		},
		{
			name: 'Custom',
			panel: 'custom'
		},
		{
			name: 'Advanced',
			panel: 'advanced'
		}
	]

	let mounted = false;

	onMount(() => {
		mounted = true;
	});
</script>

{#if mounted}
	<wa-page class="wa-dark">
		<header slot="header" class="header">
			<Header />
		</header>
		<nav>
			<Navigation />
		</nav>

		<main class="main-content">
			Main Content
		</main>

		<footer slot="footer">
			Footer Content
		</footer>
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
