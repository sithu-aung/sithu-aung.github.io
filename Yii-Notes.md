# Yii Notes

### Create New Project
 
 - composer create-project --prefer-dist yiisoft/yii2-app-basic basic
 
 ### Run with docker
  - docker-compose run --rm php composer update --prefer-dist
  - docker-compose run --rm php composer install
  - docker-compose up -d

### Steps to run project
 ### 1. Link Herd
  - herd link crm 

 ### 2. Extra Add Ons
  - composer install
  - cp config/sample.secret_params.php config/secret_params.php

 ### 3. Create Database 
  - brew services start postgresql 
  - psql postgres
  - createuser --interactive --pwprompt ( optional)
  - CREATE DATABASE new_database_name;

 ### 4. Table Migration 
  - php yii migrate/fresh


    ### Migrations

    ### Create Table
    - php yii migrate/create create_post_table --fields="title:string(12):notNull:unique,body:text"
    - php yii migrate/create create_post_table --fields="author_id:integer:notNull:foreignKey(user),category_id:integer:defaultValue(1):foreignKey,title:string,body:text"

    ### Drop Table
    - php yii migrate/create drop_post_table ----fields="title:string(12):notNull:unique,body:text"

    ### Add Column
    - php yii migrate/create add_position_column_to_post_table --fields="position:integer"

    ### Drop Column
    - php yii migrate/create drop_position_column_from_post_table --fields="position:integer"

    ### Add Junction Table
    - php yii migrate/create create_junction_table_for_post_and_tag_tables --fields="created_at:dateTime"

    ### Relations via a Junction Table 
    In data modelling, multiplicity between two related tables is many-to-many, junction-table is usually introduced. 


### 5. Import Commands
  - ./yii import/all ( will run ImportController/actionAll)
  - ./yii hello/index ( will run HelloController/actionIndex)

# Application Architecture

### Entry Script

- App bootstrap ဆွဲတင်တဲ့ script file ( web/index.php)
- Debug/Env သတ်မှတ် ( ..config/web.php)

new (yii\Web\Application($config))->run();

### Applications ( \Yii::$app)

 - web application or console application
 ( ID , basePath , alias , components )
 - for constants ( params ) -> Global variable

### Controllers 
  - extends yii\base\Controller
  - responsible for handling user request and return response
  - like actionIndex() , actionView() , actionCreate() , actionUpdate() , actionDelete()
  - ControllerMap is used when using third-party controllers and you do not have control over their class names. 
   eg - in application configurations
[
    'controllerMap' => [
        // declares "account" controller using a class name
        'account' => 'app\controllers\UserController',

        // declares "article" controller using a configuration array
        'article' => [
            'class' => 'app\controllers\PostController',
            'enableCsrfValidation' => false,
        ],
    ],
]

### Models
   - extends yii\base\Model
   - responsible for representing business data and logic
   - like validation , business logic , data access

   with active record
   - extends yii\db\ActiveRecord
   - responsible for representing data from a database
   - like find() , findOne() , save() , delete()
   - can be used to perform database operations

### Views
   - responsible for rendering the user interface
   - With controllers, these methods can be used to render the user interface
   ( render() , renderPartial() ,renderAjax(), renderContent(), renderFile() )

   ### Layouts
   - separate common views as layout and reuse in every views

### Filters
   - responsible for filtering the user request and return response
   - like beforeAction() , afterAction()
   
   ### Core Filters
   - Access Filters
   - Content Negotiator Filter ( - format ( like Json, Language))
   - Http Cache Filter
   - Rate Limiter Filter
   - Verb Filter
   - CORS Filter (Cross Origin Resource Sharing)

### Routing & URL Creation

   When a user make a request and Yii application starts to handle this,
   - parse Url to route ( that is why it is called Routing)
   - Route is used to instantiate the corresponding controller action to handle the request

   The Reverse flow is called URL Creation

  Url format - Default Url format with /r -   like (r=post/view&id=10)
             - Pretty Url format without /r - like (post/10)
               Switch by enabling enablePrettyUrl in application component

### Requests

   Yii::$app:->request;

   ### get body params
   Yii::$app:->request->bodyParams;
   $request->getBodyParams("");

   ### get query params
   Yii::$app:->request->queryParams;

   Header names are case insensitive. And the newly registered headers are not sent to the user until the yii\web\Response::send() method is called.

### Response

   With Status Code

   - yii\web\BadRequestHttpException: status code 400.
   - yii\web\ConflictHttpException: status code 409.
   - yii\web\ForbiddenHttpException: status code 403.
   - yii\web\GoneHttpException: status code 410.
   - yii\web\MethodNotAllowedHttpException: status code 405.
   - yii\web\NotAcceptableHttpException: status code 406.
   - yii\web\NotFoundHttpException: status code 404.
   - yii\web\ServerErrorHttpException: status code 500.
   - yii\web\TooManyRequestsHttpException: status code 429.
   - yii\web\UnauthorizedHttpException: status code 401.
   - yii\web\UnsupportedMediaTypeHttpException: status code 415.

  ### For sending back Files
   - sendFile() , sendContentAsFile() , sendStreamAsFile()
   return \Yii::$app->response->sendFile('path/to/file.txt');

  CSRF (Cross site request frogery)

  ### Caching

  - Data caching
  - Fragment caching - catch a Fragment of Web Page
  - Page caching - catch a whole Web Page
  - HTTP caching - catch HTTP response

