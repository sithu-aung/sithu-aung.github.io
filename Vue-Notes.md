# Vue Notes

### Vue - Progressive Javascript Framework for building UI

### Core Features of Vue
  1. Declarative Rendering - using of import
  2. Reactivity  - usage of ref()

### Single File Component (SFC)
  - encapsulate Component Logic( Javascript) + template (HTML) + styles (CSS)

### API Styles​
 1. Options API  (usage of data, methods , mounted)
 2. Composition API (usage of <script setup>)
 
### DOM - Document Object Model

  - API that load to show in web browser
  - Having thousands of nodes in single DOM -> Virtual DOM = represent actual DOM with Javascript Objects
  - DOM Vs Virtual DOM ( Blue Print Vs Actual)


### Text Interpolation
     "Mustache" ( မုတ်ဆိတ် ) syntax  - {{ msg }}
   - For Raw Html
      
    <span v-html="rawHtml"></span>  
 
  - For Attribue Binding
     Mustaches can not be used inside HTML Attribues

       <div v-bind:id="dynamicId"></div>
       
### Same-name Shorthand (over Vue 3.4)
   If the attribue has the same name with the Javascript value being bound, the syntax can be shortened to mit the attribute value: 
   
    <!-- same as :id="id" -->
    <div :id></div>
    <!-- this also works -->
    <div v-bind:id></div>

### Calling Functions - Functions can be called inside a binding expression

### Directives - special attributes with the v- prefix.

### Arguments - definded by a colon after the directive name
   
    <a v-bind:href="url"> .. </a>
    <!-- shorthand -->
    <a :href="url"> ... </a>
   -  Dynamic arguement - wrap with square brackets

### Reactivity 
    
    import { ref } from 'vue'

    export default {
    // `setup` is a special hook dedicated for the Composition API.
    setup() {
      const count = ref(0)

      function increment(){
        //.value is needed in Javascript
        count.value++;
      }

      // expose the ref to the template
      return {
        count
      }
     }
    }

  - Why need refs with .value instead of plain variables

    In standard Javascript, no way to detect the access or mutation of plain variables, but by intercepting the get and set operations of an objects' properties.

    Ref can hold any value type - nested objects, arrays or Javascript built-in data structures like Map.

### Shallow Refs - for avoiding the observation cost of large objects.

### Change to Reactive state, DOM is updated automatically. But not synchronously. Vue buffers util 'next tick' no matter how many state changes made.
   - To wait for the DOM update to complete after a state change, you can use the nextTick() global API:
     
    import { nextTick } from 'vue'

    async function increment() {
      count.value++
      await nextTick()
      // Now the DOM is updated
    }

### reactive()

 - Unlike ref that wraps the inner value in a special object, reactive() itself reactive.

### Computed property

- For complex logic that includes reactive data like getting total of books objects in reactive

       <script setup>
      import { reactive, computed } from 'vue'

      const author = reactive({
        name: 'John Doe',
        books: [
          'Vue 2 - Advanced Guide',
          'Vue 3 - Basic Guide',
          'Vue 4 - The Mystery'
        ]
      })

      // a computed ref
      const publishedBooksMessage = computed(() => {
        return author.books.length > 0 ? 'Yes' : 'No'
      })
      </script>

      <template>
        <p>Has published books:</p>
        <span>{{ publishedBooksMessage }}</span>
      </template>

  - will update when author.books changes.

 ### Computed Caching vs Methods

   - Computed properties are cached based on their reactive dependencies and will only re-evaluate when some of its reactive dependencies have changed.
   - Method invocation will always run the function whenever a re-render happens.

### Computed property are by default getter only. For writable computed, set getter and setter.

      <script setup>
      import {ref,computed} from 'vue'

      const firstName = ref('Eric');
      const lastName =  ref('Scheidel');

      const fullName = computed({
        //getter
        get(){
          return firstName.value + ' ' + lastName.value
        },
        set(newValue){
          [firstName.value,lastName.value] = newValue.split(' ')
        }
      });

      </script>


- Getter should be side effect free
- Avoid mutating computed value

### Class and Style Bindings

  :class ( short hand for v-bind:class)

    <div :class="{ active: isActive }"></div>

### Conditional Rendering ( v-if, v-else , v-else-if )

    <button @click="awesome = !awesome">Toggle</button>
    
    <h1 v-if="awesome">Vue is awesome!</h1>
    <h1 v-else>Oh no 😢</h1>

- For toggling more than one element, add v-if in <template>

### v-if Vs v-show
- v-show if toggle something very often ( higher initial render cost)
- v-if if condition is unlikely to change at runtime ( higher toggle cost )
    
### List Rendering ( v-for )

    const items = refe([{ message: 'Hello'} , { message: 'World'}]);

    <li v-for:"(item,index|key) in|of items">
      {{ item.message }}
    </li>

- With a range 

       <span v-for="n in 10"> {{ n }}</span>
- Recommended to provide a key attribute with v-for whenever possible including in Components, unless the iterated DOM content is simple

### Array Change Detection

  - push()
  - pop()
  - shift()
  - unshift()
  - splice()
  - sort()
  - reverse()

- filter(),contact() and slice() do not mutate original array, but always return a new array() , so need to replace old array with new one

       items.value = items.value.filter((item)=> item.message.match(/Foo/));

