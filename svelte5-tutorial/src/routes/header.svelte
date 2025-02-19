<script lang="ts">
  let {
    name,
    fake_name
  }: {
    name: string;
    fake_name?: string;
  } = $props();
</script>

<h1>Hello {name}</h1>
<h2>{name.replace("y", "x")}</h2>
{fake_name}

<style>

</style>