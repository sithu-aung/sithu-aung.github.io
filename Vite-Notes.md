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