### Databases
  
  - DAO (Database Access Objects)

  ### Active Record
  - extends yii\db\ActiveRecord
  - responsible for representing data from a database
  - like find() , findOne() , save() , delete() (Customer()::find())


  ### Optimistics Locking
  - a way to prevent conflicts that may occur when a single row of data is being updated by multiple users

  When user A and B is editing the same row, user A edits first and after recently, user B make edits to the same row , it will show Error Message - like StaleObject Exception.

    In Controller - 
    
    try{ } catch(StaleObjectException $e){

    }

    In Model - 

    use yii\behaviors\OptimisticLockBehavior;

      public function behaviors()
      {
         return [
             OptimisticLockBehavior::class,
         ];
      }

      public function optimisticLock()
      {
         return 'version';
      }

   ### Declaring Relations

    - hasMany/hasOne

    class Customer extends ActiveRecord{

      public funtion getOrders(){

         return $this->hasMany(Order::class, ['customer_id' => 'id]);

      }
    }

    - To Access customer orders

     $customer = Customer::findOne(123);

     $customer->orders;

     $customer->getOrders()
     ->where(['>', 'subtotal', 200])
     ->orderBy('id')
     ->all();

     OR

     class Customer extends ActiveRecord{

      public funtion getBigOrders($threshold = 100){

         return $this->hasMany(Order::class, ['customer_id' => 'id])
         ->where('subtotal > :threshold', [':threshold' => $threshold])
         ->orderBy('id);

      }
    }

   ### Junction Table

   class Order extends ActiveRecord{
      public function getItems(){
            return $this->hasMany(Item::class, ['id' => 'item_id'])
            -> viaTable('order_item', ['order_id','id']);
      }
   }

   ### Lazy Loading and Eager Loading
   - Eager Loading is to solve N+1 query count problem
   - implementation ( Customer()::find()->with([
      'country',
      'orders' => function ($query){
         $query->andWhere(['status' => Order::STATUS_ACTIVE])
      }
   ]) )

   ### Joining Tables
    $customers = Customer::find()
      ->joinWith('orders')
      ->where(['order.status' => Order::STATUS_ACTIVE])
      ->all();


   ### Migrations
   
    ### Create Table
    - php yii migrate/create create_post_table --fields="title:string(12):notNull:unique,body:text"
    - php yii migrate/create create_post_table --fields="author_id:integer:notNull:foreignKey(user),category_id:integer:defaultValue(1):foreignKey,title:string,body:text"

    ### Drop Table
    - php yii migrate/create drop_post_table ----fields="title:string(12):notNull:unique,body:text"

    ### Add Column
    - php yii migrate/create add_position_column_to_post_table --fields="position:integer"

    ### Drop Column
    - php yii migrate/create drop_position_column_from_post_table --fields="position:integer"

    ### Add Junction Table
    - php yii migrate/create create_junction_table_for_post_and_tag_tables --fields="created_at:dateTime"


### Restful API Services

  - REpresentational State Transfer (REST)
  - RESTful Web Service is a way of providing interoperability between computer systems on the internet.

  ### Rate Limiting
  - 

  ### Customizing Error Response
  
  - return [
    // ...
    'components' => [
        'response' => [
            'class' => 'yii\web\Response',
            'on beforeSend' => function ($event) {
                $response = $event->sender;
                if ($response->data !== null && Yii::$app->request->get('suppress_response_code')) {
                    $response->data = [
                        'success' => $response->isSuccessful,
                        'data' => $response->data,
                    ];
                    $response->statusCode = 200;
                }
            },
        ],
    ],
  ];

  ### Mailer
  
  Yii::$app->mailer->compose()
        ->setFrom("from@gmail.com")
        ->setTo("to@gmail.com")
        ->setSubject("Subject")
        ->setTextBody("Body")
        ->setHtmlBody("HtmlBody")
        ->send();

  Complex Example

  - $message = Yii::$app->mailer->compose();
    if (Yii::$app->user->isGuest) {
    $message->setFrom('from@domain.com');
    } else {
    $message->setFrom(Yii::$app->user->identity->email);
    }
    $message->setTo(Yii::$app->params['adminEmail'])
    ->setSubject('Message subject')
    ->setTextBody('Plain text content')
    ->send();

   ### Customizing Response
   
    $response = [
            'order' => $order->attributes,
            'items' => [],
    ];

    $items = $order->getItems()->all();

    foreach ($items as $item) {
      $response['order'][] = $item->attributes;
    }

    return [
         'status' => '200',
         'data' => $response,
    ];

   
