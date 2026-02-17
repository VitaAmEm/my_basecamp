# Welcome to My Basecamp 1
***

## Task
The goal of this project is to recreate core features of Basecamp using a Ruby on Rails MVC architecture. The project was developed collaboratively in two main parts:
1. Part I — Build the user system and authentication. User registration with encrypted passwords using bcrypt, User model with validations (email presence and uniqueness, password length validation), Admin role system (admin boolean with default false), UsersController with RESTful actions (new, create, index, show, destroy), Home page setup, Flash messages for user feedback, Database migrations and schema design, Initial UI structure.
2. Part II - Sessions and Projects. User login and logout (session management), Role permission management (admin promotion/removal), Project model and migrations, ProjectsController with full CRUD functionality (new, create, show, edit, update, destroy), Authorization logic (owner/admin permissions), Project views and routes.
The main learnings were about Ruby on Rails MVC architecture, authentication and authorization design, database migrations and schema management, collaborative Git workflow and Full-stack web development.
The main challenge was to implement a full-stack web application with user authentication, role management (admin/user), proper authorization, good user experience, project CRUD operations.  

## Description
The platform allows users to register securely using encrypted passwords, sign in and sign out through session management, and manage their personal profiles. The system supports role management, allowing users to be promoted to administrators or have administrative privileges removed. Authenticated users can create new projects, view project details, update existing projects, and delete projects when authorized.

## Installation
1) Clone the repository and enter the project folder:
git clone https://github.com/VitaAmEm/my_basecamp.git
cd my_basecamp

2) Install dependencies (gems):
bundle install

3) Create and setup the database:
rails db:create
rails db:migrate

4) Start the Rails server:
rails server

5) Open in browser:
http://localhost:3000

## Usage
After starting the server, open a web browser and navigate to http://localhost:3000
From there, a new user can register an account and will be automatically authenticated. Authenticated users can create and manage projects through the interface. Project owners and administrators have permission to update or delete projects, while regular users are restricted to their own resources. Administrators additionally have the ability to manage user roles within the platform.

### The Core Team
Vita - Part I: User authentication foundation, User model and controller, database structure, role system base, UX setup.
Zlata - Part II: Project model and migration, a ProjectsController with all RESTful actions, routes and views, plus owner/admin authorization.