- for displaying Filtered/Sorted Resluts - Use with computed

       import {computed} from 'vue'
       const numbers = ref([1,2,3,4,5]);

       const evenNumbers = computed(()=>{
          return numbers.filter((n)=> n% 2 === 0)
       })

  ### Listening to Events

  - v-on:click="handler" -> shortcut -> @click="handler"
    1. Inline Hander - Inline Javascript
    2. Method Handler - call a Method
   
  ### Access Event Argument in Inline Handlers

        <!--- using $event special variable --->
        <button @click="warn('Some Warning',$event)">
          Submit
        </button>
  
        <!--- using inline arrow function --->
        <button @click="(event)=> warn('Some Warning',event)">
          Submit
        </button>

    Event Modifiers ( can be chainded like - .stop.prevent
  - .stop
  - .prevent
  - .self
  - .capture
  - .once
  - .passive
 
    Key Modifiers for Keyboard Event ( with @keyup )
  - .enter
  - .tab
  - .space
  - .esc
  - .delete ( captures both 'Delete' and 'Backspace' keys)
  - .up
  - .down
  - .left
  - .right
 
    System Modifiers 
  - .ctrl
  - .alt
  - .shift
  - .meta
  - use .exact for only defined system keys like @click.ctrl.exact or @click.exact - no system modifiers are pressed

        <input @keyup.alt.enter="clear" />
        <!-- Ctrl + Click -->
        <div @click.ctrl="doSomething">Do something</div>
 
     Mouse Button Modifiers ( with @mouse )
    - .left
    - .right
    - .middle

### Form Input Bindings

        <input 
        :value="text"
        @input="event => text = event.target.value">

v-model directive helps to 

       <input v-model="text">

 1. Textbox - <input></input>
 2. Multiline Text - <textarea v-model="text"></textarea>
 3. Checkbox - <input type="checkbox" v-model="checkNames" value="test"></input><label for="test">Test</label>
 4. Radio - <input type="radio" id="one" value="One" v-model="picked" -> same value for all/>
 5. Select - <select v-model="selected"> <option disabled value=""> </option> <option> Option A </option> </select>

 ### LifeCycle Hooks

 onMounted hook can be used to run after component initial rendering and created DOM nodes

 ### Watchers

 - watch function to trigger callback whenever a piece of reactive state changes:

       <script setup>
       import {ref,watch} from 'vue'

        const question = ref('')
       const answer = ref('Answer 1')
       const loading = ref(false);

       watch(question, async ( new , old )=>{
        if(new.includes('?'){
         loading.value = true
         answer.value = 'Thinking ... '
        try{
           const res = await fetch("test_url")
           answer.value = (await res.json()).answer
         } catch(error){
           answer.value = "error"
         } finally {
           loading.value = false
         }
        }
       });

       </script>

       <template>
         <p> Ask a yes/no question:
           <input v-model="question" :disabled="loading">
         </p>
         <p> {{ answer }} </p>
       </template>

   - default lazy watcher only whenever relevant state changes
   - Eager Watchers - with passing { immediate: true } option
   - Once Watchers ( Vue 3.4+) - with passing { once: true } option
   - WatchEffect() - no need to pass ref to be watched
   - Post Watchers - for avoiding multiple update state with passing { flush: 'post'}
   - Sync Watchers - with passing { flush: 'sync' }
   - Stopping Watchers - set by const unwatch = watchEffect();  and unwatch()
  
### Components

   - Props - custom attributes that are registered on a component - defineProps(['prop_name'])

     <!-- BlogPost.vue -->
    <script setup>
    defineProps(['title'])
    </script>

    <template>
      <h4>{{ title }}</h4>
    </template>

  - Then pass to it
    
         const posts = ref([
        { id: 1, title: 'My journey with Vue' },
        { id: 2, title: 'Blogging with Vue' },
        { id: 3, title: 'Why Vue is so fun' }
        ])

        <BlogPost
        v-for="post in posts"
        :key="post.id"
        :title="post.title"
         />

    - Emits - catching emitted events from component - defineEmits('event-name'])
   
    - Slot <slot /> can be used for passig content to a component
    - Dynamic component with <component :is="tabs[currentTab]"></component>

          <ConfirmDialog
          :is-open="isLogoutDialogOpen" title="Confirm" message="Are you sure you want to logout?"
          @close="isLogoutDialogOpen = false" @ok="logout"
          />

### Component Registeration - Global vs Local

- Global ( using app.component() )
- Local ( import ComponentA from './ComponentA.vue'; in <script setup> </script>) - not even availble for descendant components.

- Use <PascalCase /> for Naming
- set Alias in Vite.config.js for ( for ./src/components -> @/components )
    
         import { fileURLToPath , URL } from 'node:url'
         alias: {
            '@' : fileURLToPath(new URL('./src',import.meta.url))
         }

### Props
  - with macro defineProps()
  - any type of value can be passed to a prop - (Number, Boolean, Array, Object)
  - one way data flow - child component can't mutate parent's state
  - parent component change -> child component refresh
  - To change in child componet only, can use with computed() or adding to a ref()
  - To change to parent component, use Emits.

### V-model = props + events
    <!-- Parent.vue -->
    <Child v-model="countModel" />
-
    <!-- Child.vue -->
      <script setup>
      const model = defineModel()

      function update() {
        model.value++
      }
      </script>

      <template>
        <div>Parent bound v-model is: {{ model }}</div>
        <button @click="update">Increment</button>
      </template>



     

