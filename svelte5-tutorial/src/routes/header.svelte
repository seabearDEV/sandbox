<script lang="ts">
	import type { Snippet } from "svelte";

  let {
    name
  }: {
    name: string;
  } = $props();
</script>

<div>
  <h1>
    {name ? name : 'User'}'s Form
  </h1>
</div>