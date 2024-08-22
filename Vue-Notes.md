# Vue Notes

### Vue - Progressive Framework

### Single File Component (SFC)
  - encapsulate Component Logic( Javascript) + template (HTML) + styles (CSS)

### API Styles​
 1. Options API  (usage of data, methods , mounted)
 2. Composition API (usage of <script setup>)
 
### DOM - Document Object Model

  - API that load to show in web browser
  - Having thousands of nodes in single DOM -> Virtual DOM = represent actual DOM with Javascript Objects
  - DOM Vs Virtual DOM ( Blue Print Vs Actual)
  
### Core Features of Vue
  1. Declarative Rendering - using of import
  2. Reactivity  - usage of ref()

# Vite Notes

  Vite improves the dev server start time by first dividing the modules into
   1. Dependencies
   2. Source Code
   
   Vite pre-bundles dependencies using esbuild - written in Go. 10-100x faster than Javascript-based bundlers.

   Vite servers source code over native ESM. Transform and server source code on demand as the browser requests it.

   Bundle Based Vs ESM Based dev server

   - Bundle Based = entry -> multi routes -> multi modules -> Bundle -> Server Ready

   - Native ESM based = Server Ready -> HTTP request -> entry -> multi route -> multi modules 

   * ESM stands for ECMASript Modules

   Hot Module Replacement ( HMR ) is done by precisely invalidate the chain between the edited module and its closet HMR boundary.

  ### Project Create for Vue
  npm create vite@latest projected_name -- --template vue

  npm install
  npm rund build
