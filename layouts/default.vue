<template>
  <div class="flex flex-col min-h-screen">
    <header class="bg-primary-600 text-white shadow-md">
      <div class="container mx-auto px-4 py-4 flex justify-between items-center">
        <NuxtLink to="/" class="text-2xl font-bold">TODO App</NuxtLink>
        <nav class="space-x-4">
          <NuxtLink to="/" class="hover:text-primary-200 transition-colors">Tasks</NuxtLink>
          <NuxtLink to="/create" class="hover:text-primary-200 transition-colors">Create Task</NuxtLink>
        </nav>
      </div>
    </header>
    
    <main class="flex-grow container mx-auto px-4 py-8">
      <slot />
    </main>
    
    <footer class="bg-gray-100 border-t border-gray-200">
      <div class="container mx-auto px-4 py-4 text-center text-gray-600">
        <p>&copy; {{ new Date().getFullYear() }} TODO Application</p>
      </div>
    </footer>
  </div>
</template>

